//
//  BiometryAuthContext.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

protocol IBiometryAuthContext {
    func authenticateUser(completion: @escaping (Result<Void, BiometryAuthError>) -> Void)
}

final class BiometryAuthContext: LAContext, IBiometryAuthContext {
    
    // MARK: - Private

    private var loginReason: String {
        switch biometricType() {
        case .touchID:
            return "Login in with TouchID"
        case .faceID:
            return "Login in with FaceID"
        case .none:
            return "Login in with Pin"
        }
    }
    
    private func canEvaluatePolicy() -> Bool {
        return canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    private func biometricType() -> BiometricType {
        let _ = canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            fatalError()
        }
    }
    
    // MARK: - Public
    
//    func add(pin: String) {
//        let dataPass = Data(pin.utf8)
//        let success = setCredential(dataPass, type: .applicationPassword)
//        print("Result of set credentials to context: \(success)")
//    }
    
    func authenticateUser(completion: @escaping (Result<Void, BiometryAuthError>) -> Void) {
        guard canEvaluatePolicy() else {
            switch biometricType() {
            case .faceID:
                completion(.failure(.faceIDNotAvailable))
            case .touchID:
                completion(.failure(.touchIDNotAvailable))
            default:
                completion(.failure(.unknownedError("Biometry not available")))
            }
            return
        }
        
        evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: loginReason) { (success, evaluateError) in
                                if success {
                                    DispatchQueue.main.async {
                                        completion(.success(()))
                                    }
                                } else {
                                    switch evaluateError {
                                    case LAError.authenticationFailed?:
                                        completion(.failure(.authenticationFailed))
                                    case LAError.userCancel?:
                                        completion(.failure(.userCancel))
                                    case LAError.userFallback?:
                                        completion(.failure(.userFallback))
                                    case LAError.biometryNotAvailable?:
                                        completion(.failure(.biometryNotAvailable))
                                    case LAError.biometryNotEnrolled?:
                                        completion(.failure(.biometryNotEnrolled))
                                    case LAError.biometryLockout?:
                                        completion(.failure(.biometryLockout))
                                    default:
                                        completion(.failure(.unknownedError("Face ID/Touch ID may not be configured")))
                                    }
                                }
        }
    }
    
}
