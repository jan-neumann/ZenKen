//
//  ZKPuzzleSelectionMenuViewModel.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 08.12.23.
//

import SwiftUI
import ZKGenerator

final class ZKPuzzleSelectionMenuViewModel: ObservableObject {
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 120))
    ]
    
    let interstitialAd = InterstitialAdView()
    let interstitialAdCoordinator = InterstitialAdCoordinator()

    
    var size: Int = 4
    
    @Published var currentPuzzle: ZKPuzzleData?
    @Published var puzzles: [ZKPuzzleData] = []
    @Published var currentPuzzleSolved: Bool = false
    @Published var currentPuzzleNumber: Int = 0
    
    @AppStorage("4x4Solved") private var solved4x4: Int = 1
    @AppStorage("5x5Solved") private var solved5x5: Int = 1
    @AppStorage("6x6Solved") private var solved6x6: Int = 1
    @AppStorage("7x7Solved") private var solved7x7: Int = 1
    @AppStorage("8x8Solved") private var solved8x8: Int = 1
    @AppStorage("9x9Solved") private var solved9x9: Int = 1
    
    func initialize(size: Int, puzzles: [ZKPuzzleData]) {
        self.size = size
        self.puzzles = puzzles
        self.currentPuzzleSolved = false
    }
    
    var headlineText: String {
        "\(size) x \(size) Puzzles"
    }
    
    var solvedText: String {
        "solved : \(solved - 1) / \(puzzles.count)"
    }
    
    var solved: Int {
        switch size {
    
        case 4:
            return solved4x4
        case 5:
            return solved5x5
        case 6:
            return solved6x6
        case 7:
            return solved7x7
        case 8:
            return solved8x8
        case 9:
            return solved9x9
            
        default:
            return 0
        }
    }
    
    func presentInterstital() {
        if currentPuzzleSolved,
           Settings.adsEnabled {
            // TODO: Find another solution
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                self.interstitialAdCoordinator.presentAd(
                    from: interstitialAd.viewController
                )
            }
        }
    }
    
    func puzzleSolved() {

        switch size {
        case 4:
            if solved4x4 <= currentPuzzleNumber {
                solved4x4 = currentPuzzleNumber + 1
            }
        case 5:
            if solved5x5 <= currentPuzzleNumber {
                solved5x5 = currentPuzzleNumber + 1
            }
        case 6:
            if solved6x6 <= currentPuzzleNumber {
                solved6x6 = currentPuzzleNumber + 1
            }
        case 7:
            if solved7x7 <= currentPuzzleNumber {
                solved7x7 = currentPuzzleNumber + 1
            }
        case 8:
            if solved8x8 <= currentPuzzleNumber {
                solved8x8 = currentPuzzleNumber + 1
            }
        case 9:
            if solved9x9 <= currentPuzzleNumber {
                solved9x9 = currentPuzzleNumber + 1
            }
        default:
            return
        }
    }
}
