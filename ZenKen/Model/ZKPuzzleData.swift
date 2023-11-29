//
//  ZKPuzzleData.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 29.11.23.
//

import Foundation

struct ZKPuzzleData: Codable, Identifiable, Hashable {
    var id: Int = UUID().hashValue
    let number: Int
    let seed: Int
    let size: Int
    let solved: Bool
    
    // MARK: Preview Data
    
    static let previewData: [ZKPuzzleData] = [
        .init(number: 1, seed: 7355680666289556746, size: 9,  solved: false),
        .init(number: 2, seed: 4506117531934134901, size: 9,  solved: false),
        .init(number: 3, seed: 8441276377268450543, size: 9,  solved: false),
        .init(number: 4, seed: 2650695855834775852, size: 4,  solved: false),
        .init(number: 5, seed: 4712299309725961457, size: 4,  solved: false),
        .init(number: 6, seed: 7586567278184753029, size: 4,  solved: false),
        .init(number: 7, seed: 2404540539790740176, size: 4,  solved: false),
        .init(number: 8, seed: 3317996665054109255, size: 4,  solved: false),
        .init(number: 9, seed: 3088282644861366998, size: 4,  solved: false),
        .init(number: 10, seed: 5000271045430199282, size: 4, solved: false)
    ]
}

final class ZKPuzzles: ObservableObject {
    
    var puzzles4x4: [ZKPuzzle] = []
    
    init() {
        self.puzzles4x4 = load("puzzles4x4")
    }
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save<T: Encodable>(_ object: T, to fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName, isDirectory: false)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(object)
        try data.write(to: url)
    }
}
