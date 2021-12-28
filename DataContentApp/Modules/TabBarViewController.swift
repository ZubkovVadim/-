//
//  TabBarViewController.swift
//  DataContentApp
//
//  Created by Sergey Balashov on 28.12.2021.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    private var isReqiredLogin = true
    
    init() {
        super.init(nibName: nil, bundle: nil)
                
        let controllers = [documentsController(), settingsController()]
        view.backgroundColor = .red
        setViewControllers(controllers, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isReqiredLogin {
            presentLoginController(initialState: nil)
        }
    }
    
    func presentLoginController(initialState: LoginViewController.ViewState?) {
        let login = LoginViewController(initialState: initialState)
        login.modalPresentationStyle = .overFullScreen
        present(login, animated: initialState != nil)
    }
    
    func settingsController() -> UIViewController {
        let view = RootViewController(rootViewController: SettingsViewController())
        view.tabBarItem = .init(tabBarSystemItem: .favorites, tag: 0)
        return view
    }
    
    func documentsController() -> UIViewController {
        let view = RootViewController(rootViewController: DocumentsViewController())
        view.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 0)
        return view
    }
}
