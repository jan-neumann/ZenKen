//
//  ZKGameView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 21.06.23.
//

import SwiftUI

struct ZKGameView: View {
    
    @StateObject var seedFinder: SeedFinder = SeedFinder()
    
    var body: some View {
       ZenKenGrid(seedfinder: seedFinder)
            .onAppear {
                seedFinder.size = 4
                seedFinder.seed = 7355680666289556746
                seedFinder.setNewProblem()
            }
    }
}

struct ZKGameView_Previews: PreviewProvider {
    static var previews: some View {
        ZKGameView()
    }
}
