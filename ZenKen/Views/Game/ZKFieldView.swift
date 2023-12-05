//
//  ZKFieldView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI
import ZKGenerator

struct ZKFieldView: View {
    
    // MARK: - Constants
    
    private let cageColor: Color = .primary
    private let cageLineWidth: CGFloat = 1.5
    private let sizeOffset: CGFloat = 2
    
    // MARK: - Public
    
    let gridSize: Int
    let fieldSize: CGFloat
    let color: Color
    
    @ObservedObject var field: ZKField
     
    // MARK: - Private
    
    @EnvironmentObject private var gm: GameModel
    
    // MARK: - Properties
    
    private var valuesAreEqual: Bool {
        if let value = field.value,
           let solution = field.solution {
            return value == solution
        }
        return false
    }
    
    private var showNoteGridView: Bool {
        field.notes.contains(where: { $0 })
    }
    
    private var hintFontSize: CGFloat {
        size * 0.25
    }
    
    private var valueFontSize: CGFloat {
        size * 0.55
    }
    
    private var noteSpacing: CGFloat {
        size * 0.13
    }
    private var noteHeight: CGFloat {
        size * 0.1
    }
    
    private var size: CGFloat {
        (fieldSize - sizeOffset < 70) ? (fieldSize - sizeOffset) : 70
    }
    
    private var valueError: Bool {
        guard let fieldValue = field.value,
              let solution = field.solution else {
            return false
        }
        return fieldValue != solution
    }
    
    // MARK: - Main View
    
    var body: some View {
        ZStack {
            color
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
                            .foregroundColor((gm.showErrors && valueError)
                                                ? .red : .primary
                            )
                            .shadow(radius: 2)
                            .padding(.top, 5)

                        if field.value == nil {
                            noteGridView
                                .opacity(showNoteGridView ? 1 : 0)
                        }
                          
                    }
                    
                }
            
            // Hint Text
            hintText

        }
        .frame(width: size, height: size)
    }
}

// MARK: - Sub Views

extension ZKFieldView {
    
    private var hintText: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Text(field.hint ?? "")
                    .font(.system(size: hintFontSize).bold())
                    .frame(alignment: .topLeading)
                    .foregroundColor((gm.selectedField != nil && gm.selectedField == field) ? Color.white : Color.hint)
                    .padding(.top, 2)
                    .padding(.leading, 4)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            Spacer()
        }
    }
    
    private func noteText(number: Int) -> some View {
        Text(field.notes[number - 1] ? "\(number)" : "•")
    }

    private var noteGridView: some View {
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
        .foregroundColor((gm.selectedField != nil && gm.selectedField == field) ? .white : Color.note)
        .font(.system(size: hintFontSize))
        .padding(.bottom, noteSpacing)
    }
}

// MARK: - Previews

struct ZenKenFieldView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZKFieldView(
            gridSize: 4,
            fieldSize: 40,
            color: .white,
            field: ZKField(
                cageHint: "4096 (x)",
                hint: "4096 (x)",
                value: 9,
                solution: 1,
                drawLeftBorder: true,
                drawRightBorder: true,
                drawBottomBorder: true,
                drawTopBorder: true
            )
        )
        .environmentObject(GameModel(id: "123"))
        .previewLayout(.sizeThatFits)
    }
}
