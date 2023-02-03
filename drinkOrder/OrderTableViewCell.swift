//
//  OrderTableViewCell.swift
//  drinkOrder
//
//  Created by Jube on 2023/2/3.
//

import UIKit

protocol OrderTableViewCellDelegate: AnyObject {
    func orderTableViewCellDelegate(_ controller: OrderTableViewCell, didSelect orderNum: Int, editNumTextfield: UITextField)
}

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var editNumTextfield: UITextField!
    @IBOutlet weak var addPriceLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    weak var delegate: OrderTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = CGColor(red: 1, green: 235/255, blue: 197/255, alpha: 1)
        bgView.layer.cornerRadius = 24
        bgView.layer.shadowColor = CGColor(red: 57/255, green: 47/255, blue: 29/255, alpha: 1)
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowRadius = 3
        bgView.layer.shadowOpacity = 0.1
        if let orderNumStr = orderNumLabel.text?.removeLast().description {
            let orderNum = Int(orderNumStr) ?? 0
            delegate?.orderTableViewCellDelegate(self, didSelect: orderNum, editNumTextfield: editNumTextfield)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
