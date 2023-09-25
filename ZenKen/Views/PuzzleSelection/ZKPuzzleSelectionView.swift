//
//  ZKPuzzleSelectionView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 11.07.23.
//

import SwiftUI

struct Puzzle: Codable, Identifiable {
    var id: Int = UUID().hashValue
    let number: Int
    let seed: Int
    let size: Int
    let locked: Bool
}

struct ZKPuzzleSelectionView: View {
    
    let puzzles: [Puzzle] = [Puzzle(number: 1, seed: 7355680666289556746, size: 9, locked: false),
                             Puzzle(number: 2, seed: 4506117531934134901, size: 9, locked: false),
                             Puzzle(number: 3, seed: 8441276377268450543, size: 9, locked: false),
                             Puzzle(number: 4, seed: 2650695855834775852, size: 4, locked: false),
                             Puzzle(number: 5, seed: 4712299309725961457, size: 4, locked: false),
                             Puzzle(number: 6, seed: 7586567278184753029, size: 4, locked: false),
                             Puzzle(number: 7, seed: 2404540539790740176, size: 4, locked: false),
                             Puzzle(number: 8, seed: 3317996665054109255, size: 4, locked: false),
                             Puzzle(number: 9, seed: 3088282644861366998, size: 4, locked: false),
                             Puzzle(number: 10, seed: 5000271045430199282, size: 4, locked: true)]
    
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: 120))]
    
    @State var currentPuzzle: Puzzle?
    
    // MARK: - Main View
    
    var body: some View {
        VStack {
            Text("4 x 4 Puzzles")
                .font(.title)
                .padding()
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(puzzles) { puzzle in
                    puzzleButton(for: puzzle)
                }
            }
            .padding()
            Spacer()
        }
        .fullScreenCover(item: $currentPuzzle) { newPuzzle in
            ZKGameView(size: newPuzzle.size,
                       seed: newPuzzle.seed)
        }
    }
    
    // MARK: - Sub Views
    
    func puzzleButton(for puzzle: Puzzle) -> some View {
        Button {
            currentPuzzle = puzzle
        } label: {
            VStack {
                Text("\(puzzle.number)")
                    .font(.title)
                    .padding(.bottom, 5)
                Image(systemName: puzzle.locked ? "lock" : "lock.open")
                    .font(.largeTitle)
                    .bold()
                
            }
            .frame(width: 80, height: 90)
        }
        .tint(puzzle.locked ? .gray : .cyan)
        .frame(width: 100, height: 100)
        .buttonStyle(.borderedProminent)
        .disabled(puzzle.locked)
       
        
    }
}

// MARK: - Previews

struct ZKPuzzleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZKPuzzleSelectionView()
    }
}
