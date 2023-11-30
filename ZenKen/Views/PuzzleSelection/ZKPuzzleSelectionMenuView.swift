//
//  ZKPuzzleSelectionMenuView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 11.07.23.
//

import SwiftUI
import ZKGenerator

struct ZKPuzzleSelectionMenuView: View {

    let puzzles: [ZKPuzzleData]
    let size: Int
    
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: 120))]

    @State private var currentPuzzle: ZKPuzzleData?
    
    @AppStorage("4x4Solved") var solved4x4: Int = 1
    
    
    private var solved: Int {
        switch size {
        case 4:
            return solved4x4
        default:
            return 0
        }
    }
    
    // MARK: - Init
    
    init(size: Int, puzzles: [ZKPuzzleData]) {
        self.size = size
        self.puzzles = puzzles
    }
    
    // MARK: - Main View
    
    var body: some View {
        
        VStack {
            Text("\(size) x \(size) Puzzles")
                .font(.title)
                .padding()
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(puzzles) { puzzle in
                    puzzleButton(
                        for: puzzle,
                        locked: puzzle.number > solved
                    )
                }
            }
            .padding()
            Spacer()
        }
        .fullScreenCover(item: $currentPuzzle) { newPuzzle in
            ZKGameView(size: newPuzzle.size,
                       seed: newPuzzle.seed)
        }
        .transition(.slide)
    }
    
    // MARK: - Sub Views
    
    func puzzleButton(for puzzle: ZKPuzzleData, locked: Bool) -> some View {
        Button {
            currentPuzzle = puzzle
        } label: {
            VStack {
                Text("\(puzzle.number)")
                    .font(.title)
                    .padding(.bottom, 5)
                Image(systemName: locked ? "lock" : "lock.open")
                    .font(.largeTitle)
                    .bold()
                
            }
            .frame(width: 80, height: 90)
        }
        .frame(width: 100, height: 100)
        .buttonStyle(.bordered)
        .buttonBorderShape(.buttonBorder)
        .tint(locked ? .gray : .blue)
        .disabled(locked)
       
    }
}

// MARK: - Helper Functions

extension ZKPuzzleSelectionMenuView {
    
//    private func previousPuzzleSolved(puzzle: ZKPuzzleData, allPuzzles: [ZKPuzzleData]) -> Bool {
//        guard let firstPuzzle = allPuzzles.first else {
//            return false
//        }
//        if puzzle.id == firstPuzzle.id {
//            return true
//        }
//        
//        // find index of previous puzzle
//        guard let indexOfPuzzle = allPuzzles.firstIndex(where: { $0.id == puzzle.id }) else {
//            return false
//        }
//        let indexOfPreviousPuzzle = indexOfPuzzle - 1
//        
//        if indexOfPreviousPuzzle >= 0 {
//            return allPuzzles[indexOfPreviousPuzzle].solved
//        }
//        return false
//    }
    
}

// MARK: - Previews

#Preview {
    ZKPuzzleSelectionMenuView(size: 4, 
                              puzzles: ZKPuzzleData.previewData
    )
}
