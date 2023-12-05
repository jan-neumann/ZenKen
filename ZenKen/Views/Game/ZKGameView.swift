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
    
    @Binding var solved: Bool
    
    // MARK: - Private
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) private var dismiss
    @StateObject private var gameModel: GameModel
    @State private var isPortrait = false
    @State private var fieldChanged = false
    @State private var selectHintMode = false
    
   // MARK: - Init
    
    init(size: Int, seed: Int,solved:  Binding<Bool>) {
        self.size = size
        self.seed = seed
        self._solved = solved
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
                
            // Game grid
            VStack(alignment: .center) {
               
                ZKFieldGridView(gridSize: size,
                                isPortrait: $isPortrait,
                                fieldEditChange: $fieldChanged,
                                hintMode: $selectHintMode)
             
                BannerAdView()
                    .frame(maxHeight: 60)
                  
            }
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
        .onChange(of: fieldChanged) { _ in
            if gameModel.puzzle.allSolved() {
                solved = true
            }
            fieldChanged = false
        
        }
        .onChange(of: scenePhase) { newPhase in
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
        .sheet(isPresented: $solved) {
            VStack {
                ZKPuzzleSolvedView()
                Button {
                    dismiss()
                } label: {
                    Text("OK")
                }
                .frame(width: 160)
                .buttonStyle(.bordered)
                .tint(.blue)
            }
            .interactiveDismissDisabled()
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
            HStack(alignment: .top) {
                // Back button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
               
                
                Spacer()
                
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        // Hint button
                        Button {
                            selectHintMode.toggle()
                        } label: {
                            VStack {
                                Image(systemName: "questionmark.circle")
                                Text("Hint")
                                    .font(.caption)
                            }
                        }
                        .frame(width: 80, height: 80)
                        // Show errors button
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
                
                    
                    // Hint selection message
                    Text("Select a field for a hint.")
                        .bold()
                        .frame(width: 150)
                        .multilineTextAlignment(.center)
                        .opacity(selectHintMode ? 1 : 0)
                }
            }
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal)
           
            
            Spacer()
        }
    }
}

// MARK: - Previews

#Preview {
    ZKGameView(
        size: 9,
        seed: 123,
        solved: .constant(false)
    )
}
