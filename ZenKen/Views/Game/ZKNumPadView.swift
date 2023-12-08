//
//  ZKNumPadView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 22.06.23.
//

import SwiftUI

struct ZKNumPadView: View {
    
    // MARK: - Public
    
    let portrait: Bool
    @ObservedObject var gameModel: GameModel
    @Binding var show: Bool
    
    // MARK: - Properties
    
    var hint: String {
        guard let hintString = gameModel.selectedField?.cageHint else {
            return ""
        }
        return hintString.replacingOccurrences(of: " ", with: "")
    }
    
    // MARK: - Main View
    
    var body: some View {
        if portrait {
            portraitGrid
        } else {
            landscapeGrid
        }
    }
    
    // MARK: - Sub Views
    
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
        .background(Color.backgroundGradient1.gradient)
        
        .clipShape(.rect(cornerRadius: 10))
        .padding(3)
        .shadow(radius: 2)
        .overlay(alignment: .topTrailing) { ZKCloseButton(show: $show) }
        .frame(
            minWidth: UIDevice.current.userInterfaceIdiom == .pad ? 500 :  300
        )
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
        .background(Color.backgroundGradient1.gradient)
        .padding(5)
        .cornerRadius(20)
        .shadow(radius: 2)
        .overlay(alignment: .topTrailing) { ZKCloseButton(show: $show) }
    }
    
    private var hintText: some View {
        Text("\(hint)")
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 5)
            .background(Color.indigo.gradient)
            .clipShape(.capsule)
            .padding(.top, 5)
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
                if let symbol = symbol {
                    Image(systemName: symbol)
                        .font(.title2.bold())
                        .shadow(radius: 2)
                } else {
                    Text("\(value)")
                        .font(.title.bold())
                        .shadow(radius: 2)
                }
            }
        }
        .buttonStyle(NumberButtonStyle(minWidth: portrait ? 35 : 50, minHeight: portrait ? 35 : 50))
    }
}

fileprivate struct NumberButtonStyle: ButtonStyle {
    
    let minWidth: CGFloat
    let minHeight: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: minWidth,
                       maxWidth: 70,
                       minHeight: minHeight,
                       maxHeight: 70
                )
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.primary)
                .background(.numPadBackground.gradient)
                .cornerRadius(5)
                .shadow(radius: 5)
        }
}

#Preview {
    ZKNumPadView(
        portrait: true,
        gameModel: GameModel(id: "1234"), 
        show: .constant(true)
    )
}
