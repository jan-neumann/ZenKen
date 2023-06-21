//
//  ZKGameView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKGameView: View {
    
    let size = 4
    
    @StateObject var gameModel: GameModel = GameModel()
    
    var body: some View {
        ZKFieldGridView(size: size,
                        gameModel: gameModel)
            .onAppear {
                gameModel.size = size
                gameModel.setNewProblem(newSeed: 7355680666289556746)
            }
    }
}

struct ZKGameView_Previews: PreviewProvider {
    static var previews: some View {
        ZKGameView()
    }
}
