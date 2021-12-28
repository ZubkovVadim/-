//
//  KeychainManager.swift
//  DataContentApp
//
//  Created by Sergey Balashov on 28.12.2021.
//

import KeychainAccess

struct KeychainManager {
    let keychain = Keychain(service: "com.ba1ashov.DataContentApp")
    let passwordKey = "password"
    
    init() {}
    
    func isExistPassword() -> Bool {
        keychain[passwordKey] != nil
    }
    
    func savePassword(string: String) {
        keychain[passwordKey] = string
    }
    
    func checkPassword(string: String) -> Bool {
        keychain[passwordKey] == string
    }
    
    func savedPassword() -> String? {
        keychain[passwordKey]
    }
}
