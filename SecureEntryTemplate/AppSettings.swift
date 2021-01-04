//
//  AppSettings.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import Foundation

enum AppSettingsKeys: String {
    case isPinSetup
}

protocol IAppSettingsService: class {
    var isPinSetup: Bool { get set }
}

final class AppSettings: IAppSettingsService {
    private let defaults = UserDefaults.standard
    
    var isPinSetup: Bool {
        get {
            return defaults.bool(forKey: AppSettingsKeys.isPinSetup.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: AppSettingsKeys.isPinSetup.rawValue)
        }
    }
}
