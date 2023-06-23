//
//  NumPadView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 22.06.23.
//

import SwiftUI

struct NumPadView: View {
    @ObservedObject var gameModel: GameModel
    
    var body: some View {
        HStack {
            Grid {
                GridRow {
                    numButton(value: -1, symbol: "<")
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
        }
        .padding()
        .background(.secondary)
       
    }
    
    private func numButton(value: Int, symbol: String? = nil) -> some View {
        Button {
            if value > 0 {
                gameModel.selectedField?.value = value
            } else {
                gameModel.selectedField?.value = nil
            }
            gameModel.selectedField = nil
        } label: {
            Text((symbol != nil) ? symbol! : "\(value)")
                .font(.title.bold())
        }
        .buttonStyle(.borderedProminent)
    }
}

//struct NumPadView_Previews: PreviewProvider {
//    static var previews: some View {
//        NumPadView(
//            gridSize: 4,
//            selectedField: ZKField()
//        )
//    }
//}
