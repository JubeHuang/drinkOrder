//
//  OrderViewController.swift
//  drinkOrder
//
//  Created by Jube on 2023/2/3.
//

import UIKit

protocol OrderViewControllerDelegate: AnyObject {
    func orderViewControllerDelegate(_ controller: OrderViewController, didSelect orders: [DrinkDetail])
}

class OrderViewController: UIViewController {
    
    @IBOutlet weak var sendOrderBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet var numberToolBar: UIToolbar!
    @IBOutlet var numberPicker: UIPickerView!
    @IBOutlet weak var orderTableView: UITableView!
    let orderNumbers = Array(1...10)
    var orders = [DrinkDetail]()
    var orderPost: OrderPost?
    var lists = [ListResponse]()
    var currentCellPath: IndexPath?
    weak var currentCellSelected: OrderTableViewCell?
    var selectPickerNum: Int?
    weak var delegate: OrderViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let name = Notification.Name("orderUpdateNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(updateToNoti(noti:)), name: name, object: nil)
        dateLabel.text = ""
        totalMoneyLabel.text = "$ 0"
        registerForKeyboardNotifications()
        bottomView.layer.shadowColor = CGColor(red: 4/255, green: 8/255, blue: 8/255, alpha: 1)
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 10
        bottomView.layer.shadowOffset = .zero
        sendOrderBtn.isEnabled = false
        guard let orderTime = orders.last?.orderTime else { return }
        //有訂單
        let sum = sumMoney(orders: orders)
        nameTextfield.text = orders[0].orderer
        totalMoneyLabel.text = "$ \(sum)"
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        if let date = formatter.date(from: orderTime) {
            dateLabel.text = date.formatted()
        }
        //有人名
        if orders[0].orderer != "" {
            sendOrderBtn.isEnabled = true
        } else {
        //沒有人名
            sendOrderBtn.isEnabled = false
        }
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
        let editOrder = DrinkDetail(name: orders[row].name, ice: orders[row].ice, sugar: orders[row].sugar, quantity: selectPickerNum, totalPrice: newTotalPrice, orderTime: orders[row].orderTime, additional: orders[row].additional, orderer: nameTextfield.text!)
        let newAddPrice = selectPickerNum * 10
        orders[row] = editOrder
        currentCellSelected?.orderNumLabel.text = "\(selectPickerNum)杯"
        currentCellSelected?.orderPriceLabel.text = "$\(newTotalPrice)"
        currentCellSelected?.addPriceLabel.text = "+ $\(newAddPrice)"
        let sum = sumMoney(orders: orders)
        totalMoneyLabel.text = "$ \(sum)"
        delegate?.orderViewControllerDelegate(self, didSelect: orders)
        view.endEditing(true)
    }
    @IBAction func cancelPicker(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func submitOrder(_ sender: Any) {
        presentLoading()
        var lists = [List]()
        if nameTextfield.text == "" {
            showAlert(title: "Oops還不能送出噢！", message: "請填寫訂購人名稱")
        } else {
            for order in orders {
                let list = List(fields: order)
                lists.append(list)
            }
            orderPost = OrderPost(records: lists)
            guard let order = orderPost else { return }
            MenuController.shared.uploadOrder(list: order) {[weak self] result in
                guard let self = self else { return }
                switch result{
                case .success(let lists):
                    DispatchQueue.main.async {
                        print(lists)
                        self.lists = lists
                        self.orders.removeAll()
                        self.delegate?.orderViewControllerDelegate(self, didSelect: self.orders)
                        self.dismissLoading()
                        self.dismiss(animated: true)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func dissmissKeyboard(_ sender: Any) {
        let orderer = nameTextfield.text!
        let name = orders[0].name
        let ice = orders[0].ice
        let sugar = orders[0].sugar
        let quantity = orders[0].quantity
        let totalPrice = orders[0].totalPrice
        let additional = orders[0].additional
        let time = orders[0].orderTime
        orders[0] = DrinkDetail(name: name, ice: ice, sugar: sugar, quantity: quantity, totalPrice: totalPrice, orderTime: time, additional: additional, orderer: orderer)
        delegate?.orderViewControllerDelegate(self, didSelect: orders)
        sendOrderBtn.isEnabled = true
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
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        bottomView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func showAlert(title: String, message: String){
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertC.addAction(action)
        present(alertC, animated: true)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        orders.remove(at: indexPath.row)
        orderTableView.deleteRows(at: [indexPath], with: .automatic)
        totalMoneyLabel.text = "$ \(sumMoney(orders: orders))"
        if orders.count == 0 {
            sendOrderBtn.isEnabled = false
        }
        delegate?.orderViewControllerDelegate(self, didSelect: orders)
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
