//
//  ZKNumPadView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 22.06.23.
//

import SwiftUI

struct ZKNumPadView: View {
    let portrait: Bool
    @ObservedObject var gameModel: GameModel
    
    var hint: String {
        guard let hintString = gameModel.selectedField?.cageHint else {
            return ""
        }
        return hintString.replacingOccurrences(of: " ", with: "")
    }
    
    var body: some View {
        if portrait {
            portraitGrid
        } else {
            landscapeGrid
        }
    }
    
    private var portraitGrid: some View {
        HStack(spacing: 0) {
            
            VStack(spacing: 5) {
                
                hintText
                
                Grid(horizontalSpacing: 5, verticalSpacing: 5) {
                    GridRow {
                        ForEach(1 ..< 5, id: \.self) { number in
                            numButton(value: number)
                        }
                        numButton(value: -1, symbol: "delete.left")
                    }
                    GridRow {
                        ForEach(5 ..< 10, id: \.self) { number in
                            if gameModel.size >= number {
                                numButton(value: number)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 6)
          
        }
        .background(Color(.systemGray6).opacity(0.7))
        .clipShape(.rect(cornerRadius: 10))
        .padding(3)
        .shadow(radius: 2)
    }
    
    private var hintText: some View {
        Text("\(hint)")
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(Color.indigo.gradient)
            .clipShape(.capsule)
            .padding(.top, 10)
            .shadow(radius: 2)
    }
    
    private var landscapeGrid: some View {
        VStack(spacing: 5) {
            hintText
            
            Grid(horizontalSpacing: 5, verticalSpacing: 5) {
                GridRow {
                    numButton(value: -1, symbol: "delete.left")
                }
                GridRow {
                    ForEach(1 ..< 4, id: \.self) { number in
                        numButton(value: number)
                    }
                }
                GridRow {
                    ForEach(4 ..< 7, id: \.self) { number in
                        if gameModel.size >= number {
                            numButton(value: number)
                        }
                    }
                }
                if gameModel.size > 6 {
                    GridRow {
                        ForEach(7 ..< 10, id: \.self) { number in
                            if gameModel.size >= number {
                                numButton(value: number)
                            }
                        }
                        
                    }
                }
            }
            .padding(5)
        }
        .background(
            Color(.systemGray6)
                .opacity(0.7)
                .blur(radius: 2)
        )
        .padding(5)
        .cornerRadius(20)
        .shadow(radius: 2)
    }

    private func numButton(value: Int, symbol: String? = nil) -> some View {
        Button {
            withAnimation {
                if value > 0 {
                    gameModel.selectedField?.value = value
                } else {
                    gameModel.selectedField?.value = nil
                }
            }
            gameModel.selectedField = nil
            gameModel.showErrors = false
        } label: {
            HStack(spacing: 0) {
                if symbol != nil {
                    Image(systemName: symbol!)
                        .font(.caption.bold())
                } else {
                    Text("\(value)")
                        .font(.body.bold())
                        .shadow(radius: 2)
                }
            }
        }
      //  .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60)
        .buttonStyle(NumberButtonStyle())
    }
}

struct NumberButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.primary)
                .background(.tertiary)
                .cornerRadius(5)
                .shadow(radius: 5)
        }
}

//struct ZKNumPadView_Previews: PreviewProvider {
//    static var previews: some View {
//        NumPadView(
//            gridSize: 4,
//            selectedField: ZKField()
//        )
//    }
//}
