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
    
    func backgroundColor(for field: ZKField) -> Color {
        
        if gameModel.showErrors,
           field.value != nil,
           field.value == field.solution {
            return Color.green.opacity(0.5)
        }
        
        return gameModel.selectedField == field ?
            .fieldSelection :
        Color.fieldBackground
    }
 
    // MARK: - Main View
    
    var body: some View {
        if isPortrait {
            portraitView
        } else {
            landscapeView
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
                         
                        let textColor = gameModel.selectedField == field ?
                            Color.white : .primary
                        
                        ZKFieldView(
                            gridSize: gridSize,
                            fieldSize: size,
                            backgroundColor: backgroundColor(for: field),
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
                Spacer()
                    .overlay(alignment: .bottom) {
                        portraitNotesView(width: geo.size.width)
                    }
                    
                grid(size: geo.size)
                  
                Spacer()
                    .overlay (alignment: .top) {
                        portraitNumpad
                    }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var portraitNumpad: some View {
            ZKNumPadView(
                portrait: true,
                gameModel: gameModel, 
                show: $showKeyPad
            )
            .opacity(showKeyPad ? 1 : 0)
    }
    
    private func portraitNotesView(width: CGFloat) -> some View {
        ZKNoteSelectionView(
            portrait: isPortrait,
            size: gameModel.size,
            maxWidth: width,
            field: $gameModel.selectedField,
            show: $showKeyPad
        )
        .opacity(showKeyPad ? 1 : 0)
        .padding(.bottom, 5)
    }
    
    // MARK: - Landscape orientation views
    
    private var landscapeView : some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    
                    Spacer()
                        .overlay(alignment: .trailing) {
                            landscapeNotesView(width: 300)
                        }
                    
                    grid(size: geo.size)
                        .padding(.horizontal, 10)
                    
                    Spacer()
                        .overlay(alignment: .leading) {
                            landscapeNumpad
                        }
                }

                Spacer()
            }

        }
    }
    
    private var landscapeNumpad : some View {
        HStack(spacing: 0) {
        
            ZKNumPadView(
                portrait: false,
                gameModel: gameModel, 
                show: $showKeyPad
            )
            .padding(.vertical)
            .opacity(showKeyPad ? 1 : 0)
            
            Spacer()
        }
    }
    
    private func landscapeNotesView(width: CGFloat) -> some View {
        ZKNoteSelectionView(
            portrait: false,
            size: gameModel.size,
            maxWidth: width,
            field: $gameModel.selectedField,
            show: $showKeyPad
        )
        .opacity(showKeyPad ? 1 : 0)
    }
}
