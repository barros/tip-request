//
//  ViewController.swift
//  Tip Request
//
//  Created by Jeffrey Barros Peña on 4/11/18.
//  Copyright © 2018 Barros Peña. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var subtotalTextField: UITextField!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var tipTextField: UITextField!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var walletImage: UIImageView!
    @IBOutlet weak var launchWalletLabel: UILabel!
    
    var total = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipTextField.isHidden = true
        percentLabel.isHidden = true
        
        // dismiss keyboard by tapping anywhere on view
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    // MARK: IBActions
    @IBAction func subtotalChanged(_ sender: UITextField) {
        print("subtotal changed")
        if subtotalTextField.text == "" {
            updateTotalLabel(isPrice: false)
            total = 0
        } else {
            if let tempTotal = subtotalTextField.text {
                total = Double(tempTotal)!
                switch tipSegment.selectedSegmentIndex {
                case 0:
                    let tip = total * 0.1
                    updateTotalLabel(isPrice: true, total: total+tip)
                case 1:
                    let tip = total * 0.15
                    updateTotalLabel(isPrice: true, total: total+tip)
                case 2:
                    let tip = total * 0.2
                    updateTotalLabel(isPrice: true, total: total+tip)
                case 3:
                    tipTextField.isHidden = false
                    percentLabel.isHidden = false
                    if tipTextField.text != "" {
                        if let tempTip = tipTextField.text {
                            let tip = total * (Double(tempTip)! / 100)
                            updateTotalLabel(isPrice: true, total: total+tip)
                        } else {
                            print("the tip percent entered is not valid")
                        }
                    } else {
                        let tip = total * 0.25
                        updateTotalLabel(isPrice: true, total: total+tip)
                    }
                    
                    
                default:
                    print("will never print")
                }
            } else {
                print("value entered into subtotal field cannot be converted to double")
            }
        }
    }
    @IBAction func customTipChanged(_ sender: UITextField) {
        print("custom tip changed to \(tipTextField.text ?? "0")%")
        if tipTextField.text == "" {
            let tip = total * 0.25
            updateTotalLabel(isPrice: true, total: total+tip)
        } else {
            if let tempTip = tipTextField.text {
                let tip = total * (Double(tempTip)! / 100)
                updateTotalLabel(isPrice: true, total: total+tip)
            } else {
                print("the tip percent entered is not valid")
            }
        }
    }
    @IBAction func tipSegmentChanged(_ sender: UISegmentedControl) {
        print("tip segment changed to index \(tipSegment.selectedSegmentIndex)")
        tipTextField.isHidden = true
        percentLabel.isHidden = true
        if total == 0 {
            updateTotalLabel(isPrice: false)
            return
        }
        if tipTextField.text == "" {
            let tip = total * 0.25
            updateTotalLabel(isPrice: true, total: total+tip)
        }
        switch tipSegment.selectedSegmentIndex {
        case 0:
            let tip = total * 0.1
            updateTotalLabel(isPrice: true, total: total+tip)
        case 1:
            let tip = total * 0.15
            updateTotalLabel(isPrice: true, total: total+tip)
        case 2:
            let tip = total * 0.2
            updateTotalLabel(isPrice: true, total: total+tip)
        case 3:
            tipTextField.isHidden = false
            percentLabel.isHidden = false
            if tipTextField.text != "" {
                if let tempTip = tipTextField.text {
                    let tip = total * (Double(tempTip)! / 100)
                    updateTotalLabel(isPrice: true, total: total+tip)
                } else {
                    print("the tip percent entered is not valid")
                }
            }
        default:
            print("will never print")
        }
    }
    
    @IBAction func openWallet(_ sender: UITapGestureRecognizer) {
        print("tried to open wallet")
        let walletURL = "shoebox://"
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open Apple Wallet.", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            if let url = URL(string: walletURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    // MARK: Helper functions
    func updateTotalLabel(isPrice: Bool, total: Double? = 0.0) {
        if isPrice {
            totalLabel.text = String(format: "$%.02f", (total)!)
            totalLabel.font = UIFont(name: totalLabel.font.fontName, size: 33)
        } else {
            totalLabel.text = "Please enter the total of your meal above"
            totalLabel.font = UIFont(name: totalLabel.font.fontName, size: 17)
        }
        totalLabel.sizeToFit()
        totalLabel.textAlignment = .center
        totalLabel.center.x = self.view.center.x
    }
    func doneButtonAction() {
        self.view.endEditing(true)
    }
}
