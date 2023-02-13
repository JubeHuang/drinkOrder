//
//  LoadingViewController.swift
//  drinkOrder
//
//  Created by Jube on 2023/2/13.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgLayer = UIView()
        bgLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        bgLayer.layer.backgroundColor = CGColor(gray: 0, alpha: 0.5)
        view.addSubview(bgLayer)
        loadXib()
        // Do any additional setup after loading the view.
    }
    
    func loadXib(){
        
        if let loadingView = Bundle(for: LottieAnimationView.self).loadNibNamed("loading", owner: nil, options: nil)?.first as? LottieAnimationView {
            let width = 140
            let centerX = (Int(view.bounds.width) - width)/2
            let centerY = (Int(view.bounds.height) - width)/2
            loadingView.frame = CGRect(x: centerX, y: centerY, width: width, height: width)
            view.addSubview(loadingView)
            loadingView.loopMode = .loop
            loadingView.animationSpeed = 1
            loadingView.play()
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
