//
//  GameModel.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import Foundation
import ZKGenerator

final class GameModel: ObservableObject {
    
    var id: String
    
    @Published var generator: ZKGenerator?
    @Published var selectedField: ZKField?
    @Published var size: Int
    @Published var puzzle: ZKPuzzle
    @Published var showErrors: Bool = false
    
    private var seed: Int
    
    
    // MARK: - Init
    
    init(id: String,
         size: Int = 4,
         seed: Int = 8033042266564781627
    ) {
        self.id = id
        self.size = size
        self.puzzle = ZKPuzzle(id: String(seed), size: size)
        self.seed = seed
    }
    
    // MARK: - Properties
    
    var solutionGrid: [[Int]] {
        guard let problem = generator?.problem else {
            return []
        }
        return problem.standardSolution
    }
    
    // MARK: - Functions
    
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
    
    func restoreOrSetNewProblem(newSeed: Int) {
        seed = newSeed
        id = String(seed)
        
        guard !restore() else {
            return
        }
        
        if generator == nil {
            generator = ZKGenerator(startupSize: size,
                                        seed: seed)
        } else {
            generator?.setNewProblem(size: size,
                                     seed: seed)
        }
        
        guard let generator = generator else {
            fatalError(">> Failure. No generator.")
        }
        
        self.puzzle = ZKPuzzle(id: String(seed), size: size)
        
        for i in 0..<size {
            self.puzzle.fields.append([])
            
            for j in 0..<size {
                let hint = hint(row: i, col: j)
                let cageHint = generator.problem?.getCages().first(where: { $0.getCells().contains((i * size + j)) })?.getClueText() ?? ""
                
                let solution = generator.problem?.standardSolution[i][j]
                let drawLeft = drawLeft(row: i, col: j) || drawLeftBorder(col: j)
                let drawRight = drawRightBorder(col: j)
                let drawTop = drawTop(row: i, col: j) || drawTopBorder(row: i)
                let drawBottom = drawBottomBorder(row: i)
                self.puzzle.fields[i].append(
                    ZKField(
                    cageHint: cageHint,
                    hint: hint ?? "",
                    value: nil,
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

// MARK: - Loading / Saving

extension GameModel {
    
    func save() -> Bool {
        if let data = try? JSONEncoder().encode(puzzle) {
            print(">> data for \(id) saved.")
            UserDefaults.standard.set(data, forKey: id)
            return true
        } else {
            print(">> Could not save data for id: \(String(describing: id)).")
    
        }
        return false
    }
    
    func restore() -> Bool {
        if  id != "",
            let data = UserDefaults.standard.data(forKey: id),
        
            let puzzle = try? JSONDecoder().decode(ZKPuzzle.self, from: data) {
            self.puzzle = puzzle
            print(">> saved data for \(id) restored.")
            print(">> data: \(data)")
            return true
        } else {
            print(">> could not restore data.")
        }
        return false
    }
}
