//
//  ZKGameView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKGameView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    let size = 9
    let seed = 6512473110383760955
    
    @StateObject var gameModel: GameModel = GameModel()
    
    @State private var isPortrait = false
    
    // TODO: hint and error buttons
    var body: some View {
        ZKFieldGridView(gridSize: size,
                        isPortrait: $isPortrait)
        .background(
            LinearGradient(colors: Color.backgroundGradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .statusBarHidden()
        .onAppear {
            gameModel.size = size
            gameModel.setNewProblem(newSeed: seed)
            setOrientation()
        }
        .onReceive(
            NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        ) { _ in
           setOrientation()
        }
        .environmentObject(gameModel)
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                gameModel.save()
                return
            case .inactive:
                return
            case .active:
                gameModel.restore()
                return
            }
        }
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
