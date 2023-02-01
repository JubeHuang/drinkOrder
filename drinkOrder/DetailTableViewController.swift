//
//  DetailTableViewController.swift
//  drinkOrder
//
//  Created by Jube on 2023/1/22.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var drink: Drink?

    @IBOutlet weak var addToOrder: UIButton!
    @IBOutlet weak var minusNumBtn: UIButton!
    @IBOutlet weak var addNumBtn: UIButton!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet var iceBtn: [UIButton]!
    @IBOutlet var sugarBtn: [UIButton]!
    @IBOutlet weak var caffineImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    
    let formatter = NumberFormatter()
    var selectSugarIndex = 1
    var seletIceIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func selectSugar(_ sender: UIButton) {
        if let index = sugarBtn.firstIndex(of: sender){
            selectSugarIndex = index
            let selectImage = UIImage(named: "select\(Sugar.allCases[index].rawValue)")
            for i in 0..<sugarBtn.count{
                sugarBtn[i].setImage(UIImage(named: "unselect\(Sugar.allCases[i].rawValue)"), for: .normal)
            }
            sugarBtn[index].setImage(selectImage, for: .normal)
        }
    }
    
    @IBAction func selectIce(_ sender: UIButton) {
        if let index = iceBtn.firstIndex(of: sender){
            seletIceIndex = index
            let selectImage = UIImage(named: "select\(Ice.allCases[index].rawValue)")
            for i in 0..<iceBtn.count{
                iceBtn[i].setImage(UIImage(named: "unselect\(Ice.allCases[i].rawValue)"), for: .normal)
            }
            iceBtn[index].setImage(selectImage, for: .normal)
        }
    }
    
    func updateUI(){
        namelabel.text = drink?.name ?? ""
        descriptionLabel.text = drink?.description ?? ""
        formatter.numberStyle = .currency
        priceLabel.text = formatter.string(from: NSNumber(value: drink?.price ?? 0))
        if let imageName = drink?.caffeine {
            caffineImage.image = UIImage(named: imageName)
        }
    }

    // MARK: - Table view data source

    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
