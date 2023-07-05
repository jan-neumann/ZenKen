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
                        .onTapGesture {
                            showKeyPad = true
                            gameModel.selectedField = field
                        }
                        
                    }
                }
                
            }
        }
        .background(Color(.tertiarySystemFill))
        .onChange(of: gameModel.selectedField) { _ in
            if gameModel.selectedField == nil {
                withAnimation(.linear(duration: 0.1)) {
                    showKeyPad = false
                }
            }
        }
    }
    
    // MARK: - Portrait orientation views
    
    var portraitView : some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                portraitNotesView
                
                HStack {
                    Spacer()
                    grid(size: geo.size)
                    Spacer()
                    
                }
                portraitNumpad
            }
        }
    }
    
    var portraitNumpad: some View {
        VStack {
            ZKNumPadView(
                portrait: true,
                gameModel: gameModel
            )
            .opacity(showKeyPad ? 1 : 0)
            Spacer()
        }
        
    }
    
    var portraitNotesView: some View {
        VStack(spacing: 0) {
            Spacer()
            if let selectedField = gameModel.selectedField {
                ZKNoteSelectionView(
                    portrait: isPortrait,
                    size: gameModel.size,
                    field: selectedField
                )
                .padding(.vertical, 10)
            }
        }
    }
    
    // MARK: - Landscape orientation views
    
    var landscapeView : some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 0) {
                landscapeNotesView
                   
                VStack {
                    Spacer()
                    grid(size: geo.size)
                        .padding(.horizontal, 10)
                    Spacer()
                }
                
                landscapeNumpad
                
            }
        }
    }
    
    var landscapeNumpad : some View {
        HStack(spacing: 0) {
        
            ZKNumPadView(
                portrait: false,
                gameModel: gameModel)
            .padding(.vertical)
            .opacity(showKeyPad ? 1 : 0)
            
            Spacer()
        }
    }
    
    var landscapeNotesView: some View {
        HStack(spacing: 0) {
            
            Spacer()
            
            if let selectedField = gameModel.selectedField {
                ZKNoteSelectionView(
                    portrait: false,
                    size: gameModel.size,
                    field: selectedField
                )
                .padding(.vertical, 10)
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
