//
//  ZKPuzzleSelectionMenuView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 11.07.23.
//

import SwiftUI
import ZKGenerator

struct ZKPuzzleSelectionMenuView: View {
    
    // MARK: - Public
    
    let puzzles: [ZKPuzzleData]
    let size: Int
    
    // MARK: - Private
    
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: 120))]

    @State private var currentPuzzle: ZKPuzzleData?
    @State private var currentPuzzleSolved: Bool
    @State private var currentPuzzleNumber: Int = 0
    
    @AppStorage("4x4Solved") private var solved4x4: Int = 1
    @AppStorage("5x5Solved") private var solved5x5: Int = 1
    @AppStorage("6x6Solved") private var solved6x6: Int = 1
    @AppStorage("7x7Solved") private var solved7x7: Int = 1
    @AppStorage("8x8Solved") private var solved8x8: Int = 1
    @AppStorage("9x9Solved") private var solved9x9: Int = 1
    
    
     private let interstitialAd = InterstitialAdView()
     private let interstitialAdCoordinator = InterstitialAdCoordinator()
     
    // MARK: - Properties
    
    private var solved: Int {
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
    
    // MARK: - Init
    
    init(size: Int, puzzles: [ZKPuzzleData]) {
        self.size = size
        self.puzzles = puzzles
        self.currentPuzzleSolved = false
    }
    
    // MARK: - Main View
    
    var body: some View {
        VStack {
            headerView
                .background {
                    if Settings.adsEnabled {
                        interstitialAd
                            .frame(width: .zero, height: .zero)
                    }
                }
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(puzzles) { puzzle in
                        puzzleButton(
                            for: puzzle,
                            locked: puzzle.number > solved
                        )
                    }
                }
                .padding()
            }
            Spacer()
        }
        .fullScreenCover(item: $currentPuzzle) { newPuzzle in
            ZKGameView(size: newPuzzle.size,
                       seed: newPuzzle.seed, 
                       solved: $currentPuzzleSolved
            )
          
        }
        .transition(.slide)
        .onChange(of: currentPuzzleSolved) { newValue in
            if newValue {
                puzzleSolved()
            }
        }
        .onChange(of: currentPuzzle) { newValue in
            if newValue == nil,
                Settings.adsEnabled {
                // TODO: Find another solution
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    interstitialAdCoordinator.presentAd(
                        from: interstitialAd.viewController
                    )
                }
            }
        }
    }
    
    // MARK: - Sub Views
    
    var headerView: some View {
        Rectangle()
            .foregroundStyle(.quinary)
            .overlay {
                VStack {
                    Text("\(size) x \(size) Puzzles")
                        .font(.title.bold())
                        .padding()
                    HStack {
                        Image(systemName: "square.grid.3x3")
                        Text("solved : \(solved - 1) / \(puzzles.count)")
                           
                    }
                    .foregroundStyle(.secondary)
                    .font(.title2)
                }
            }
            .frame(height: 180)
            .clipShape(.rect(cornerRadius: 10))
            .padding()
    }
    
    func puzzleButton(for puzzle: ZKPuzzleData, locked: Bool) -> some View {
        Button {
            if Settings.adsEnabled {
                interstitialAdCoordinator.loadAd()
            }
            currentPuzzle = puzzle
            currentPuzzleNumber = puzzle.number
    
        } label: {
            ZStack {
         
                VStack {
                    Text("\(puzzle.number)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                    Image(systemName: locked ? "lock" : "lock.open")
                        .font(.largeTitle)
                        .bold()
                    
                }
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "trophy")
                    }
                    Spacer()
                }
                .opacity(puzzle.number < solved ? 1 : 0)
            }
            .frame(width: 80, height: 90)
        }
        .frame(width: 100, height: 100)
        .buttonStyle(.bordered)
        .tint(locked ? .gray : .blue)
        .disabled(locked)
       
    }
}

// MARK: - Helper Functions

extension ZKPuzzleSelectionMenuView {
    
    private func puzzleSolved() {

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
// MARK: - Previews

#Preview {
    ZKPuzzleSelectionMenuView(size: 4, 
                              puzzles: ZKPuzzleData.previewData
    )
}
