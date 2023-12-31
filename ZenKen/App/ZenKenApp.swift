//
//  ZenKenApp.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI
import GoogleMobileAds

@main
struct ZenKenApp: App {
    
    // MARK: - Main Scene
    
    var body: some Scene {
        WindowGroup {
            ZKMainMenuView()
                .onAppear {
                    // TODO: Check if necessary
                    let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
                        let folder: String = path[0] as! String
                        NSLog("Your NSUserDefaults are stored in this folder: %@/Preferences", folder)
                    
                    if Settings.adsEnabled {
                        // Init ads // TODO: Ask for consent prior initialization
                        GADMobileAds.sharedInstance().start { status in
                            if Settings.adTestMode {
                                GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [
                                    "c2ce836e78c80bcecb7fecc66779a08d",
                                    "04ad4ef3909fa8398c62a548b4ab6bc0"
                                ]
                            }
                        }
                    }
                }
        }
        
        
    }
}
