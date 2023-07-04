//
//  ZKFieldView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI
import ZKGenerator

struct ZKFieldView: View {
    
    @EnvironmentObject var gm: GameModel
    
    // MARK: - Constants
    private let cageColor: Color = .secondary
    private let cageLineWidth: CGFloat = 1
    private let sizeOffset: CGFloat = 2
    
    let gridSize: Int
    let fieldSize: CGFloat
    let color: Color
    
    @ObservedObject var field: ZKField
    
    var valuesAreEqual: Bool {
        if let value = field.value,
           let solution = field.solution {
            return value == solution
        }
        return false
    }
    
    var hintFontSize: CGFloat {
        fieldSize * 0.2
    }
    
    var valueFontSize: CGFloat {
        fieldSize * 0.55
    }
    
    var showNoteGridView: Bool {
        field.notes.contains(where: { $0 })
    }
    
    var noteSpacing: CGFloat {
        fieldSize * 0.13
    }
    var noteHeight: CGFloat {
        fieldSize * 0.1
    }
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .overlay {
                    ZStack {
                        // Cage
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(cageColor)
                                .frame(width:
                                        field.drawLeftBorder ? cageLineWidth : 0)
                            Spacer()
                            Rectangle()
                                .foregroundColor(cageColor)
                                .frame(width:
                                        field.drawRightBorder ? cageLineWidth : 0)
                        }
                        VStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(cageColor)
                                .frame(height:
                                        field.drawTopBorder ? cageLineWidth : 0)
                            Spacer()
                            Rectangle()
                                .foregroundColor(cageColor)
                                .frame(height:
                                        field.drawBottomBorder ? cageLineWidth : 0)
                        }
                        
                        // Value Text
                        Text(field.value != nil ? "\(field.value!)" : "")
                            .font(.system(size: valueFontSize))
                            .foregroundColor((field.value != nil && field.value! == field.solution!) ? .primary : .red)
                            .shadow(radius: 2)
                            .padding(.top, 5)

                        if field.value == nil {
                            noteGridView
                                .opacity(showNoteGridView ? 1 : 0)
                        }
                          
                    }
                    
                }
            
            // Hint Text
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Text(field.hint ?? "")
                        .font(.system(size: hintFontSize).bold())
                        .frame(alignment: .topLeading)
                        .foregroundColor((gm.selectedField != nil && gm.selectedField == field) ? Color.white : Color(.systemBlue))
                        .padding(.top, 2)
                        .padding(.leading, 4)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                }
                Spacer()
                
            }
        }
        .frame(width: fieldSize - sizeOffset,
               height: fieldSize - sizeOffset)
        
    }
}

extension ZKFieldView {
    
    private func noteText(number: Int) -> some View {
        Text(field.notes[number - 1] ? "\(number)" : "•")
    }
    // TODO: Reduce to possible number
    var noteGridView: some View {
        VStack(alignment: .center, spacing: noteSpacing) {
            Spacer()
            HStack(spacing: noteSpacing) {
                noteText(number: 1)
                noteText(number: 2)
                noteText(number: 3)
            }
            .frame(height: noteHeight)
            
            HStack(spacing: noteSpacing) {
                noteText(number: 4)
                
                noteText(number: 5)
                    .opacity(gridSize > 4 ? 1 : 0)
                noteText(number: 6)
                    .opacity(gridSize > 5 ? 1 : 0)
            }
            .frame(height: noteHeight)
            
            HStack(spacing: noteSpacing) {
               noteText(number: 7)
                    .opacity(gridSize > 6 ? 1 : 0)
               noteText(number: 8)
                    .opacity(gridSize > 7 ? 1 : 0)
               noteText(number: 9)
                    .opacity(gridSize > 8 ? 1 : 0)
            }
            .frame(height: noteHeight)
            
        }
        .foregroundColor((gm.selectedField != nil && gm.selectedField == field) ? Color(.systemBackground) : .purple)
        .font(.system(size: hintFontSize))
        .padding(.bottom, noteSpacing)
    }
}

struct ZenKenFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ZKFieldView(
            gridSize: 4,
            fieldSize: 40,
            color: .white,
            field: ZKField(
                cageHint: "1(x)",
                hint: "1(x)",
                value: 1,
                solution: 1,
                drawLeftBorder: true,
                drawRightBorder: true,
                drawBottomBorder: true,
                drawTopBorder: true
            )
        )
    }
}
