//
//  Sugar Ice Enum.swift
//  drinkOrder
//
//  Created by Jube on 2023/1/25.
//

import Foundation

enum Sugar:String, CaseIterable {
    case NoSugar = "無糖"
    case OneSugar = "一分糖"
    case ThreeSugar = "三分糖"
    case FiveSugar = "五分糖"
    case NormalSugar = "正常糖"
}

enum Ice:String, CaseIterable {
    case NoIce = "去冰"
    case LittleIce = "微冰"
    case Hot = "熱"
}

enum Add: String, CaseIterable {
    case AddPearl = "+ 白玉"
    case None = ""
}
