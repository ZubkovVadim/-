//
//  SettingsViewController.swift
//  DataContentApp
//
//  Created by Sergey Balashov on 28.12.2021.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    private lazy var sortButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.setTitle(userDefaultsManager.getSortState().title, for: .normal)
        view.addTarget(self, action: #selector(tapSortButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.setTitle("Сбросить пароль", for: .normal)
        view.addTarget(self, action: #selector(tapResetPassword), for: .touchUpInside)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sortButton, resetPasswordButton])
        view.axis = .vertical
        view.spacing = 32
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userDefaultsManager = UserDefaultsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
    }
    
    @IBAction private func tapResetPassword() {
        (tabBarController as? TabBarViewController)?.presentLoginController(initialState: .register)
    }
    
    @IBAction private func tapSortButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        SortType.allCases.forEach { type in
            let action = UIAlertAction(title: type.title, style: .default, handler: { [weak self] _ in
                self?.userDefaultsManager.saveSortState(type: type)
                self?.updateTitleSort()
            })
            
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in }))
        present(alert, animated: true)
    }
    
    private func updateTitleSort() {
        sortButton.setTitle(userDefaultsManager.getSortState().title, for: .normal)
    }
}

struct UserDefaultsManager {
    let userDefaults = UserDefaults.standard
    let sortKey = "sort_key"
    
    func saveSortState(type: SortType) {
        userDefaults.set(type.rawValue, forKey: sortKey)
    }
    
    func getSortState() -> SortType {
        let sortType = userDefaults.string(forKey: sortKey) ?? ""
        
        return SortType(rawValue: sortType) ?? .az
    }
}

enum SortType: String, CaseIterable {
    case az, za
    
    var title: String {
        switch self {
        case .az:
            return "От A до Z"
        case .za:
            return "От Z до A"
        }
    }
}
