//
//  PinViewModel.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import Foundation

protocol IViewModel {
    associatedtype Input
    associatedtype Output
    
    var input: Input {get}
    var output: Output {get}
}

protocol IPinViewModel {
    
}

final class PinViewModel: IViewModel {
    
    private let biometryAuthContext: IBiometryAuthContext
    private let appSettingsService: IAppSettingsService
    fileprivate var pinDigits: [Int] = [] {
        didSet {
            if pinDigits.count == 4 {
                enterPin(pinDigits.map {String($0)}.joined())
            }
        }
    }
    private var prePin: String?
    
    // MARK: - Input
    
    struct Input {
        
        weak var pinViewModel: PinViewModel?
        
        func enterDigit(_ digit: Int) {
            if let digits = pinViewModel?.pinDigits, digits.count < 4 {
                updateAppearence()
                pinViewModel?.pinDigits += [digit]
            }
        }
        
        func deleteLastDigit() {
            if let digits = pinViewModel?.pinDigits, digits.count > 0 {
                pinViewModel?.pinDigits.removeLast()
            }
        }
        
        func biometryAuthMethodChoosen() {
            pinViewModel?.loginUserUsingBiometry()
        }
        
        func updateAppearence() {
            pinViewModel?.updateAppearence()
        }
    }
        
    var input: Input
    
    // MARK: - Output
    
    struct Output {
        var errorDescription: ((String) -> Void)?
        var titleDescription: ((String) -> Void)?
        var avatarImageData: ((Data) -> Void)?
        var successAuth: (() -> Void)?
        var isPinSetup: ((Bool) -> Void)?
    }
    
    var output: Output
    
    // MARK: - Init
    
    init(biometryAuthContext: IBiometryAuthContext, appSettingsService: IAppSettingsService) {
        self.biometryAuthContext = biometryAuthContext
        self.appSettingsService = appSettingsService
        
        input = Input()
        output = Output()
        
        input.pinViewModel = self
    }
    
    // MARK: - Helpful
    
    fileprivate func updateAppearence() {
        if appSettingsService.isPinSetup {
            output.titleDescription?("Enter pin")
        } else {
            output.titleDescription?("Set pin")
        }
        output.errorDescription?("")
    }
    
    private func enterPin(_ pin: String) {
        print("PIN: \(pin)")
        if appSettingsService.isPinSetup {
            //---fetch hash value of pin from keyChain and compare it with entered pin hash---
            verificationPin(pin)
            
            //---clear cache---
            pinDigits.removeAll()
        } else {
            //---set prePin and let user repeat pin yet---
            guard let prePin = prePin else {
                self.prePin = pin
                pinDigits.removeAll()
                output.titleDescription?("Repeat pin")
                return
            }
            guard pin == prePin else {
                pinDigits.removeAll()
                output.titleDescription?("Invalid pin")
                return
            }
            
            //---clear cache---
            pinDigits.removeAll()
            self.prePin = nil
            
            //---hash pin and put it into keyChain---
            saveSecret(pin)
        }
    }
    
    private func saveSecret(_ value: String) {
        let secretItem = SecretItem()
        guard let hash = value.md5Hash() else { return }
        do {
            try secretItem.addSecret(secret: hash)
            appSettingsService.isPinSetup = true
            output.isPinSetup?(true)
        } catch {
            output.errorDescription?(error.localizedDescription)
        }
    }
    
    private func verificationPin(_ pin: String) {
        guard let hashValue = pin.md5Hash() else {return}
        let secretItem = SecretItem()
        do {
            let secret = try secretItem.retrieveSecret()
            if hashValue == secret {
                output.successAuth?()
            } else {
                output.errorDescription?("Invalid pin")
            }
        } catch {
            output.errorDescription?(error.localizedDescription)
        }
    }
    
    private func loginUserUsingBiometry() {
        biometryAuthContext.authenticateUser { [weak self] result in
            switch result {
            case .success:
                self?.output.successAuth?()
            case .failure(let error):
                self?.output.errorDescription?(error.localizedDescription)
            }
        }
    }
    
}
