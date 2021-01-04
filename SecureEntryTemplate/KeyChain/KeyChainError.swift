//
//  KeyChainError.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unexpectedItemData
    case unhandledError(status: OSStatus)
}

extension KeychainError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .noPassword:
            return "No Password"
        case .unexpectedItemData:
            return "Unexpected Item Data"
        case .unexpectedPasswordData:
            return "Unexpected Password Data"
        case .unhandledError(let error):
            return "Unhandled Error: \(error)"
        }
    }
}
