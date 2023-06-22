//
//  ZKField.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import Foundation

final class ZKField: ObservableObject, Identifiable, Hashable {

    var id: Int = UUID().hashValue
        
    let hint: String?
    @Published var value: Int?
   
    var solution: Int?
    
    let drawLeftBorder: Bool
    let drawRightBorder: Bool
    let drawBottomBorder: Bool
    let drawTopBorder: Bool
    
      
    init(hint: String?, value: Int? = nil, solution: Int? = nil, drawLeftBorder: Bool, drawRightBorder: Bool, drawBottomBorder: Bool, drawTopBorder: Bool) {
     
        self.hint = hint
        self.value = value
        self.solution = solution
        self.drawLeftBorder = drawLeftBorder
        self.drawRightBorder = drawRightBorder
        self.drawBottomBorder = drawBottomBorder
        self.drawTopBorder = drawTopBorder
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
      
    }
    
    static func == (lhs: ZKField, rhs: ZKField) -> Bool {
        lhs.id == rhs.id
    }
}
