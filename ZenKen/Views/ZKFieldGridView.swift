//
//  ZenKenGrid.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKFieldGridView: View {
    
    // MARK: - Constants
    let margin: CGFloat = 0
    
    let gridSize: Int
    
    @EnvironmentObject var gameModel: GameModel
    @Binding var isPortrait: Bool
    
    @State private var showKeyPad: Bool = false

    // MARK: - Main View
    var body: some View {
        
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                if !isPortrait {
                    NumPadView(gameModel: gameModel)
                        .padding(.vertical)
                        .opacity(showKeyPad ? 1 : 0)
                }
                VStack(alignment: .center, spacing: 0) {
                    Spacer()

                    VStack(spacing: 1) {
                        ForEach(gameModel.fields) { fields in
                            
                            HStack(alignment: .top, spacing: 1) {
                                
                                ForEach(fields) { field in
                                    
                                    let size = isPortrait ?
                                    (geo.size.width - margin) / CGFloat(gridSize) :
                                    (geo.size.height - margin) / CGFloat(gridSize)
                                    
                                    ZKFieldView(
                                        gridSize: gridSize,
                                        fieldSize: size,
                                        color: (gameModel.selectedField == field) ? .fieldSelection : .white,
                                        field: field
                                    )
                                    .foregroundColor(gameModel.selectedField == field ? .blue : .black)
                                    .onTapGesture {
                                        showKeyPad = true
                                        //field.isSelected = true
                                        gameModel.selectedField = field
                                    }
                                 
                                    
                                }
                            }
                           
                        }
                    }
                    .background(.secondary)
                    
                    if isPortrait {
                        NumPadView(gameModel: gameModel)
                            .padding(.vertical)
                            .opacity(showKeyPad ? 1 : 0)
                           
                    }
                    Spacer()
                }

                Spacer()
            }
            
        }
        .onChange(of: gameModel.selectedField) { _ in
            
            if gameModel.selectedField == nil {
                withAnimation {
                    showKeyPad = false
                }
            }
        }

    }
}


// MARK: - Previews

struct ZenKenGrid_Previews: PreviewProvider {
    static var previews: some View {
        ZKFieldGridView(
            gridSize: 4,
            isPortrait: .constant(false)
        )
        .environmentObject(GameModel())
    }
}
