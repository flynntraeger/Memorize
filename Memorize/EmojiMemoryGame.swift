//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Flynn Traeger on 06/04/2021.
//
// VIEWMODEL  // enables reactive architecture

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    static func createMemoryGame(_ theme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.pairs) { pairIndex in
            theme.emojis[pairIndex]
        }
    }
    
    var currentTheme: Theme
    @Published private var model: MemoryGame<String>
    
    var cards: Array<Card> {
        model.cards
    }
    
    var score: Int { //linking model's scoring system to the view so UI can stay updated
        model.score
    }
    
    init(theme: Theme) { //initialisation needs to select a random theme and createMemoryGame upon startup
        currentTheme = theme
        model = EmojiMemoryGame.createMemoryGame(currentTheme)
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func newGame(theme: Theme) {
        model = EmojiMemoryGame.createMemoryGame(theme)
    }
    
    func shuffle() {
        model.shuffle()
    }
}
