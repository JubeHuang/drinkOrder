//
//  OrderViewController.swift
//  drinkOrder
//
//  Created by Jube on 2023/2/3.
//

import UIKit

class OrderViewController: UIViewController {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet var numberToolBar: UIToolbar!
    @IBOutlet var numberPicker: UIPickerView!
    @IBOutlet weak var orderTableView: UITableView!
    let orderNumbers = Array(1...10)
    var orders = [DrinkDetail]()
    let testOrder = DrinkDetail(name: "八要和茶", ice: "noIce", sugar: "nosugar", quantity: 1, totalPrice: 30, orderTime: Date.now)
    var tableViewCell: OrderTableViewCell?
    var textfield: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalMoneyLabel.text = "\(testOrder.totalPrice)"
        dateLabel.text = "\(testOrder.orderTime)"
    }
    
    @IBAction func showPicker(_ sender: UITapGestureRecognizer) {
        
        if let point = sender.view?.convert(CGPoint.zero, to: orderTableView),
            let indexPath = orderTableView.indexPathForRow(at: point) {
            let cell = orderTableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as! OrderTableViewCell
            cell.editNumTextfield.becomeFirstResponder()
            print("called")
        }
    }
    
    @IBAction func savePicker(_ sender: Any) {
    }
    @IBAction func cancelPicker(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as! OrderTableViewCell
        cell.editNumTextfield.inputView = numberPicker
        cell.editNumTextfield.inputAccessoryView = numberToolBar
        cell.orderNameLabel.text = testOrder.name
        cell.orderPriceLabel.text = "\(testOrder.totalPrice)"
        cell.addLabel.text = "\(testOrder.ice)、\(testOrder.sugar)"
        //cell.editNumTextfield.becomeFirstResponder()
        return cell
    }
    
    
}

extension OrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        orderNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(orderNumbers[row])"
    }
}

extension OrderViewController: OrderTableViewCellDelegate {
    func orderTableViewCellDelegate(_ controller: OrderTableViewCell, didSelect orderNum: Int, editNumTextfield: UITextField) {
        textfield = editNumTextfield
    }
}
