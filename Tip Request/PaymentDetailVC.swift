//
//  PaymentDetailVC.swift
//  Tip Request
//
//  Created by Jeffrey Barros Peña on 4/21/18.
//  Copyright © 2018 Barros Peña. All rights reserved.
//

import UIKit

class PaymentDetailVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var subtotalTextField: UITextField!
    @IBOutlet weak var dollarSign: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var noTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var payment: Payment?
    var newPayment = false
    var subtotal = 0.0
    var updated = false
    var navBarDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let payment = payment {
            //enableSavedMode()
            cancelButton.title = ""
            cancelButton.isEnabled = false
            subtotal = payment.subtotal
            showDetails()
            print("this is an EXISTING entry")
            print("subtotal: \(payment.subtotal)")
            print("tip %: \(payment.tip)")
            print("total: \(payment.total)")
            print("location: \(payment.location)")
        } else {
            self.navigationItem.title = "New Payment"
            payment = Payment()
            newPayment = true
            enableEditMode()
            print("this is a NEW entry")
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // dismiss keyboard by tapping anywhere on view
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        if self.isMovingFromParentViewController {
            self.performSegue(withIdentifier: "unwindFromPaymentDetailWithSegue", sender: self)
            //On click of back or swipe back
        }
//        if self.isBeingDismissed {
//            //Dismissed
//        }
    }
    
    // MARK: IBActions
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        print("cancel button pressed")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if editButton.title == "Edit" {
            enableEditMode()
        } else {
            if subtotalTextField.text == "" {
                showAlert(title: "Enter Subtotal", message: "You must enter a dollar value in the Subtotal field in order to save an entry.")
                return
            }
            if newPayment {
                //print("yer")
                savePayment()
                newPayment = false
                self.performSegue(withIdentifier: "unwindFromPaymentDetailWithSegue", sender: self)
            } else {
                savePayment()
                self.navigationItem.title = String(format: "$%.02f", (payment?.total)!)
                enableSavedMode()
            }
        }
    }
    
    
    @IBAction func subtotalChanged(_ sender: UITextField) {
        print("subtotal changed")
        var tipAmount = 0.0
        if subtotalTextField.text == "" {
            updateTotalLabel(isPrice: false)
            subtotal = 0
        } else {
            if let tempTotal = subtotalTextField.text {
                subtotal = Double(tempTotal)!
                switch tipSegment.selectedSegmentIndex {
                case 0:
                    tipAmount = subtotal * 0.1
                    updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
                case 1:
                    tipAmount = subtotal * 0.15
                    updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
                case 2:
                    tipAmount = subtotal * 0.2
                    updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
                case 3:
                    tipTextField.isHidden = false
                    percentLabel.isHidden = false
                    if tipTextField.text != "" {
                        if let tempTip = tipTextField.text {
                            tipAmount = subtotal * (Double(tempTip)! / 100)
                            updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
                        } else {
                            print("the tip percent entered is not valid")
                        }
                    } else {
                        tipAmount = subtotal * 0.25
                        updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
                    }
                default:
                    print("will never print")
                }
            } else {
                print("value entered into subtotal field cannot be converted to double")
            }
        }
        payment?.total = (subtotal+tipAmount)
        payment?.subtotal = subtotal
    }
    
    @IBAction func customTipChanged(_ sender: UITextField) {
        print("custom tip changed to \(tipTextField.text ?? "0")%")
        var tipAmount = 0.0
        if tipTextField.text == "" {
            tipAmount = subtotal * 0.25
            updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
            payment?.total = (subtotal+tipAmount)
            payment?.tip = 25.0
        } else {
            if let tempTip = tipTextField.text {
                tipAmount = subtotal * (Double(tempTip)! / 100)
                payment?.tip = Double(tempTip)!
                updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
                payment?.total = (subtotal+tipAmount)
            } else {
                print("the tip percent entered is not valid")
            }
        }
    }
    
    @IBAction func tipSegmentChanged(_ sender: UISegmentedControl) {
        print("tip segment changed to index \(tipSegment.selectedSegmentIndex)")
        tipTextField.isHidden = true
        percentLabel.isHidden = true
        var tipAmount = 0.0
        if subtotal == 0 {
            updateTotalLabel(isPrice: false)
            return
        }
        if tipTextField.text == "" {
            tipAmount = subtotal * 0.25
            updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
        }
        switch tipSegment.selectedSegmentIndex {
        case 0:
            tipAmount = subtotal * 0.1
            payment?.tip = 10.0
            updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
        case 1:
            tipAmount = subtotal * 0.15
            payment?.tip = 15.0
            updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
        case 2:
            tipAmount = subtotal * 0.2
            payment?.tip = 20.0
            updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
        case 3:
            tipTextField.isHidden = false
            percentLabel.isHidden = false
            if tipTextField.text != "" {
                if let tempTip = tipTextField.text {
                    tipAmount = subtotal * (Double(tempTip)! / 100)
                    payment?.tip = Double(tempTip)!
                    updateTotalLabel(isPrice: true, total: subtotal+tipAmount)
                } else {
                    print("the tip percent entered is not valid")
                }
            }
        default:
            print("will never print")
        }
        payment?.total = (subtotal+tipAmount)
    }
    
    
    // MARK: Helper functions
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction =  UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    func enableEditMode() {
        editButton.title = "Save"
        locationTextField.placeholder = "Restaurant Name"
        locationTextField.borderStyle = .roundedRect
        locationTextField.isEnabled = true
        dollarSign.isHidden = false
        subtotalTextField.isEnabled = true
        subtotalTextField.borderStyle = .roundedRect
        if subtotalTextField.text != "" {
            var subtotalText = subtotalTextField.text
            subtotalText?.removeFirst()
            subtotalTextField.text = subtotalText
            totalLabel.isHidden = false
            noTotalLabel.isHidden = true
        } else {
            totalLabel.isHidden = true
            noTotalLabel.isHidden = false
        }
        tipSegment.isHidden = false
        if tipSegment.selectedSegmentIndex == 3 {
            tipTextField.isHidden = false
            percentLabel.isHidden = false
        } else {
            tipTextField.isHidden = true
            percentLabel.isHidden = true
        }
        switch payment?.tip {
        case 10:
            tipSegment.selectedSegmentIndex = 0
        case 15:
            tipSegment.selectedSegmentIndex = 1
        case 20:
            tipSegment.selectedSegmentIndex = 2
        default:
            tipSegment.selectedSegmentIndex = 3
            if let tempTip = payment?.tip {
                tipTextField.isHidden = false
                percentLabel.isHidden = false
                tipTextField.text = String(tempTip)
            }
            
        }
        tipLabel.isHidden = true
    }
    func enableSavedMode() {
        locationTextField.placeholder = "Enter location in edit mode"
        if !updated {
            switch tipSegment.selectedSegmentIndex {
            case 0:
                tipLabel.text = "10%"
            case 1:
                tipLabel.text = "15%"
            case 2:
                tipLabel.text = "20%"
            case 3:
                if let tipText = tipTextField.text {
                    if tipTextField.text == "" {
                        tipLabel.text = "25%"
                    } else {
                        tipLabel.text = "\(tipText)%"
                    }
                }
            default:
                break
            }
        }
        
        // UPDATE UI
        editButton.title = "Edit"
        locationTextField.borderStyle = .none
        locationTextField.isEnabled = false
        locationTextField.backgroundColor = .white
        //locationTextField.text = payment?.location
        
        dollarSign.isHidden = true
        subtotalTextField.isEnabled = false
        subtotalTextField.borderStyle = .none
        subtotalTextField.backgroundColor = .white
        if !(subtotalTextField.text?.hasPrefix("$"))! {
            if let subtotalText = subtotalTextField.text {
                print("subtotalText: \(subtotalText)")
                let temp = Double(subtotalText)
                subtotalTextField.text = String(format: "$%.02f", temp!)
            }
        }
        
        //print(subtotalTextField.text)
        tipSegment.isHidden = true
        tipTextField.isHidden = true
        percentLabel.isHidden = true
        tipLabel.isHidden = false
        
        
        if newPayment {
            dismiss(animated: true, completion: nil)
            newPayment = false
        }
        noTotalLabel.isHidden = true
        
        updated = false
    }
    
    func updateTotalLabel(isPrice: Bool, total: Double? = 0.0) {
        if isPrice {
            totalLabel.isHidden = false
            noTotalLabel.isHidden = true
            totalLabel.text = String(format: "$%.02f", (total)!)
            totalLabel.font = UIFont(name: totalLabel.font.fontName, size: 33)
        } else {
            totalLabel.isHidden = true
            noTotalLabel.isHidden = false
        }
    }
    
    func showDetails() {
        //self.navigationItem.title = String(format: "$%.02f", (payment?.total)!)
        let date = formatTimeForTimeZone(date: (payment?.date)!, timeZone: (payment?.timeZone)!)
        self.navigationItem.title = date
        locationTextField.text = payment?.location
        if let sub = payment?.subtotal {
            subtotalTextField.text = String(format: "$%.02f", (sub))
        }
        //print(subtotalTextField.text)
        if let tempTip = payment?.tip {
            tipLabel.text = String(format: "%.0f%%", tempTip)
        }
        if let tempTotal = payment?.total {
            totalLabel.text = String(format: "$%.02f", (tempTotal))
        }
        updated = true
        enableSavedMode()
    }
    func savePayment() {
        payment?.location = locationTextField.text!
        if subtotalTextField.text != "" {
            if let subtotalText = subtotalTextField.text{
                payment?.subtotal = Double(subtotalText)!
            }
        } else {
            payment?.subtotal = 0.0
        }
    }
    func formatTimeForTimeZone(date: Date, timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/y | h:mmaaa"
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}
