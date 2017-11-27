//
//  MainIndicatorView.swift
//  Toranoco
//
//  Created by Duy Linh on 5/2/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit

class MainIndicatorView: UIView {
    
    // MARK: Public properties
    
    private static let shared: MainIndicatorView = MainIndicatorView.loadNib()
    
    // MARK: Private properties
    
    @IBOutlet private weak var activityIndocatorView: UIActivityIndicatorView!
    
    // MARK: Instance functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Public class functions
    
    class func show() {
        guard let window = UIApplication.shared.keyWindow  else { return }
        let indicator = MainIndicatorView.shared
        var existed = false
        for subView in window.subviews {
            if subView is MainIndicatorView {
                existed = true
                break
            }
        }

        indicator.alpha = 0
        if !existed {
            window.addSubview(indicator)
            indicator.frame = window.bounds
        }
        window.bringSubview(toFront: indicator)
        indicator.activityIndocatorView.startAnimating()
        UIView.animate(withDuration: 0.25) { 
            indicator.alpha = 1
        }
    }
    
    class func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { 
            MainIndicatorView.shared.alpha = 0
        }) { _ in
            MainIndicatorView.shared.activityIndocatorView.stopAnimating()
            MainIndicatorView.shared.removeFromSuperview()
        }
    }
}
