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
    
    @State var allNotesOn: Bool = false
    
    func buttonColor(index: Int) -> Color {
        field.notes[index] ? Color.secondary : Color.blue
    }
    
    var body: some View {
        VStack {
            if portrait {
                notesLabel
                HStack(spacing: 5) {
                    numbersView
                    allNotesToggleButton
                
                }
            } else {
               
                    VStack(spacing: 3) {
                        notesLabel
                        numbersView
                        allNotesToggleButton
                        
                    }
             
                }
            
        }
        .padding(.horizontal, 10)
        .transition(.opacity)
    }
    
    var notesLabel: some View {
        Label("Notes", systemImage: "square.and.pencil")
            .foregroundColor(.white)
    }
    
    var allNotesToggleButton: some View {
        Button {
            allNotesOn.toggle()
            for i in 0..<field.notes.count {
                field.notes[i] = allNotesOn
            }
        } label: {
            Image(systemName: allNotesOn ? "square.slash" : "checkmark.square")
                .bold()
        }
        .buttonStyle(NoteToggleButtonStyle())
       
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
                .frame(minWidth: 28, maxWidth: 50, minHeight: 28, maxHeight: 50)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.white)
                .background(toggle ? Color.blue : Color.secondary)
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
