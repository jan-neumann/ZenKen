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
    private let cageLineWidth: CGFloat = 3
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
                        
//                        TextField("", value: $value, format: .number)
//                            .onChange(of: value, perform: { newValue in
//                                if let newValue = newValue {
//                                    if newValue > 4 {
//                                        value = 4
//                                    }
//                                    if newValue <= 0 {
//                                        value = 1
//                                    }
//                                }
//                            })
//
//                            .font(.title)
//                            .foregroundColor((value != nil && value! == field.solution) ? .black : .red)
//                            .minimumScaleFactor(0.3)
//                            .padding(.top, 3)
//                            .frame(width: fieldSize * 0.25)
//                        // Value Text
                        Text(field.value != nil ? "\(field.value!)" : "")
                            .font(.title)
                            .foregroundColor((field.value != nil && field.value! == field.solution!) ? .black : .red)
                            .shadow(radius: 2)
                            .padding(.top, 5)
                          
                    }
                    
                }
            
            // Hint Text
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Text(field.hint ?? "")
                        .font(.caption2)
                   
                        .frame(alignment: .topLeading)
                        .foregroundColor(Color(.systemBlue))
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
