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
    private let cageColor: Color = .blue
    private let cageLineWidth: CGFloat = 3
    
    let size: CGFloat
    
    @Binding var field: ZKField
    
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
                .foregroundColor(.white)
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
                        
                        // Generated Value Text
                        Text("\(field.value ?? 0)")
                            .font(.title)
                            .foregroundColor(
                                valuesAreEqual ?
                                .black : .purple)
                    }
                    
                }
            
            // Hint Text
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Text(field.hint ?? "")
                        .bold()
                        .frame(alignment: .topLeading)
                        .foregroundColor(.blue)
                        .padding(5)
                    Spacer()
                }
                Spacer()
                
            }
            
            // Actual solution
            VStack(alignment: .trailing) {
                Spacer()
                HStack(alignment: .bottom) {
                    Spacer()
                    Text("\(field.solution ?? 0)")
                        .foregroundColor(.red)
                        .frame(alignment: .bottomTrailing)
                        .padding(5)
                    
                }
            }
        }
        .frame(width: size, height: size)
        
    }
}

struct ZenKenFieldView_Previews: PreviewProvider {
    static var previews: some View {
        ZKFieldView(
            size: 40,
            field: .constant(ZKField(
                hint: "1(x)",
                value: 1,
                solution: 1,
                drawLeftBorder: true,
                drawRightBorder: true,
                drawBottomBorder: true,
                drawTopBorder: true
            ))
            
        )
    }
}
