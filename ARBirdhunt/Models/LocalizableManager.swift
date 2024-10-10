//
//  LocalizableManager.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/03.
//

import SwiftUI

enum LanguageTypes: String, CaseIterable, RawRepresentable {
    case japanese = "ja"
    case english = "en"
    case chinese = "zh-Hans"
    case korean = "ko"

    var name: String {
        switch self {
        case .japanese: return "日本語"
        case .english: return "English"
        case .chinese: return "中文"
        case .korean: return "한글"
        }
    }
    var image: String {
        switch self {
        case .japanese: return "JPFlag"
        case .english: return "USFlag"
        case .chinese: return "CNFlag"
        case .korean: return "KRFlag"
        }
    }
}

class LocalizableManager: ObservableObject {
    
    static let shared = LocalizableManager()
    
    @AppStorage("currentLanguage")
    private var storedLanguage: LanguageTypes = .japanese
    
    @Published var currentLanguage: LanguageTypes = .japanese {
        didSet {
            storedLanguage = currentLanguage
            Bundle.setLanguage(language: currentLanguage.rawValue)
        }
    }
    
    private init() {
        currentLanguage = storedLanguage
        Bundle.setLanguage(language: storedLanguage.rawValue)
    }
}

extension Bundle {
    private static var bundle: Bundle!
    
    static func setLanguage(language: String) {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        bundle = path != nil ? Bundle(path: path!) : Bundle.main
    }
    
    static func localizedBundle() -> Bundle {
        return bundle ?? Bundle.main
    }
}
extension String {
    func localized() -> String {
        return Bundle.localizedBundle().localizedString(forKey: self, value: nil, table: nil)
    }
}
