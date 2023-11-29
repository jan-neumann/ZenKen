//
//  MainMenuView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 29.11.23.
//

import SwiftUI

struct MainMenuView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to ZenKen!")
                    .font(.largeTitle.bold())
                    
                Spacer()
                ForEach(4..<10) { size in
                    NavigationLink {
                        ZKPuzzleSelectionMenuView(size: size)
                    } label: {
                        Label("\(size) x \(size) Puzzles", systemImage: "play")
                            .frame(height: 50)
                    }
                    
                    .buttonStyle(.bordered)
                    
                    .tint(.blue)
                    .padding(.vertical, 5)
                }
                Spacer()
           
            }
            .padding()
//            .navigationTitle("ZenKen")
            .tint(.blue)

        }
    }
}

#Preview {
    MainMenuView()
}
