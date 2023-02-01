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
                case titles[3]:
                    fourthTabDrinks.append(drink)
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
    }
    
    @IBAction func tabSedgmentBtn(_ sender: UIButton) {
        if let num = segmentTabs.firstIndex(of: sender){
            print(num)
            tabNumber = num
            customSegmentedControl.tabBtnUI(index: num, btns: segmentTabs, deviceWidth: view.bounds.width)
            menuCollectionView.reloadData()
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
            print(secondTabDrinks.count, "collection")
            return secondTabDrinks.count
        case 2:
            return thirdTabDrinks.count
        case 3:
            return fourthTabDrinks.count
        default:
            return 0
        }
        //return drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "\(FirstTabCollectionViewCell.self)", for: indexPath) as! FirstTabCollectionViewCell
        let drink = drinks[indexPath.row].fields
        MenuController.shared.getImage(url: drink.image[0].url) { image in
            DispatchQueue.main.async {
                cell.drinkImage.image = image
            }
        }
        return cell
    }
    
    
}
