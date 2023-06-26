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
    private let cageColor: Color = .black
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
        switch gridSize {
        case 9:
            return 10
        case 8:
            return 12
        case 7:
            return 14
        case 6:
            return 16
        case 5:
            return 18
        case 4:
            return 20
        default:
            return 20
        }
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
                            .font(.title)
                            .foregroundColor((field.value != nil && field.value! == field.solution!) ? .black : .red)
                            .shadow(radius: 2)
                            .padding(.top, 5)
                        
                        
                        if field.value == nil {
                            noteGridView
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
            
            // Actual solution
//            VStack(alignment: .trailing) {
//                Spacer()
//                HStack(alignment: .bottom) {
//                    Spacer()
//                    Text("\(field.solution ?? 0)")
//                        .font(.caption)
//                        .foregroundColor(.red)
//                        .frame(alignment: .bottomTrailing)
//                        .padding([.bottom, .trailing], 4)
//                        .minimumScaleFactor(0.3)
//
//                }
//            }
        }
        .frame(width: fieldSize - sizeOffset,
               height: fieldSize - sizeOffset)
        
    }
}

extension ZKFieldView {
    
    var noteGridView: some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
            HStack(spacing: 5) {
                Text(field.notes[0] ? "1" : "•")
                Text(field.notes[1] ? "2" : "•")
                Text(field.notes[2] ? "3" : "•")
            }
            .frame(height: fieldSize * 0.1)
            HStack(spacing: 5) {
                Text(field.notes[3] ? "4" : "•")
                Text(field.notes[4] ? "5" : "•")
                Text(field.notes[5] ? "6" : "•")
            }
            .frame(height: fieldSize * 0.1)
            HStack(spacing: 5) {
                Text(field.notes[6] ? "7" : "•")
                Text(field.notes[7] ? "8" : "•")
                Text(field.notes[8] ? "9" : "•")
            }
            .frame(height: fieldSize * 0.1)
            
        }
        .frame(height: fieldSize * 0.5)
        .foregroundColor((gm.selectedField != nil && gm.selectedField == field) ? .white : .purple)
        .font(.system(size: hintFontSize))
        
    }
}

struct ZenKenFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ZKFieldView(
            gridSize: 4,
            fieldSize: 40,
            color: .white,
            field: ZKField(
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
