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

protocol Identifible {
    static var identifier: String { get }
}

extension UITableViewCell: Identifible {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: cell.identifier)
    }

    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: Identifible {
        dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}
