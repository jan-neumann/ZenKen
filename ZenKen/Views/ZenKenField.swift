//
//  ZenKenField.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI
import ZKGenerator

struct ZenKenField: View {
    private let cageColor: Color = .blue
    private let cageLineWidth: CGFloat = 3
    
    let hint: String?
    let value: Int?
    let solution: Int?
    let cage: Cage?
    let drawLeft: Bool
    let drawRight: Bool
    let drawTop: Bool
    let drawBottom: Bool
    let size: CGFloat = 80
    
    var valuesAreEqual: Bool {
        if let value = value,
           let solution = solution {
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
                                        drawLeft ? cageLineWidth : 0)
                            Spacer()
                            Rectangle()
                                .foregroundColor(cageColor)
                                .frame(width:
                                        drawRight ? cageLineWidth : 0)
                        }
                        VStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(cageColor)
                                .frame(height:
                                        drawTop ? cageLineWidth : 0)
                            Spacer()
                            Rectangle()
                                .foregroundColor(cageColor)
                                .frame(height:
                                        drawBottom ? cageLineWidth : 0)
                        }
                        
                        // Generated Value Text
                        Text("\(value ?? 0)")
                            .font(.title)
                            .foregroundColor(
                                valuesAreEqual ?
                                .black : .purple)
                    }
                    
                }
            
            // Hint Text
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Text(hint ?? "")
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
                    Text("\(solution ?? 0)")
                        .foregroundColor(.red)
                        .frame(alignment: .bottomTrailing)
                        .padding(5)
                    
                }
            }
        }
        .frame(width: size, height: size)
        
    }
}

struct ZenKenField_Previews: PreviewProvider {
    static var previews: some View {
        ZenKenField(
            hint: "1(x)",
            value: 1,
            solution: 1,
            cage: nil,
            drawLeft: true,
            drawRight: true,
            drawTop: true,
            drawBottom: true
        )
    }
}
