//
//  ZenKenGrid.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKFieldGridView: View {

    // MARK: - Public
    
    let gridSize: Int
    
    @EnvironmentObject var gameModel: GameModel
    @Binding var isPortrait: Bool
    @Binding var fieldEditChange: Bool
    @Binding var hintMode: Bool
 
    // MARK: - Private
    
    @State private var showKeyPad: Bool = false
    
    // MARK: - Properties
    
    var margin: CGFloat {
        CGFloat(gameModel.puzzle.fields.count - 1)
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

// MARK: - Sub Views

extension ZKFieldGridView {
    
    private func grid(size: CGSize) -> some View {
        VStack(spacing: 1) {
            
            ForEach(gameModel.puzzle.fields) { fields in
                
                HStack(spacing: 1) {
                    
                    ForEach(fields) { field in
                        
                        let size = isPortrait ?
                        (size.width - margin) / CGFloat(gridSize) :
                        (size.height - margin) / CGFloat(gridSize)
                         
                        let color = gameModel.selectedField == field ?
                            .fieldSelection :
                            Color.fieldBackground
                        let textColor = gameModel.selectedField == field ?
                            Color.white : .primary
                        
                        ZKFieldView(
                            gridSize: gridSize,
                            fieldSize: size,
                            color: color,
                            textColor: textColor,
                            field: field
                        )
                        .onTapGesture {
                            if hintMode {
                                field.value = field.solution
                                hintMode = false
                            } else {
                                showKeyPad = true
                                gameModel.selectedField = field
                            }
                        }
                    }
                }
                
            }
        }
        .shadow(color: .indigo.opacity(0.6), radius: !hintMode ? 0 : 5)
        .onChange(of: gameModel.selectedField) { _ in
            if gameModel.selectedField == nil {
                withAnimation(.linear(duration: 0.1)) {
                    showKeyPad = false
                }
                fieldEditChange = true
            }
        }
        .onChange(of: showKeyPad) { newValue in
            if !newValue {
                gameModel.selectedField = nil
            }
        }
        .animation(.smooth, value: hintMode)
        
    }
    
    // MARK: - Portrait orientation views
    
    private var portraitView : some View {
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
    
    private var portraitNumpad: some View {
        VStack {
            ZKNumPadView(
                portrait: true,
                gameModel: gameModel
            )
            .opacity(showKeyPad ? 1 : 0)
        }
        
    }
    
    private var portraitNotesView: some View {
        VStack(spacing: 0) {
            Spacer()
            if let selectedField = gameModel.selectedField {
                ZKNoteSelectionView(
                    portrait: isPortrait,
                    size: gameModel.size,
                    field: selectedField, 
                    show: $showKeyPad
                )
                .opacity(showKeyPad ? 1 : 0)
                .padding(.bottom, 5)
            }
        }
    }
    
    // MARK: - Landscape orientation views
    
    private var landscapeView : some View {
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
    
    private var landscapeNumpad : some View {
        HStack(spacing: 0) {
        
            ZKNumPadView(
                portrait: false,
                gameModel: gameModel)
            .padding(.vertical)
            .opacity(showKeyPad ? 1 : 0)
            
            Spacer()
        }
    }
    
    private var landscapeNotesView: some View {
        HStack(spacing: 0) {
            
            Spacer()
            
            if let selectedField = gameModel.selectedField {
                ZKNoteSelectionView(
                    portrait: false,
                    size: gameModel.size,
                    field: selectedField, 
                    show: $showKeyPad
                )
                .padding(.vertical, 10)
                .opacity(showKeyPad ? 1 : 0)
            }
        }
     
    }
}


// MARK: - Previews

struct ZenKenGrid_Previews: PreviewProvider {
    static var previews: some View {
        ZKFieldGridView(
            gridSize: 4,
            isPortrait: .constant(false), 
            fieldEditChange: .constant(false), 
            hintMode: .constant(false)
        )
        .environmentObject(GameModel(id: "0"))
    }
}
