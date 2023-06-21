//
//  SeedFinder.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import Foundation
import ZKGenerator

final class SeedFinder: ObservableObject {
    
    @Published var generator: ZKGenerator?
    @Published var solution: [[Int]]?
    @Published var seed = 8033042266564781627
    @Published var size = 8
    @Published var isUnique = true
    @Published var useNewSeed: Bool = false
    @Published var tries: Int = 15
    
    var currentUnitCageCount = 0
    var maxUnitCageCount = 0
    var validPuzzles = 0
    var run = 0
    
    var stop = false
    var waitForTimeout = true
    
    var theSolutionBrute = false
    var theSolutionDFS = false
    var foundSolutionTimes = 0
    
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
    
    func setNewProblem() {
        isUnique = true
        if generator == nil {
            generator = ZKGenerator(startupSize: size,
                                        seed: seed)
        } else {
            generator?.setNewProblem(size: size,
                                     seed: seed)
        }
        let uniqueSolution = findSolution(algorithm: .DFS)
        
//        if !uniqueSolution {
//            print(">> FOUND NO UNIQUE SOLUTION FOR SEED: \(self.seed)")
//        } else {
//            print(">> \(self.seed) IS A CANDIDATE FOR THE GAME.")
//        }
    }
    
    func findSolution(algorithm: AlgorithmType) {
        guard let generator = generator else {
            fatalError(">> ERROR: No generator present.")
        }
        
        var success: Bool = false
        var elapsedTime: String?
        var noUniqueSolution: Bool = false
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let strongSelf = self else {
                return
            }
           
            
            for i in 0..<strongSelf.tries {
                print(">> start to find a solution with algorithm: \(algorithm.rawValue), try: \(i+1)")
                
                if noUniqueSolution {
                    break
                }
                
                switch algorithm {
                case .DFS:
                    elapsedTime = generator.solveProblem(algorithm: .DFS, success: &success)
                case .DLX:
                    elapsedTime = generator.solveProblem(algorithm: .DLX, success: &success)
                case .BruteForce:
                    elapsedTime = generator.solveProblem(algorithm: .BruteForce, success: &success)
                }
                
                if let output = elapsedTime {
                    print(">> solution: \(output)")
                }
                
                DispatchQueue.main.async {
                    if algorithm != .DLX {
                        strongSelf.createSolution(solution: generator.solution)
                    } else {
                        strongSelf.solution = generator.dlxSolution
                    }
                    if let solution = strongSelf.solution,
                       let isSolutionUnique = strongSelf.verifyUniqueness(attempt: solution) {
                          
                        if !isSolutionUnique {
                            print(">> solution is not unique at try: \(i+1). Abort.")
                            noUniqueSolution = true
                            strongSelf.isUnique = false
                    
                        } else {
                            print(">> At try \(i+1): solution for seed \(strongSelf.seed) seems to be unique.")
                        }
                    }
                }
            }

        }
    }
    
    private func verifyUniqueness(attempt: [[Int]]) -> Bool? {
        guard let officialSolution = generator?.problem?.standardSolution else {
            return nil
        }
        return attempt.elementsEqual(officialSolution)
    }
    
    // Working unoptimized version
    private func createSolution(solution: [Int: Set<Int>]) {
        self.solution = []

        for i in 0..<size {
            self.solution?.append([Int]())
            for _ in 0..<size {
                self.solution?[i].append(0)
            }
        }

        var values = [Int](repeating: 0, count: size * size)

        var count = 0

        var enumerator: Set<Int>.Iterator

        for i in 0..<solution.count {
            enumerator = solution[i]!.makeIterator()

            if let current = enumerator.next() {
                values[count] = current
            }

            count += 1
        }

        for i in 0..<size {
            for j in 0..<size {
                self.solution?[i][j] = values[i * size + j]
            }
        }
        
    }
    
//    private func createSolution(solution: [Int: Set<Int>]) {
//        self.solution = Array(repeating: Array(repeating: 0, count: size), count: size)
//
//        var values = [Int](repeating: 0, count: size * size)
//
//        var count = 0
//
//        for set in solution.values {
//            if let current = set.first {
//                values[count] = current
//            }
//
//            count += 1
//        }
//
//        for i in 0..<size {
//            for j in 0..<size {
//                self.solution?[i][j] = values[i * size + j]
//            }
//        }
//    }

    
//    private func createSolution(solution: [Int: Set<Int>]) {
//        // Use map instead of nested loops to create a 2D array of zeros
//        self.solution = Array(repeating: Array(repeating: 0, count: size), count: size)
//
//        var values = [Int](repeating: 0, count: size * size)
//
//        var count = 0
//
//        var enumerator: Set<Int>.Iterator
//
//        for i in 0..<solution.count {
//            enumerator = solution[i]!.makeIterator()
//
//            if let current = enumerator.next() {
//                values[count] = current
//            }
//
//            count += 1
//        }
//
//        // Use flatMap instead of nested loops to assign values to the solution array
//        self.solution = values.flatMap { value in
//            return Array(repeating: value, count: size)
//        }
//    }


}

