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
    @ObservedObject var field: ZKField
    
    func buttonColor(index: Int) -> Color {
        //    guard let field = field else { return .primary }
        field.notes[index] ? Color.secondary : Color.blue
    }
    
    var body: some View {
        VStack {
            Label("Notes", systemImage: "square.and.pencil")
            if portrait {
                HStack(spacing: 5) {
                    numbersView
                    allButton
                   // noneButton
                }
            } else {
                VStack(spacing: 5) {
                    numbersView
                    allButton
                  //  noneButton
                }
            }
        }
        .padding(10)
        .foregroundColor(.white)
        //.background(.primary)
    }
    
    var allButton: some View {
        Button {
            for i in 0..<field.notes.count {
                field.notes[i] = true
            }
        } label: {
            Image(systemName: "checkmark.square")
                .font(.caption)
        }
        .buttonStyle(NoteToggleButtonStyle())
        .frame(maxWidth: 30, minHeight: 30)
    }
    
    var noneButton: some View {
        Button {
            for i in 0..<field.notes.count {
                field.notes[i] = false
            }
        } label: {
            Image(systemName: "trash.square")
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: 30, minHeight: 30)
    }
    
    
    var numbersView: some View {
        ForEach(0..<size, id: \.self) { number in
            Button {
                if field.notes.count > number {
                    withAnimation {
                        field.notes[number].toggle()
                    }
                }
            } label: {
                Text("\(number + 1)")
                    .font(.caption.bold())
            }
            .buttonStyle(NoteToggleButtonStyle(toggle: field.notes[number]))
        }
    }
}



struct NoteToggleButtonStyle: ButtonStyle {
    
    var toggle: Bool = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: 30, minHeight: 30)
                .foregroundColor(.white)
                .background(toggle ? Color.secondary : Color.blue)
                .cornerRadius(5)
                .shadow(radius: 5)
        }
    
}

//struct ZKNoteSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZKNoteSelectionView(
//            portrait: true,
//            size: 9,
//            field: .constant(nil))
//        ZKNoteSelectionView(
//            portrait: false,
//            size: 9,
//            field: .constant(nil))
//        
//    }
//}
