//
//  Array Extension.swift
//  drinkOrder
//
//  Created by Jube on 2023/1/22.
//

import Foundation

extension Array where Element: Hashable {
    func removeDuplicateElement() -> [Element] {
            var elementSet = Set<Element>()

            return filter {
                elementSet.update(with: $0) == nil
            }
        }
}
