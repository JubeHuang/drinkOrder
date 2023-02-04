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
    var orderPost: OrderPost?
    var lists = [List]()
    var currentCellPath: IndexPath?
    weak var currentCellSelected: OrderTableViewCell?
    var selectPickerNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let name = Notification.Name("orderUpdateNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(updateToNoti(noti:)), name: name, object: nil)
        dateLabel.text = ""
        totalMoneyLabel.text = "$ 0"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let orderTime = orders.last?.orderTime else { return }
        let sum = sumMoney(orders: orders)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        totalMoneyLabel.text = "$ \(sum)"
        dateLabel.text = formatter.string(from: orderTime)
    }
    
    @IBAction func showPicker(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: orderTableView)
        if let indexPath = orderTableView.indexPathForRow(at: point) {
            bringUpPickerViewWithRow(indexPath: indexPath)
            currentCellPath = indexPath
        }
    }
    
    @IBAction func savePicker(_ sender: Any) {
        guard let selectPickerNum = self.selectPickerNum,
              let row = currentCellPath?.row else { return }
        let newTotalPrice = orders[row].totalPrice / orders[row].quantity * selectPickerNum
        let editOrder = DrinkDetail(name: orders[row].name, ice: orders[row].ice, sugar: orders[row].sugar, quantity: selectPickerNum, totalPrice: newTotalPrice, orderTime: orders[row].orderTime, additional: orders[row].additional)
        let newAddPrice = selectPickerNum * 10
        orders[row] = editOrder
        currentCellSelected?.orderNumLabel.text = "\(selectPickerNum)杯"
        currentCellSelected?.orderPriceLabel.text = "\(newTotalPrice)"
        currentCellSelected?.addPriceLabel.text = "+ $\(newAddPrice)"
        let sum = sumMoney(orders: orders)
        totalMoneyLabel.text = "$ \(sum)"
        let name = Notification.Name("ordersUpdateNotification")
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["orders": orders])
        view.endEditing(true)
    }
    @IBAction func cancelPicker(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func submitOrder(_ sender: Any) {
        for order in orders {
            var lists = [List]()
            let list = List(fields: order)
            lists.append(list)
            orderPost = OrderPost(records: lists)
        }
        guard let order = orderPost else { return }
        MenuController.shared.uploadOrder(list: order) { result in
            switch result{
            case .success(let lists):
                DispatchQueue.main.async {
                    print(lists)
                    self.lists = lists
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
        dismiss(animated: true)
    }
    
    func bringUpPickerViewWithRow(indexPath: IndexPath) {
        currentCellSelected = orderTableView.cellForRow(at: indexPath) as? OrderTableViewCell
        currentCellSelected?.editNumTextfield.becomeFirstResponder()
    }
    
    @objc func updateToNoti(noti:Notification){
        if let userInfo = noti.userInfo,
            let order =  userInfo["order"] as? DrinkDetail {
            orders.append(order)
        }
    }
    
    func sumMoney(orders: [DrinkDetail]) -> Int{
        var sum = 0
        var addPearlCount = 0
        let addPearlPrice = 10
        for i in 0..<orders.count {
            sum += orders[i].totalPrice
            if orders[i].additional == Add.AddPearl.rawValue {
                addPearlCount += orders[i].quantity
            }
        }
        return sum + addPearlCount * addPearlPrice
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
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as! OrderTableViewCell
        let row = indexPath.row
        cell.editNumTextfield.inputView = numberPicker
        cell.editNumTextfield.inputAccessoryView = numberToolBar
        cell.orderNameLabel.text = orders[row].name
        cell.orderPriceLabel.text = "$\(orders[row].totalPrice)"
        cell.addLabel.text = "\(orders[row].ice)、\(orders[row].sugar) \(orders[row].additional)"
        cell.orderNumLabel.text = "\(orders[row].quantity)杯"
        if orders[row].additional == Add.AddPearl.rawValue {
            cell.addPriceLabel.text = "+ $\(orders[row].quantity * 10)"
        }else {
            cell.addPriceLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCellPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        <#code#>
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectPickerNum = orderNumbers[row]
    }
}
