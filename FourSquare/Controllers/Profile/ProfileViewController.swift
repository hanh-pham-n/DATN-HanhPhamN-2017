//
//  ProfileViewController.swift
//  FourSquare
//
//  Created by Duy Linh on 4/3/17.
//  Copyright © 2017 Duy Linh. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController {
    
    // MARK: Define:
    private let avatarRadius: CGFloat = 50
    private let buttonRadius: CGFloat = 25
    
    // MARK: Properties
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sexLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loginView: UIView!
    private var user: User = User() {
        didSet {
            avatarImageView.sd_setImage(with: user.avatar?.userAvatarPath)
            nameLabel.text = user.name
            sexLabel.text = user.gender
            emailLabel.text = user.email
            phoneLabel.text = user.phone
            addressLabel.text = user.homeCity
        }
    }
    private var isLogin = false {
        didSet {
            if isLogin {
                if loginView != nil {
                    loadData()
                    loginView.isHidden = true
                    addRightBarButton()
                }
            } else {
                if loginView != nil {
                    loginView.isHidden = false
                    addRightBarButton()
                    navigationItem.rightBarButtonItem = nil
                }
            }
        }
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNotificationCenter()
    }
    
    override func setupUI() {
        super.setupUI()
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarRadius
        loginButton.clipsToBounds = true
        loginButton.roundCorners(corners: [.topLeft, .bottomLeft, .topRight, .bottomRight], radius: buttonRadius)
        navigationItem.title = "Profile"
        if let _ = Session.shared.token() {
            isLogin = true
        }
    }
    
    // MARK: Private
    private func configNotificationCenter() {
        let notificationName = Notification.Name(rawValue: NotificationCenterKey.Login)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: notificationName, object: nil)
    }
    
    @objc private func reloadData() {
        isLogin = true
    }
    
    private func loadData() {
        let userService = UserService()
        HUD.show()
        userService.loadUserProfile(completion: { (user) in
            HUD.dismiss()
            self.user = user
        }) { (error) in
            HUD.dismiss()
            print(error?.localizedDescription ?? "")
        }
    }
    
    private func addRightBarButton() {
        let editButtonItem = UIBarButtonItem(image: UIImage(named: "ic_logout"), style: .done, target: self, action: #selector(logoutAction))
        navigationItem.setRightBarButton(editButtonItem, animated: true)
    }
    
    @objc private func logoutAction() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you would like to sign out of Foursquare?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Sign Out", style: .default) { (_) in
            Session.shared.logout()
            self.isLogin = false
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Action
    @IBAction private func loginAction(_ sender: Any) {
        let userService = UserService()
        userService.login()
    }
}
