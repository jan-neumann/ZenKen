//
//  ZKGameView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKGameView: View {
  
    // MARK: - Public
    
    let size: Int
    let seed: Int
    
    // MARK: - Private
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @StateObject private var gameModel: GameModel
    @State private var isPortrait = false
     
    // MARK: - Init
    
    init(size: Int, seed: Int) {
        self.size = size
        self.seed = seed
        self._gameModel = StateObject<GameModel>(
            wrappedValue:
                GameModel(
                    id: String(seed),
                    size: size,
                    seed: seed
                )
        )
    }
    
    // MARK: - Main View
    
    var body: some View {
        
        ZStack {
            headerView
          
            ZKFieldGridView(gridSize: size,
                            isPortrait: $isPortrait)
        }
        .background(
            LinearGradient(colors: Color.backgroundGradientColors, 
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
        .statusBarHidden()
        .onAppear { initialize() }
        .onDisappear { _ = gameModel.save() }
        .onReceive(
            NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        ) { _ in
            setOrientation()
        }
        .environmentObject(gameModel)
        .onChange(of: scenePhase) { newPhase, _ in
            switch newPhase {
            case .background:
                _ = gameModel.save()
                return
            case .inactive:
                return
            case .active:
                _ = gameModel.restore()
                return
            default:
                return
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func initialize() {
        gameModel.size = size
        gameModel.restoreOrSetNewProblem(newSeed: seed)
        setOrientation()
    }
    
    private func setOrientation() {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene else {
            return
        }
        self.isPortrait = windowScene.interfaceOrientation.isPortrait
    }
}

// MARK: - Sub Views

extension ZKGameView {
    
    private var headerView: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                Spacer()
                // TODO
                HStack {
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "questionmark.circle")
                            Text("Hint")
                                .font(.caption)
                        }
                        
                    }
                    .frame(width: 80, height: 80)
                    
                    Button {
                        gameModel.showErrors = true
                    } label: {
                        VStack {
                            Image(systemName: "exclamationmark.circle")
                            Text("Errors")
                                .font(.caption)
                        }
                        
                    }
                    .frame(width: 80, height: 80)
                }
                
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview {
    ZKGameView(
        size: 4,
        seed: 123
    )
}
