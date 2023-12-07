//
//  Settings.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 11.07.23.
//

import Foundation

final class Settings: ObservableObject {
    
    static let adsEnabled = true
    static let adTestMode = true // TODO: Set fo false prior to release
    
    struct AdMobInfo {
        static let appId = "ca-app-pub-7585285452167184~4537327024"
        static let nativeAdId = "ca-app-pub-7585285452167184/8343929841"
        static let interstitialAdId = "ca-app-pub-7585285452167184/5634840172"
        static let bannerAdId = "ca-app-pub-7585285452167184/1308528450"
        
        static let nativeAdTestId = ""
        static let interstitialAdTestId = "ca-app-pub-3940256099942544/4411468910"
        static let bannerAdTestId = "ca-app-pub-3940256099942544/2934735716"
    }
  
    
    @Published var pointer4x4: Int {
        willSet {
            UserDefaults.standard.set(newValue, forKey: Keys.pointer4x4)
        }
    }
    @Published var pointer5x5: Int {
        willSet {
            UserDefaults.standard.set(newValue, forKey: Keys.pointer5x5)
        }
    }
    @Published var pointer6x6: Int {
        willSet {
            UserDefaults.standard.set(newValue, forKey: Keys.pointer6x6)
        }
    }
    @Published var pointer7x7: Int {
        willSet {
            UserDefaults.standard.set(newValue, forKey: Keys.pointer7x7)
        }
    }
    @Published var pointer8x8: Int {
        willSet {
            UserDefaults.standard.set(newValue, forKey: Keys.pointer8x8)
        }
    }
    @Published var pointer9x9: Int {
        willSet {
            UserDefaults.standard.set(newValue, forKey: Keys.pointer9x9)
        }
    }
    
    init() {
        self.pointer4x4 = UserDefaults.standard.integer(forKey: Keys.pointer4x4)
        self.pointer5x5 = UserDefaults.standard.integer(forKey: Keys.pointer5x5)
        self.pointer6x6 = UserDefaults.standard.integer(forKey: Keys.pointer6x6)
        self.pointer7x7 = UserDefaults.standard.integer(forKey: Keys.pointer7x7)
        self.pointer8x8 = UserDefaults.standard.integer(forKey: Keys.pointer8x8)
        self.pointer9x9 = UserDefaults.standard.integer(forKey: Keys.pointer9x9)
    }

}

extension Settings {
    private struct Keys {
        static let pointer4x4 = "syncPointer4"
        static let pointer5x5 = "syncPointer5"
        static let pointer6x6 = "syncPointer6"
        static let pointer7x7 = "syncPointer7"
        static let pointer8x8 = "syncPointer8"
        static let pointer9x9 = "syncPointer9"
    }
}
