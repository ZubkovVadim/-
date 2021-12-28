//
//  LoginViewController.swift
//  DataContentApp
//
//  Created by Sergey Balashov on 27.12.2021.
//

import UIKit

class LoginViewController: UIViewController {
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 8
        view.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [textField, loginButton])
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewState: ViewState = .login {
        didSet {
            viewStateDidUpdate()
        }
    }
    
    private let keychainManager = KeychainManager()
    private var passwordForUpdate: String?
    
    init(initialState: ViewState? = nil) {
        if let initialState = initialState {
            viewState = initialState
        } else if keychainManager.isExistPassword() {
            viewState = .login
        } else {
            viewState = .register
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewStateDidUpdate()
    }
    
    private func viewStateDidUpdate() {
        loginButton.setTitle(viewState.title, for: .normal)
    }
    
    @IBAction private func tapButton() {
        switch viewState {
        case .register:
            let text = textField.text ?? ""
            
            if text.count >= 4 {
                passwordForUpdate = text
                viewState = .confirm
                textField.text = nil
                
            } else {
                showError(title: "Пароль должен состоять минимум из четырёх символов") { [weak self] in
                    self?.textField.text = nil
                }
            }

        case .confirm:
            let text = textField.text ?? ""
            
            if passwordForUpdate == text {
                keychainManager.savePassword(string: text)
                dismiss(animated: true)
            } else {
                showError(title: "Пароль не совпадает, повторите еще раз") { [weak self] in
                    self?.textField.text = nil
                    self?.passwordForUpdate = nil
                    self?.viewState = .register
                }
            }
            
        case .login:
            let text = textField.text ?? ""
            
            if keychainManager.checkPassword(string: text) {
                dismiss(animated: true)
            } else {
                let saved = keychainManager.savedPassword() ?? ""
                showError(title: "Пароль не верный, повторите еще раз. Верный \(saved)") { [weak self] in
                    self?.textField.text = nil
                }
            }
        }
    }
    
    private func showError(title: String, tapOK: @escaping () ->() = {}) {
        let alert = UIAlertController(title: "Ошибка", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
            tapOK()
        }))
        
        present(alert, animated: true)
    }
}

extension LoginViewController {
    enum ViewState {
        case login, register, confirm
        
        var title: String {
            switch self {
            case .login:
                return "Введите пароль"
            case .register:
                return "Создать пароль"
            case .confirm:
                return "Повторите пароль"
            }
        }
    }
}

