//
//  ZKField.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import Foundation

struct ZKField: Codable, Identifiable {
    
    var id: Int = UUID().hashValue
    
    
    let hint: String?
    var value: Int?
    var solution: Int?
    
    let drawLeftBorder: Bool
    let drawRightBorder: Bool
    let drawBottomBorder: Bool
    let drawTopBorder: Bool
    
}
