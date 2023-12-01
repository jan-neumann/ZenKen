//
//  ZKPuzzleSolvedView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 01.12.23.
//

import SwiftUI

struct ZKPuzzleSolvedView: View {
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "trophy.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(.yellow)
                .shadow(color: .orange, radius: 1)
            
            Text("Congratulations!")
                .font(.title)
            Text("Well done. You've solved the puzzle.")
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 60)
        .background(.quinary)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ZKPuzzleSolvedView()
}
