//
//  ZenKenApp.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

@main
struct ZenKenApp: App {
    
    // MARK: - Main Scene
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .onAppear {
                    // TODO: Check if necessary
                    let path: [AnyObject] = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as [AnyObject]
                        let folder: String = path[0] as! String
                        NSLog("Your NSUserDefaults are stored in this folder: %@/Preferences", folder)
                }
        }
        
    }
}
