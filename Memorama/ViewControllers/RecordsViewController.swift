//
//  RecordsViewController.swift
//  Memorama
//
//  Created by Victor Soto on 10/25/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit
import MessageUI
import SVProgressHUD

class RecordsViewController: UITableViewController {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var pendingRecords = Database.shared.pendingRecords
    var sentRecords = Database.shared.sentRecords
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        reloadRecords()
        updateControls()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segment
    
    var pendingRecordsSegment: Bool {
        return segmentedControl.selectedSegmentIndex == 0
    }
    
    // MARK: - Records
    
    fileprivate func reloadRecords() {
        pendingRecords = Database.shared.pendingRecords
        sentRecords = Database.shared.sentRecords
    }
    
    var numberOfPendingRecords: Int {
        if let pendingRecords = pendingRecords {
            return pendingRecords.count
        } else {
            return 0
        }
    }
    
    var numberOfSentRecords: Int {
        if let sentRecords = sentRecords {
            return sentRecords.count
        } else {
            return 0
        }
    }
    
    // MARK: - Controls
    
    func updateControls() {
        var numberOfItems: Int = 0
        if pendingRecordsSegment {
            actionButton.title = "Enviar"
            numberOfItems = numberOfPendingRecords
        } else {
            actionButton.title = "Borrar"
            numberOfItems = numberOfSentRecords
        }
        actionButton.isEnabled = numberOfItems > 0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingRecordsSegment ? numberOfPendingRecords : numberOfSentRecords
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let row = indexPath.row
        var recordToUse: Record? = nil
        if pendingRecordsSegment, let record = pendingRecords?[row] {
            recordToUse = record
        } else if !pendingRecordsSegment, let record = sentRecords?[row]{
            recordToUse = record
        }
        if let record = recordToUse {
            cell.textLabel?.text = "\(record.nombre) | \(record.ticket) | \(record.monto)"
            cell.detailTextLabel?.text = "\(record.fecha) | Ganó: \(record.gano) | Premio: \(record.premio) | Tienda: \(record.tienda)"
        }
        return cell
    }
    
    // MARK: - Actions
    
    @IBAction func valueChangedInSegmentedControl(_ sender: Any) {
        tableView.reloadData()
        updateControls()
    }
        
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        if pendingRecordsSegment {
            sendPendingRecords()
        } else {
            let alert = UIAlertController(title: "Borrar Registros", message: "¿Estás seguro de borrar los registros?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Sí", style: .default, handler: { _ in
                self.deleteSentRecords()
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Record Actions
    
    fileprivate func deleteSentRecords() {
        if let sentRecords = sentRecords {
            SVProgressHUD.show()
            Database.shared.deleteRecords(sentRecords)
            reloadRecords()
            tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    fileprivate func markPendingRecordsAsSent() {
        if let pendingRecords = self.pendingRecords {
            SVProgressHUD.show()
            Database.shared.markRecordsAsSent(pendingRecords)
            self.reloadRecords()
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    fileprivate func sendPendingRecords() {
        SVProgressHUD.show()
        FileManager.prepareCSVFileForRecords { data in
            if let data = data {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.sendEmailWith(data: data)
                }
            }
        }
    }
}

extension RecordsViewController : MFMailComposeViewControllerDelegate {
    
    // MARK: - Email
    fileprivate func sendEmailWith(data: Data) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["hazparconreebok@gmail.com"])
            mailComposer.setSubject("Registros: Haz Par con Reebok")
            mailComposer.addAttachmentData(data, mimeType: "text/csv", fileName: "Registros_Reebok.csv")
            present(mailComposer, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Enviar Correo", message: "Verifica que el dispositivo tenga una cuenta de correo dada de alta", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string:"App-Prefs:root=General")!, options: [:], completionHandler: nil)
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled, .saved:
            break
        case .failed:
            let alert = UIAlertController(title: "Enviar Correo", message: "Ocurrió un problema al enviar el correo, intenta nuevamente", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.sendPendingRecords()
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        case .sent:
            let alert = UIAlertController(title: "Correo Enviado", message: "Registros Enviados Exitosamente", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.markPendingRecordsAsSent()
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
