//
//  ZenKenGrid.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKFieldGridView: View {

    let gridSize: Int
    
    @EnvironmentObject var gameModel: GameModel
    @Binding var isPortrait: Bool
    
    @State private var showKeyPad: Bool = false
    
    var margin: CGFloat {
        CGFloat(gameModel.fields.count - 1)
    }
 
    // MARK: - Main View
    
    var body: some View {
        ZStack {
          
            portraitView
                .opacity(isPortrait ? 1 : 0)
                .disabled(!isPortrait)
           
            landscapeView
                .opacity(isPortrait ? 0 : 1)
                .disabled(isPortrait)
         
        }
    }
}

extension ZKFieldGridView {
    
    func grid(size: CGSize) -> some View {
        VStack(spacing: 1) {
            
            ForEach(gameModel.fields) { fields in
                
                HStack(spacing: 1) {
                    
                    ForEach(fields) { field in
                        
                        let size = isPortrait ?
                        (size.width - margin) / CGFloat(gridSize) :
                        (size.height - margin) / CGFloat(gridSize)
                        
                        ZKFieldView(
                            gridSize: gridSize,
                            fieldSize: size,
                            color: (gameModel.selectedField == field) ? .fieldSelection : Color(.systemBackground),
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
        .background(.tertiary)
        .onChange(of: gameModel.selectedField) { _ in
            if gameModel.selectedField == nil {
                withAnimation(.linear(duration: 0.1)) {
                    showKeyPad = false
                }
            }
        }
    }
    
    var portraitView : some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                portraitNotesView
                
                grid(size: geo.size)
                
                portraitNumpad
            }
        }
    }
    
    
    var landscapeView : some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                landscapeNumpad
                
                grid(size: geo.size)
                    .padding(.top, 10)
                
                landscapeNotesView
            }
        }
    }
    
    
    var portraitNumpad: some View {
        ZStack {
            ZKNumPadView(
                portrait: true,
                gameModel: gameModel
            )
            .opacity(showKeyPad ? 1 : 0)
            Spacer()
        }
        
    }
    
    var portraitNotesView: some View {
        ZStack {
            Spacer()
                .overlay {
                    VStack {
                        Spacer()
                        if let selectedField = gameModel.selectedField {
                            ZKNoteSelectionView(
                                portrait: isPortrait,
                                size: gameModel.size,
                                field: selectedField
                            )
                            
                        }
                    }
                }
            
        }
        
    }
    
    var landscapeNumpad : some View {
        
        HStack(spacing: 0) {
            Spacer()
            ZKNumPadView(
                portrait: false,
                gameModel: gameModel)
            .padding(.vertical)
            .opacity(showKeyPad ? 1 : 0)
           
        }
        
    }
    
    var landscapeNotesView: some View {

        HStack(spacing: 0) {
            if let selectedField = gameModel.selectedField {
                ZKNoteSelectionView(
                    portrait: false,
                    size: gameModel.size,
                    field: selectedField
                )
                .opacity(gameModel.selectedField != nil ? 1 : 0)
            }
            Spacer()
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
