//
//  RecordsViewController.swift
//  Memorama
//
//  Created by Victor Soto on 10/25/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

class RecordsViewController: UITableViewController {
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var pendingRecords = Database.shared.pendingRecords
    var sentRecords = Database.shared.sentRecords
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
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
        
    }
    
    fileprivate func sendPendingRecords() {
        
    }
    
}
