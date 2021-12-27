//
//  RootViewController.swift
//  DataContentApp
//
//  Created by Sergey Balashov on 27.12.2021.
//

import UIKit

class RootViewController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.prefersLargeTitles = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITableView {
    func register<T>(cell: T.Type) where T: UITableViewCell {
        register(cell, forCellReuseIdentifier: "\(cell)")
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
}
