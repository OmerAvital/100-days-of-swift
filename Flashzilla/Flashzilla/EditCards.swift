//
//  EditCards.swift
//  Flashzilla
//
//  Created by Omer Avital on 6/15/22.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cards: Cards
    
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    @FocusState private var promptFocus
    @FocusState private var answerFocus
    
    var trimmedPrompt: String {
        newPrompt.trimmingCharacters(in: .whitespaces)
    }
    
    var trimmedAnswer: String {
        newAnswer.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("Create card") {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Prompt: ")
                            .font(.system(size: 15))
                            .bold()
                        TextField(Card.example.prompt, text: $newPrompt)
                            .focused($promptFocus)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Answer: ")
                            .font(.system(size: 15))
                            .bold()
                        TextField(Card.example.answer, text: $newAnswer)
                            .focused($answerFocus)
                    }
                    
                    Button("Add Card", action: addCard)
                        .disabled(trimmedPrompt.isEmpty || trimmedAnswer.isEmpty)
                }
                
                Section("Cards") {
                    ForEach(cards.all) { card in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Prompt: \(card.prompt)")
                                .font(.headline)
                            
                            Text("Answer: ") + Text(card.answer).italic()
                        }
                    }
                    .onDelete { offsets in
                        cards.delete(atOffsets: offsets)
                    }
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
        }
    }
    
    func done() {
        dismiss()
    }
    
    func addCard() {
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.add(card)
        
        newPrompt = ""
        newAnswer = ""
        
        promptFocus = false
        answerFocus = false
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
            .environmentObject(Cards())
    }
}
