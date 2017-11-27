//
//  BaseViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 4/2/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import Foundation
import SwiftUtils

class BaseViewController: ViewController {
    
    // MARK: Define
    let barTinColor = UIColor.RGB(250, 250, 250, 0.8)
    let titeTextColor = UIColor.RGB(38, 38, 38)
    let font = UIFont.systemFont(ofSize: 16.0)
    let tinColor = UIColor.RGB(155, 155, 155)
    
    // MARK: Properties
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Public
    func setupUI() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = barTinColor
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : titeTextColor, NSFontAttributeName: font]
        navigationController.navigationBar.tintColor = tinColor
        setUpLeftBarButton()
    }
    
    // MARK: Private
    private func setUpLeftBarButton() {
        guard let navigationController = navigationController else { return }
        let count = navigationController.viewControllers.count
        if count > 1 {
            let backItem = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .done, target: self, action: #selector(clickBackButton))
            navigationItem.setLeftBarButton(backItem, animated: true)
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    // MARK: Actions
    @objc private func clickBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
        guard let navigationController = navigationController else { return }
        let count = navigationController.viewControllers.count
        if count == 1 {
            tabBarController?.tabBar.isHidden = false
        }
    }
}
