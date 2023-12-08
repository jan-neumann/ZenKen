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
    let maxWidth: CGFloat
    @Binding var field: ZKField?
    @Binding var show: Bool
    
    // MARK: - Private
    
    @State private var allNotesOn: Bool = false
    
    // MARK: - Properties
    
    func buttonColor(index: Int) -> Color {
        guard let field = field else {
            return .clear
        }
        return field.notes[index] ? Color.secondary : Color.indigo
    }
    
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // MARK: - Main View
    
    var body: some View {
        if let field = field {
            VStack {
                if portrait {
                    VStack {
                        HStack(alignment: .top) {
                            notesLabel
                            Spacer()
                        }
                        HStack(alignment: .bottom, spacing: 5) {
                            numbersView(field: field)
                            allNotesToggleButton(field: field)
                        }
                    }
                    .frame(
                        minWidth: isPad ? 500 :  300,
                        maxWidth: maxWidth
                    )
                    .padding(.horizontal, 5)
                    
                } else { // landscape
                    VStack(spacing: 3) {
                        notesLabel
                        numbersView(field: field)
                        allNotesToggleButton(field: field)
                    }
                    .frame(minHeight: 500)
                }
                
            }
            .padding([.horizontal, .bottom], 15)
            .padding(.top, 5)
            .transition(.opacity)
            .background(Color.backgroundGradient1.gradient)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(radius: 5)
            .overlay(alignment: .topTrailing) { ZKCloseButton(show: $show) }
            .padding(.trailing, 5)
            .onAppear {
                allNotesOn = field.notes.allSatisfy({ $0 == true })
            }
        }
        
    }
    
    // MARK: - Sub Views
    
    var notesLabel: some View {
        Label("Notes", systemImage: "square.and.pencil")
            .fontWeight(.semibold)
            .foregroundStyle(.white)
         
    }
    
    
    func allNotesToggleButton(field: ZKField) -> some View {
        Button {
            allNotesOn.toggle()
            for i in 0 ..< field.notes.count {
                field.notes[i] = allNotesOn
            }
        } label: {
            Image(
                systemName: allNotesOn ?
                "square.slash" :
                    "checkmark.square"
            )
            .bold()
        }
        .buttonStyle(
            NoteToggleButtonStyle(
                field: field,
                noteNumber: -1,
                override: allNotesOn
            )
        )
       
    }
    
    func numbersView(field: ZKField) -> some View {
        ForEach(0 ..< size, id: \.self) { number in
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
            .buttonStyle(
                NoteToggleButtonStyle(
                    field: field,
                    noteNumber: number
                )
            )
        }
    }
}

fileprivate struct NoteToggleButtonStyle: ButtonStyle {
    @ObservedObject var field: ZKField
    let noteNumber: Int
    var override: Bool = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .frame(minWidth: 28, maxWidth: 50, minHeight: 28, maxHeight: 50)
                .aspectRatio(1, contentMode: .fit)
                .background((override || (noteNumber >= 0 && field.notes[noteNumber])) ? Color.fieldSelection.gradient : Color.numPadBackground.gradient)
                .cornerRadius(5)
                .shadow(radius: 5)
        }
    
}

// MARK: - Previews

#Preview {
    @State var field: ZKField? = ZKField (
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
        maxWidth: 300,
        field: $field,
        show: .constant(true)
    )
    
}
