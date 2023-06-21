//
//  GameModel.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import Foundation
import ZKGenerator

final class GameModel: ObservableObject {
    
    @Published var generator: ZKGenerator?
   // @Published var solution: [[Int]]?
    @Published var fields: [[ZKField]] = []
   
    @Published var size = 8
  
    private var seed = 8033042266564781627
    
    var solutionGrid: [[Int]] {
        guard let problem = generator?.problem else {
            return []
        }
        return problem.standardSolution
    }
    
    private func cageID(row: Int, col: Int) -> Int? {
        guard let cageIDs = generator?.cageIDs else {
            return nil
        }
        return cageIDs[row * size + col]
    }
    
    func cage(row: Int, col: Int) -> Cage? {
        guard let cages = generator?.problem?.getCages(),
              let cageID = cageID(row: row, col: col) else {
            print(">> No cages or no cageID.")
            return nil
        }
        return cages[cageID]
    }
    
    func drawLeft(row: Int, col: Int) -> Bool {
        guard let cages = generator?.problem?.getCages(),
              let cageID = cageID(row: row, col: col) else {
            print(">> No cages or no cageID.")
            return false
        }
        let valToCheck = row * size + (col - 1)
        //return false
        return (cages[cageID].getCells().first(where: { $0 == valToCheck }) == nil)
        
    }
    
    func drawTop(row: Int, col: Int) -> Bool {
        guard let cages = generator?.problem?.getCages(),
              let cageID = cageID(row: row, col: col) else {
            print(">> No cages or no cageID.")
            return false
        }
        let valToCheck = (row - 1) * size + col
        return (cages[cageID].getCells().first(where: { $0 == valToCheck }) == nil)
    }
    
    func drawRightBorder(col: Int) -> Bool {
        (col + 1) >= size
    }
    
    func drawTopBorder(row: Int) -> Bool {
        (row - 1) < 0
    }
    
    func drawBottomBorder(row: Int) -> Bool {
        (row + 1) >= size
    }
    
    func drawLeftBorder(col: Int) -> Bool {
       (col - 1) < 0
    }
    
    func hint(row: Int, col: Int) -> String? {
        guard let cages = generator?.problem?.getCages() else {
            print(">> no generator, no problem or, no cages.")
            return nil
        }
        
        for cage in cages {
            let cageCol = cage.getCells()[0] % size
            let cageRow = cage.getCells()[0] / size
            if row == cageRow,
               col == cageCol {
                return cage.getClueText()
            }
        }
        return nil
    }
    
    func setNewProblem(newSeed: Int) {
        seed = newSeed
    
        if generator == nil {
            generator = ZKGenerator(startupSize: size,
                                        seed: seed)
        } else {
            generator?.setNewProblem(size: size,
                                     seed: seed)
        }
        
        guard let generator = generator else {
            fatalError(">> Failure.No generator.")
        }
        
        fields = []
        
        for i in 0..<size {
            fields.append([])
            
            for j in 0..<size {
                let hint = hint(row: i, col: j)
                let solution = generator.problem?.standardSolution[i][j]
                let drawLeft = drawLeft(row: i, col: j) || drawLeftBorder(col: j)
                let drawRight = drawRightBorder(col: j)
                let drawTop = drawTop(row: i, col: j) || drawTopBorder(row: i)
                let drawBottom = drawBottomBorder(row: i)
                fields[i].append(
                    ZKField(
                    hint: hint ?? "",
                    value: 0,
                    solution: solution ?? 0,
                    drawLeftBorder: drawLeft,
                    drawRightBorder: drawRight,
                    drawBottomBorder: drawBottom,
                    drawTopBorder: drawTop)
                )
            }
        }
    }
    
}