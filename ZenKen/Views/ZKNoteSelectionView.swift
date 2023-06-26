//
//  ZKNoteSelectionView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 26.06.23.
//

import SwiftUI

struct ZKNoteSelectionView: View {
    let portrait: Bool
    let size: Int
    @Binding var field: ZKField?
    
    func buttonColor(index: Int) -> Color {
        guard let field = field else { return .primary }
        return field.notes[index] ? Color.secondary : Color.blue
    }
    
    var body: some View {
        VStack {
            Label("Notes", systemImage: "square.and.pencil")
            if portrait {
                HStack(spacing: 5) {
                    numbersView
                }
            } else {
                VStack(spacing: 5) {
                    numbersView
                }
            }
        }
        .padding(10)
        .foregroundColor(.white)
        //.background(.primary)
    }
    
  
    
    var numbersView: some View {
        ForEach(0..<size, id: \.self) { number in
            Button {
                if let field = field,
                   field.notes.count > number {
                    withAnimation {
                        field.notes[number].toggle()
                    }
                   
                }
            } label: {
                Text("\(number + 1)")
                    .font(.caption.bold())
            }
            .buttonStyle(.borderedProminent)
            .tint(buttonColor(index: number))
            .frame(minWidth: 30, minHeight: 30)
        }
    }
}

struct ZKNoteSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZKNoteSelectionView(
            portrait: true,
            size: 9,
            field: .constant(nil))
        ZKNoteSelectionView(
            portrait: false,
            size: 9,
            field: .constant(nil))
        
    }
}
