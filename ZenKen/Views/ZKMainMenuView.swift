//
//  ZKMainMenuView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 29.11.23.
//

import SwiftUI
import ZKGenerator

struct ZKMainMenuView: View {
    
    @StateObject private var allPuzzles = ZKPuzzles(loadFromBundle: true)
   
    private func puzzles(for size: Int) -> [ZKPuzzleData] {
        switch size {
        case 4:
            return allPuzzles.puzzles4x4
        case 5:
            return allPuzzles.puzzles5x5
        case 6:
            return allPuzzles.puzzles6x6
        case 7:
            return allPuzzles.puzzles7x7
        case 8:
            return allPuzzles.puzzles8x8
        case 9:
            return allPuzzles.puzzles9x9
        default:
            return []
        }
    }
    var body: some View {
        
        if allPuzzles.loadingFinished {
            NavigationStack {
                VStack {
                    Text("Welcome to ZenKen!")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    ForEach(4..<10) { size in
                        NavigationLink {
                            ZKPuzzleSelectionMenuView(
                                size: size,
                                puzzles: puzzles(for: size)
                            )
                        } label: {
                            Label("\(size) x \(size) Puzzles", systemImage: "play")
                                .frame(height: 50)
                        }
                        
                        .buttonStyle(.bordered)
                        
                        .tint(.blue)
                        .padding(.vertical, 5)
                    }
                   
                    Spacer()
                    
                }
                .padding()
          
              
                
            }
            .statusBarHidden()
        } else {
            ProgressView()
        }
    }
       
}

#Preview {
    ZKMainMenuView()
}
