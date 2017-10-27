//
//  RegisterViewController.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

extension UIColor {
    class var appDarkBlue : UIColor {
        return UIColor(red:0.004, green:0.302, blue:0.525, alpha:1.000)
    }
}

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ticketTextField: UITextField!
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var selectStoreButton: UIButton!
    @IBOutlet weak var sendRecordsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        addNotificationObserver()
        resetForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        removeNotificationObserver()
    }
    
    // MARK: - Notifications
    
    fileprivate func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(RegisterViewController.resetForm),
                                               name: NotificationCenter.NotificationIdentifier.ResetRegisterScreenNotification.notificationName,
                                               object: nil)
    }
    
    fileprivate func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NotificationCenter.NotificationIdentifier.ResetRegisterScreenNotification.notificationName,
                                                  object: nil)
    }
    
    // MARK: - Form
    
    @objc fileprivate func resetForm(debug: Bool = false) {
        selectStoreButton.isHidden = true
        sendRecordsButton.isHidden = true
        nameLabel.textColor = .appDarkBlue
        ticketLabel.textColor = .appDarkBlue
        amountLabel.textColor = .appDarkBlue
        nameTextField.text = nil
        ticketTextField.text = nil
        amountTextField.text = nil
        emailTextField.text = nil
        if debug {
            nameTextField.text = "Nombre"
            ticketTextField.text = "AAAAA000000"
            amountTextField.text = "1234.00"
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if Database.shared.store == "" {
            let alert = UIAlertController(title: "Escoge Tienda", message: "Anter de empezar, escoge una tienda", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Escoger", style: .default, handler: { _ in
                self.selectStoreButtonPressed(self.selectStoreButton)
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            validateForm()
        }
    }
    
    @IBAction func tapGestureDetected(_ sender: Any) {
        UIView.animate(withDuration: 0.4) {
            self.selectStoreButton.isHidden = !self.selectStoreButton.isHidden
            self.sendRecordsButton.isHidden = !self.sendRecordsButton.isHidden
        }
    }
            
    @IBAction func selectStoreButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "PresentStores", sender: self)
    }
    
    @IBAction func sendRecordsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "PresentRecords", sender: self)
    }
    
    // MARK: - Validations
    
    fileprivate func validateForm() {
        var validName = false
        if let name = nameTextField.text, name.count > 0 {
            validName = true
            nameLabel.textColor = .appDarkBlue
        } else {
            nameLabel.textColor = .red
        }
        var validTicket = false
        if let ticket = ticketTextField.text, ticket.count > 0 {
            validTicket = true
            ticketLabel.textColor = .appDarkBlue
        } else {
            ticketLabel.textColor = .red
        }
        var validAmount = false
        if let amount = amountTextField.text, amount.count > 0 {
            validAmount = true
            amountLabel.textColor = .appDarkBlue
        } else {
            amountLabel.textColor = .red
        }
        let validForm = validName && validTicket && validAmount
        if validForm {
            showGame()
        } else {
            let alert = UIAlertController(title: "Registro", message: "Revisa que tus datos estén correctos", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    fileprivate func showGame() {
        performSegue(withIdentifier: "ShowInstructions", sender: self)
        resetForm()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowInstructions", let instructionsViewController = segue.destination as? InstructionsViewController {
                var register = Register()
                register.name = nameTextField.text!
                register.ticket = ticketTextField.text!
                register.amount = amountTextField.text!
                register.email = emailTextField.text ?? ""
                instructionsViewController.register = register
            }
        }
    }
    
}

