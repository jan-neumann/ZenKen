//
//  ZenKenGrid.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKFieldGridView: View {
    
    let margin: CGFloat = 10
    let size: Int
    
    @ObservedObject var gameModel: GameModel
    
    var body: some View {
        
        GeometryReader { geo in

            VStack(spacing: 1) {
                
                if gameModel.fields.count > 0 {
                    ForEach(0 ..< size, id: \.self) { row in
                        
                        HStack(alignment: .top, spacing: 1) {
                            
                            ForEach(0 ..< size, id: \.self) { col in
                                ZKFieldView(
                                    size: (geo.size.width - margin) / CGFloat(size),
                                    field: $gameModel.fields[row][col]
                                )
                            }
                        }
                    }
                }
            }
        }
        
    }
}

struct ZenKenGrid_Previews: PreviewProvider {
    static var previews: some View {
        ZKFieldGridView(
            size: 4,
            gameModel: GameModel())
    }
}
