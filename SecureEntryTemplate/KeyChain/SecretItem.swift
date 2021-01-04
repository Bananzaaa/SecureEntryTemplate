//
//  SecretItem.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import Foundation
import LocalAuthentication

struct SecretItem {

    // MARK: - Properties
    
    let service: String
    
    private(set) var account: String
    
    let accessGroup: String?

    // MARK: - Intialization
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    init() {
        self.service = "PinCode"
        self.account = "User"
        self.accessGroup = nil
    }
    
    // MARK: - Keychain access
    
    func retrieveSecret() throws -> String {
        var query = try SecretItem.keychainQuery(withService: service,
                                                 account: account,
                                                 accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecUseOperationPrompt as String] = "Access your pin code on the keychain" as AnyObject
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)
        print("status: \(status)")
        
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard status == noErr else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard
            let existingItem = queryResult as? [String : AnyObject],
            let secretData = existingItem[kSecValueData as String] as? Data,
            let secret = String(data: secretData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        print("secret: \(secret)")
        return secret
    }
    
    
    func addSecret(secret: String) throws {
        guard let secretData = secret.data(using: String.Encoding.utf8) else { return }
        var query = try SecretItem.keychainQuery(withService: service,
                                                 account: account,
                                                 accessGroup: accessGroup)
        
        do {
            try _ = retrieveSecret()

            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = secretData as AnyObject?

            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        catch KeychainError.noPassword {
            query[kSecValueData as String] = secretData as AnyObject?
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    func deleteItem() throws {
        let query = try SecretItem.keychainQuery(withService: service,
                                                 account: account,
                                                 accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
        print("Item successfully deleted")
    }
    
   
    // MARK: - Helpful
    
    private static func keychainQuery(withService service: String,
                                      account: String? = nil,
                                      accessGroup: String? = nil) throws -> [String : AnyObject] {
        
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        return query
    }
}
