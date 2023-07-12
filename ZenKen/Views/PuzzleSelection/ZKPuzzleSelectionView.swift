//
//  ZKPuzzleSelectionView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 11.07.23.
//

import SwiftUI

struct Puzzle: Codable, Identifiable {
    var id: Int = UUID().hashValue
    let seed: Int
    let size: Int
}

struct ZKPuzzleSelectionView: View {
    
    let puzzles: [Puzzle] = [Puzzle(seed: 7355680666289556746, size: 4),
                             Puzzle(seed: 4506117531934134901, size: 4),
                             Puzzle(seed: 8441276377268450543, size: 4),
                             Puzzle(seed: 2650695855834775852, size: 4),
                             Puzzle(seed: 4712299309725961457, size: 4),
                             Puzzle(seed: 7586567278184753029, size: 4),
                             Puzzle(seed: 2404540539790740176, size: 4),
                             Puzzle(seed: 3317996665054109255, size: 4),
                             Puzzle(seed: 3088282644861366998, size: 4),
                             Puzzle(seed: 5000271045430199282, size: 4)]
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 100)), count: 3)
    
    @State var currentPuzzle: Puzzle?
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(puzzles) { puzzle in
                    puzzleButton(for: puzzle)
                }
            }
            .padding()
        }
        .fullScreenCover(item: $currentPuzzle) { newPuzzle in
            ZKGameView(size: newPuzzle.size,
                       seed: newPuzzle.seed)
        }
    }
    
    func puzzleButton(for puzzle: Puzzle) -> some View {
        Button {
            currentPuzzle = puzzle
        } label: {
            Text("\(puzzle.seed)")
                .padding(5)
        }
        .buttonStyle(.borderedProminent)
        .frame(height: 100)
    }
}

struct ZKPuzzleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZKPuzzleSelectionView()
    }
}
