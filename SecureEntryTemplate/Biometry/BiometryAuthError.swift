//
//  BiometryAuthError.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import Foundation

enum BiometryAuthError: Error {
    case invalidPin
    case pinNotSet
    case touchIDNotAvailable
    case faceIDNotAvailable
    case authenticationFailed
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockout
    case unknownedError(String)
}

extension BiometryAuthError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidPin:
            return "Неверный пин-код"
        case .pinNotSet:
            return "Пин-код не установлен"
        case .unknownedError(let error):
            return "\(error)"
        case .touchIDNotAvailable:
            return "TouchID not available"
        case .faceIDNotAvailable:
            return "FaceID not available"
        case .authenticationFailed:
            return "There was a problem verifying your identity"
        case .userCancel:
            return "You pressed cancel"
        case .userFallback:
            return "You pressed password"
        case .biometryNotAvailable:
            return "Face ID/Touch ID is not available"
        case .biometryNotEnrolled:
            return "Face ID/Touch ID is locked"
        case .biometryLockout:
            return "There was a problem verifying your identity"
        }
    }
}
