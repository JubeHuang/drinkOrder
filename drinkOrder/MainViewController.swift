//
//  MainViewController.swift
//  drinkOrder
//
//  Created by Jube on 2023/1/14.
//

import UIKit

class MainViewController: UIViewController {

    let customSegmentedControl = CustomSegmentedControl()
    var drinks = [Item]()
    var titles = [String](){
        didSet {
            for (_, drink) in drinks.enumerated(){
                switch drink.fields.genre {
                case titles[0]:
                    firstTabDrinks.append(drink)
                case titles[1]:
                    secondTabDrinks.append(drink)
                case titles[2]:
                    thirdTabDrinks.append(drink)
                default:
                    break
                }
            }
        }
    }
    var firstTabDrinks = [Item]()
    var secondTabDrinks = [Item]()
    var thirdTabDrinks = [Item]()
    var fourthTabDrinks = [Item]()
    var tabNumber = 0
    var orderByTabs = [[Item]]()
    var orders = [DrinkDetail]()

    @IBOutlet weak var totalOrderNumLabel: UILabel!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet var segmentTabs: [UIButton]!
    @IBOutlet weak var tabBtnStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuController.shared.fetchMenu { result in
            switch result {
            case .success(let drinks):
                self.updateTabUI(drinks: drinks)
            case .failure(let error):
                print(error)
            }
        }
        updateUI()
        let name = Notification.Name("orderUpdateNotification")
        let nameOrders = Notification.Name("ordersUpdateNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(updateToNoti(noti:)), name: name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateToOrdersNoti(noti:)), name: nameOrders, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var orderNumber = 0
        for order in orders {
            orderNumber += order.quantity
        }
        totalOrderNumLabel.text = "\(orderNumber)"
    }
    
    @IBAction func tabSedgmentBtn(_ sender: UIButton) {
        if let num = segmentTabs.firstIndex(of: sender){
            tabNumber = num
            customSegmentedControl.tabBtnUI(index: num, btns: segmentTabs, deviceWidth: view.bounds.width)
            menuCollectionView.reloadData()
        }
    }
    
    @IBSegueAction func showDetail(_ coder: NSCoder) -> DetailTableViewController? {
        let controller = DetailTableViewController(coder: coder)
        if let indexPath = menuCollectionView.indexPathsForSelectedItems?.first{
            controller?.drink = orderByTabs[tabNumber][indexPath.row].fields
        }
        return controller
    }
    
    @IBSegueAction func showOrderList(_ coder: NSCoder) -> OrderViewController? {
        let controller = OrderViewController(coder: coder)
        controller?.orders = orders
        return controller
    }
    
    @objc func updateToNoti(noti:Notification){
        if let userInfo = noti.userInfo,
           let order =  userInfo["order"] as? DrinkDetail {
            orders.append(order)
        }
    }
    
    @objc func updateToOrdersNoti(noti:Notification){
        if let userInfo = noti.userInfo,
           let newOrders =  userInfo["orders"] as? [DrinkDetail] {
            orders = newOrders
        }
    }
    
    func updateUI(){
        title = "八曜和茶"
        customSegmentedControl.drawSelectorView(btns: segmentTabs, deviceWidth: view.bounds.width, y: Int(tabBtnStackView.frame.height), view: tabBtnStackView)
    }
    
    func updateTabUI(drinks: [Item]) {
        DispatchQueue.main.async {
            self.drinks = drinks
            self.titles = Item.genres(drinks)
            self.customSegmentedControl.setTabTitles(titles: self.titles, btns: self.segmentTabs)
            self.menuCollectionView.reloadData()
            self.orderByTabs = [self.firstTabDrinks, self.secondTabDrinks, self.thirdTabDrinks, self.fourthTabDrinks]
        }
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tabNumber {
        case 0 :
            return firstTabDrinks.count
        case 1 :
            return secondTabDrinks.count
        case 2:
            return thirdTabDrinks.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "\(FirstTabCollectionViewCell.self)", for: indexPath) as! FirstTabCollectionViewCell
        
        switch tabNumber {
        case 0:
            let drink = firstTabDrinks[indexPath.row].fields
            MenuController.shared.getImage(url: drink.image[0].url) { image in
                DispatchQueue.main.async {
                    cell.drinkImage.image = image
                }
            }
        case 1:
            let drink = secondTabDrinks[indexPath.row].fields
            MenuController.shared.getImage(url: drink.image[0].url) { image in
                DispatchQueue.main.async {
                    cell.drinkImage.image = image
                }
            }
        case 2:
            let drink = thirdTabDrinks[indexPath.row].fields
            MenuController.shared.getImage(url: drink.image[0].url) { image in
                DispatchQueue.main.async {
                    cell.drinkImage.image = image
                }
            }
        default:
            break
        }
        return cell
    }
}
