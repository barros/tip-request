//
//  ListVC.swift
//  Tip Request
//
//  Created by Jeffrey Barros Peña on 4/21/18.
//  Copyright © 2018 Barros Peña. All rights reserved.
//

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var defaultsData = UserDefaults.standard
    var recentPayment = Payment()
    var paymentArray = [Payment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        var temp = Payment(subtotal: 100.0, tip: 25.0, total: 125.0, location: "Pelon", date: Date(), timeZone: TimeZone.current.identifier)
//        var temp2 = Payment(subtotal: 100.0, tip: 50.0, total: 150.0, location: "", date: Date(), timeZone: TimeZone.current.identifier)
//        paymentArray.append(temp)
//        paymentArray.append(temp2)
        // paymentArray = (defaultsData.object(forKey: "paymentArray") ?? [Payment]()) as! [Payment]
        loadDefaultData()
        if paymentArray.count == 0 {
            editButton.isEnabled = false
        } else {
            editButton.isEnabled = true
        }
    }
    
    func loadDefaultData() {
        // Load encoded versions of payment objects from DefaultData
        let decoded = UserDefaults.standard.object(forKey: "paymentArray") as? Data
        if decoded != nil {
            print("(debug): Decoded state: \(decoded!)")
            let paymentArrayLoaded = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Payment]
            self.paymentArray = paymentArrayLoaded
            if self.paymentArray.count > 0 {
                print("paymentArray = \(paymentArray[0])")
            }
        }
    }
    
    func saveDefaultData() {
        let encoded = NSKeyedArchiver.archivedData(withRootObject: paymentArray)
        UserDefaults.standard.set(encoded, forKey: "paymentArray")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPayment" {
            let destination = segue.destination as! PaymentDetailVC
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.payment = paymentArray[selectedIndexPath.row]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: true)
            }
        }
    }
    
    
    @IBAction func unwindFromPaymentDetail(segue: UIStoryboardSegue) {
        print("inside unwind func")
        print("segue.identifier: " + segue.identifier!)
        print("indexPathForSelectedRow: \(tableView.indexPathForSelectedRow)")
        let source = segue.source as! PaymentDetailVC
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            paymentArray[selectedIndexPath.row] = source.payment!
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            print("test")
        } else {
            let newIndexPath = IndexPath(row: paymentArray.count, section: 0)
            paymentArray.append(source.payment!)
            print(paymentArray[0].total)
            print("test2")
//            print("subtotal: \(source.payment?.subtotal)")
//            print("tip %: \(source.payment?.tip)")
//            print("total: \(source.payment?.total)")
//            print("location: \(source.payment?.location)")
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveDefaultData()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            addButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editButton.title = "Done"
            addButton.isEnabled = false
        }
    }
    func formatTimeForTimeZone(date: Date, timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM. dd, y, h:mmaaa"
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    

}
extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paymentArray.count == 0 {
            editButton.isEnabled = false
        } else {
            editButton.isEnabled = true
        }
        return paymentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let payment = paymentArray[indexPath.row]
        let total = payment.total
        let location = payment.location
        if location != "" {
            cell.textLabel?.text = String(format: "$%.02f - \(location)", (total))
        } else {
            cell.textLabel?.text = String(format: "$%.02f", (total))
        }
        print("subtotal: \(payment.subtotal)")
        print("tip %: \(payment.tip)")
        print("total: \(payment.total)")
        print("location: \(payment.location)")
        cell.detailTextLabel?.text = formatTimeForTimeZone(date: payment.date, timeZone: payment.timeZone)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        paymentArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let paymentToMove = paymentArray[sourceIndexPath.row]
        paymentArray.remove(at: sourceIndexPath.row)
        paymentArray.insert(paymentToMove, at: destinationIndexPath.row)
    }
}
