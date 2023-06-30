//
//  ZenKenGrid.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKFieldGridView: View {
    
    // MARK: - Constants
    var margin: CGFloat {
        CGFloat(gameModel.fields.count - 1)
    }
    
    let gridSize: Int
    
    @EnvironmentObject var gameModel: GameModel
    @Binding var isPortrait: Bool
    
    @State private var showKeyPad: Bool = false

    // MARK: - Main View
    var body: some View {
        if isPortrait {
            portraitView
        } else {
            landscapeView
        }
    }
}

extension ZKFieldGridView {
    
    var gameGrid : some View {
        GeometryReader { geo in
            VStack(spacing: 1) {
                
                ForEach(gameModel.fields) { fields in
                    
                    HStack(spacing: 1) {
                        
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
                                gameModel.selectedField = field
                            }
                            
                        }
                    }
                    
                }
            }
            .background(.secondary)
             .onChange(of: gameModel.selectedField) { _ in
                 if gameModel.selectedField == nil {
                     withAnimation {
                         showKeyPad = false
                     }
                 }
             }
            
        }
    }
    
    var portraitView : some View {
        VStack(spacing: 0) {
          
            portraitNotesView
            
            gameGrid
           
            portraitNumpad
          
        }
    }
    
    
    var landscapeView : some View {
        HStack(spacing: 0) {
            
            landscapeNumpad
            
            gameGrid
            
            landscapeNotesView
        }
    }
    
    
    var portraitNumpad: some View {
        VStack {
            ZKNumPadView(
                portrait: true,
                gameModel: gameModel
            )
            //.padding(.vertical)
            .opacity(showKeyPad ? 1 : 0)
           // Spacer()
           
        }
    }
    
    var portraitNotesView: some View {
        VStack {
         //   Spacer()
            if let selectedField = gameModel.selectedField {
                ZKNoteSelectionView(
                    portrait: isPortrait,
                    size: gameModel.size,
                    field: selectedField
                )
                
            }
        }
       
    }
    
    var landscapeNumpad : some View {
        ZStack {
            Spacer()
            if !isPortrait {
                ZKNumPadView(
                    portrait: false,
                    gameModel: gameModel)
                    .padding(.vertical)
                    .opacity(showKeyPad ? 1 : 0)
            }
        }
    }
    
    var landscapeNotesView: some View {
        ZStack {
            Spacer()
            
            if !isPortrait,
               let selectedField = gameModel.selectedField
            {
                ZKNoteSelectionView(
                    portrait: isPortrait,
                    size: gameModel.size,
                    field: selectedField
                )
                .opacity(gameModel.selectedField != nil ? 1 : 0)
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
