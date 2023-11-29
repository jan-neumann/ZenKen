//
//  ZKPuzzles.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 29.11.23.
//

import SwiftUI

final public class ZKPuzzles: ObservableObject {
    
    public var puzzles4x4: [ZKPuzzle] = []
    public var puzzles5x5: [ZKPuzzle] = []
    public var puzzles6x6: [ZKPuzzle] = []
    public var puzzles7x7: [ZKPuzzle] = []
    public var puzzles8x8: [ZKPuzzle] = []
    public var puzzles9x9: [ZKPuzzle] = []
    
    public init(path: String) {
        self.puzzles4x4 = load(path + "puzzles4x4")
    }
    
    public func load<T: Decodable>(_ filename: String) -> T {
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
    
    public func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    public func save<T: Encodable>(_ object: T, to fileName: String) throws {
        let url = getDocumentsDirectory().appendingPathComponent(fileName, isDirectory: false)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(object)
        try data.write(to: url)
    }
}
