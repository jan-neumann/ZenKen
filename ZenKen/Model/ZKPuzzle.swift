//
//  ZKPuzzle.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 25.09.23.
//

import Foundation

final class ZKPuzzle: ObservableObject, Identifiable, Hashable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case size
        case fields
    }
    
    var id: String
    var size: Int
    
    @Published var fields: [[ZKField]] = []
    
    init(id: String, size: Int) {
        self.id = id
        self.size = size
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        size = try values.decode(Int.self, forKey: .size)
        fields = try values.decode([[ZKField]].self, forKey: .fields)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(size, forKey: .size)
        try container.encode(fields, forKey: .fields)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ZKPuzzle, rhs: ZKPuzzle) -> Bool {
        lhs.id == rhs.id
    }
    
    func allSolved() -> Bool {
        var result = true
        
        fields.forEach { subfields in
            subfields.forEach { field in
                if !field.solved() {
                    result = false
                }
            }
        }
        return result
    }
}
