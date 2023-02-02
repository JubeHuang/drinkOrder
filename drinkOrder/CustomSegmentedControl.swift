//
//  CustomSegmentedControl.swift
//  drinkOrder
//
//  Created by Jube on 2023/1/20.
//

import UIKit

class CustomSegmentedControl: UIView {
    
    var selectorColor = UIColor(red: 56/255, green: 109/255, blue: 105/255, alpha: 1)
    var defaultColor = UIColor(red: 234/255, green: 165/255, blue: 36/255, alpha: 1)
    var selectorView: UIView!
    
    func setTabTitles(titles: [String], btns: [UIButton]){
        for (buttonIndex, btn) in btns.enumerated() {
            btn.setTitle(titles[buttonIndex], for: .normal)
            btn.setTitleColor(defaultColor, for: .normal)
        }
        btns[0].setTitleColor(selectorColor, for: .normal)
    }
    
    func tabBtnUI(index: Int, btns: [UIButton], deviceWidth: CGFloat){
        for (_, btn) in btns.enumerated() {
            btn.setTitleColor(defaultColor, for: .normal)
        }
        btns[index].setTitleColor(selectorColor, for: .normal)
        let btnwidth = Int(deviceWidth) / btns.count
        let selectorWidth = 24
        let center = (btnwidth - selectorWidth) / 2
        let selectorPosition = CGFloat(btnwidth * index + center)
        print(selectorPosition)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    func drawSelectorView(btns: [UIButton], deviceWidth: CGFloat, y: Int, view: UIView){
        let btnwidth = Int(deviceWidth) / btns.count
        let width = 24
        let center = (btnwidth - width) / 2
        let selectorHeight = 4
        selectorView = UIView(frame: CGRect(x: center, y: y + selectorHeight, width: width, height: selectorHeight))
        selectorView.backgroundColor = selectorColor
        view.addSubview(selectorView)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
