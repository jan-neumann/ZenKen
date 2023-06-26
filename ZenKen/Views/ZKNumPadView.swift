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
    
    var body: some View {
        if portrait {
            portraitGrid
        } else {
            landscapeGrid
        }
    }
    
    private var portraitGrid: some View {
        Grid(horizontalSpacing: 5) {
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
        .padding(10)
    //    .background(.secondary)
    }
    
    private var landscapeGrid: some View {
        Grid(horizontalSpacing: 5) {
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
        .padding(10)
       // .background(.secondary)
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
        .frame(width: 40, height: 40)
        .buttonStyle(.bordered)
       
      //  .shadow(radius: 2)

        //.tint(.blue)
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
