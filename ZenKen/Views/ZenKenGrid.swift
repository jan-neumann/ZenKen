//
//  ZenKenGrid.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZenKenGrid: View {
    @ObservedObject var seedfinder: SeedFinder
    
    var body: some View {
        
        VStack(spacing: 1) {
            let solutionGrid = seedfinder.solution ?? []
            let actualSolution = seedfinder.generator?.problem?.standardSolution
            
            ForEach(0 ..< seedfinder.size, id: \.self) { row in
        
                HStack(alignment: .top, spacing: 1) {
                    ForEach(0 ..< seedfinder.size, id: \.self) { col in
                        
                        if solutionGrid.count > 0 {
                            ZenKenField(
                                hint: seedfinder.hint(row: row, col: col),
                                value: solutionGrid[row][col],
                                solution: actualSolution?[row][col],
                                        cage: seedfinder.cage(row: row, col: col),
                                drawLeft: seedfinder.drawLeft(row: row, col: col) ||                seedfinder.drawLeftBorder(col: col),
                                drawRight: seedfinder.drawRightBorder(col: col),
                                drawTop:  seedfinder.drawTop(row: row, col: col) || seedfinder.drawTopBorder(row: row),
                                drawBottom: seedfinder.drawBottomBorder(row: row)
                                
                            )
                           
                        } else {
                            Rectangle()
                                .foregroundColor(.secondary)
                                .overlay(
                                    ProgressView()
                                )
                                .frame(width: 70, height: 70)
                           
                        }
                    }
                }
            }
        }
        
        
    }
}

struct ZenKenGrid_Previews: PreviewProvider {
    static var previews: some View {
        ZenKenGrid(seedfinder: SeedFinder())
    }
}
