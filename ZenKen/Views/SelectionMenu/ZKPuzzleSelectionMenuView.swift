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
    
    @StateObject var viewModel = ZKPuzzleSelectionMenuViewModel()
    let size: Int
    let puzzles: [ZKPuzzleData]
  
    // MARK: - Private
  
    @Environment(\.dismiss) private var dismiss
       
    // MARK: - Main View
    
    var body: some View {
        VStack {
            headerView
                .background {
                    if Settings.adsEnabled {
                        viewModel.interstitialAd
                            .frame(width: .zero, height: .zero)
                    }
                }
            ScrollView {
                LazyVGrid(columns: viewModel.columns, spacing: 15) {
                    ForEach(viewModel.puzzles) { puzzle in
                        puzzleButton(
                            for: puzzle,
                            locked: puzzle.number > viewModel.solved
                        )
                    }
                }
                .padding()
            }
            Spacer()
        }
        .fullScreenCover(item: $viewModel.currentPuzzle) { newPuzzle in
            ZKGameView(size: newPuzzle.size,
                       seed: newPuzzle.seed,
                       solved: $viewModel.currentPuzzleSolved
            )
            
        }
        .transition(.slide)
        .onChange(of: viewModel.currentPuzzleSolved) { newValue in
            if newValue {
                viewModel.puzzleSolved()
            }
        }
        .onChange(of: viewModel.currentPuzzle) { newValue in
            
            
            if newValue == nil {
                viewModel.presentInterstital()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                // Back button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title.bold())
                        .padding(10)
                }
                .frame(width: 70, height: 70)
                .foregroundStyle(Color.white)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                // Settings button
                Button {
                    // TODO: Toggle settings sheet
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title.bold())
                }
                .frame(width: 70, height: 70)
                .foregroundStyle(Color.white)
            }
            
        }
        .navigationBarBackButtonHidden()
        .background(Color(.systemBackground).gradient)
        .onAppear {
            viewModel.initialize(size: size, puzzles: puzzles)
        }
    }
    
    // MARK: - Sub Views
    
    var headerView: some View {
        Rectangle()
            .foregroundStyle(.quinary)
            .overlay {
                VStack {
                    Text(viewModel.headlineText)
                        .font(.title.bold())
                        .padding()
                    HStack {
                        Image(systemName: "square.grid.3x3")
                        Text(viewModel.solvedText)
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
                viewModel.interstitialAdCoordinator.loadAd()
            }
            viewModel.currentPuzzle = puzzle
            viewModel.currentPuzzleNumber = puzzle.number
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
                .opacity(puzzle.number < viewModel.solved ? 1 : 0)
            }
            .frame(width: 80, height: 90)
        }
        .frame(width: 100, height: 100)
        .buttonStyle(.bordered)
        .tint(locked ? .gray : .indigo)
        .disabled(locked)
        
    }
}

// MARK: - Previews

#Preview {
    ZKPuzzleSelectionMenuView(
        viewModel: ZKPuzzleSelectionMenuViewModel(),
        size: 4,
        puzzles: ZKPuzzleData.previewData
        )
}
