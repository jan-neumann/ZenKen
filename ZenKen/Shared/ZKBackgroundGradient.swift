//
//  ZKBackgroundGradient.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 08.12.23.
//

import SwiftUI

struct ZKBackgroundGradient: View {
    var body: some View {
        LinearGradient(colors: Color.backgroundGradientColors,
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ZKBackgroundGradient()
}
