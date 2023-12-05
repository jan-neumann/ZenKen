//
//  ZKField.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import Foundation

final class ZKField: ObservableObject, Identifiable, Hashable, Codable {
      
    enum CodingKeys: String, CodingKey {
        case id
        case cageHint
        case hint
        case value
        case notes
        case solution
        case drawLeftBorder
        case drawRightBorder
        case drawBottomBorder
        case drawTopBorder
    }
    
    var id: Int = UUID().hashValue
    
    let cageHint: String
    let hint: String?
    @Published var value: Int?
    @Published var notes: [Bool]
    var solution: Int?
    
    let drawLeftBorder: Bool
    let drawRightBorder: Bool
    let drawBottomBorder: Bool
    let drawTopBorder: Bool
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        cageHint = try values.decode(String.self, forKey: .cageHint)
        hint = try values.decodeIfPresent(String.self, forKey: .hint)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
        notes = try values.decode([Bool].self, forKey: .notes)
        solution = try values.decodeIfPresent(Int.self, forKey: .solution)
        drawLeftBorder = try values.decode(Bool.self, forKey: .drawLeftBorder)
        drawRightBorder = try values.decode(Bool.self, forKey: .drawRightBorder)
        drawBottomBorder = try values.decode(Bool.self, forKey: .drawBottomBorder)
        drawTopBorder = try values.decode(Bool.self, forKey: .drawTopBorder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cageHint, forKey: .cageHint)
        try container.encodeIfPresent(hint, forKey: .hint)
        try container.encodeIfPresent(value, forKey: .value)
        try container.encode(notes, forKey: .notes)
        try container.encodeIfPresent(solution, forKey: .solution)
        try container.encode(drawLeftBorder, forKey: .drawLeftBorder)
        try container.encode(drawRightBorder, forKey: .drawRightBorder)
        try container.encode(drawBottomBorder, forKey: .drawBottomBorder)
        try container.encode(drawTopBorder, forKey: .drawTopBorder)
    }
    
    
    init(cageHint: String, hint: String?, value: Int? = nil, solution: Int? = nil, drawLeftBorder: Bool, drawRightBorder: Bool, drawBottomBorder: Bool, drawTopBorder: Bool) {
        
        self.cageHint = cageHint
        self.hint = hint
        self.value = value
        self.solution = solution
        self.drawLeftBorder = drawLeftBorder
        self.drawRightBorder = drawRightBorder
        self.drawBottomBorder = drawBottomBorder
        self.drawTopBorder = drawTopBorder
        self.notes = Array(repeating: false, count: 9)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
      
    }
    
    static func == (lhs: ZKField, rhs: ZKField) -> Bool {
        lhs.id == rhs.id
    }
    
    func solved() -> Bool {
        guard let value = value, let solution = solution else {
            return false
        }
        return value == solution
    }
}
