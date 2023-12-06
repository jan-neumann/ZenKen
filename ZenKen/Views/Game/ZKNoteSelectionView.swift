//
//  ZKNoteSelectionView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 26.06.23.
//

import SwiftUI

struct ZKNoteSelectionView: View {
    
    // MARK: - Public
    
    let portrait: Bool
    let size: Int
    @ObservedObject var field: ZKField
    @Binding var show: Bool
    
    // MARK: - Private
    
    @State private var allNotesOn: Bool = false
    
    // MARK: - Properties
    
    func buttonColor(index: Int) -> Color {
        field.notes[index] ? Color.secondary : Color.blue
    }
    
    // MARK: - Main View
    
    var body: some View {
        VStack {
            if portrait {
                HStack {
                    notesLabel
                    Spacer()
                    Button {
                        show.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 30, height: 30)
                            .background(.white.opacity(0.6))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.plain)
                }
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
        .padding(.top, 5)
        .padding([.horizontal, .bottom], 6)
        .transition(.opacity)
        .background(.backgroundGradient1.gradient) // Color(.systemGray4)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 5)
        .padding(.horizontal, 10)
    }
    
    // MARK: - Sub Views
    
    var notesLabel: some View {
        Label("Notes", systemImage: "square.and.pencil")
            .fontWeight(.semibold)
            .foregroundColor(.white)
    }
    
    var allNotesToggleButton: some View {
        Button {
            allNotesOn.toggle()
            for i in 0 ..< field.notes.count {
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
                .background(toggle ? Color.indigo : Color(.systemGray5))
                .cornerRadius(5)
                .shadow(radius: 5)
        }
    
}

// MARK: - Previews

#Preview {
    @State var field: ZKField = ZKField (
        cageHint: "4096(X)",
        hint: "4096(X)",
        drawLeftBorder: true,
        drawRightBorder: true,
        drawBottomBorder: true,
        drawTopBorder: true
    )
    
    return ZKNoteSelectionView(
        portrait: true,
        size: 9,
        field: field,
        show: .constant(true)
    )
    
}
