//
//  viewController extension.swift
//  drinkOrder
//
//  Created by Jube on 2023/2/13.
//

import Foundation
import UIKit

extension UIViewController {
    func presentLoading() {
        let controller = LoadingViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    func dismissLoading(){
        dismiss(animated: true)
    }
}
