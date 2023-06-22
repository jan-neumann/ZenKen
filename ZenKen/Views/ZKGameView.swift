//
//  ZKGameView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKGameView: View {
    
    let size = 9
    
    @StateObject var gameModel: GameModel = GameModel()
    
    @State private var isPortrait = false
    
    var body: some View {
        ZKFieldGridView(gridSize: size,
                        isPortrait: $isPortrait)
        .onAppear {
            gameModel.size = size
            gameModel.setNewProblem(newSeed: 6512473110383760955)
            setOrientation()
        }
        .onReceive(
            NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        ) { _ in
           setOrientation()
        }
        .environmentObject(gameModel)
    }
    
    private func setOrientation() {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene else {
            return
        }
        self.isPortrait = windowScene.interfaceOrientation.isPortrait
    }
}

// MARK: - Previews
struct ZKGameView_Previews: PreviewProvider {
    static var previews: some View {
        ZKGameView()
    }
}
