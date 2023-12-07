//
//  ZKCloseButton.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 07.12.23.
//

import SwiftUI

struct ZKCloseButton: View {
    @Binding var show: Bool
    
    var body: some View {
        Button {
            show.toggle()
        } label: {
            Image(systemName: "xmark")
                .frame(width: 30, height: 30)
                .foregroundColor(.black)
                .background(.white.opacity(0.6))
                .clipShape(.circle)
                .shadow(radius: 2)
                .fontWeight(.bold)
        }
        .buttonStyle(.plain)
        .padding([.top, .trailing], -10)
    }
}

#Preview {
    ZKCloseButton(show: .constant(true))
}
