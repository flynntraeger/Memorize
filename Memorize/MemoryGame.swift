//
//  MemoryGame.swift
//  Memorize
//
//  Created by Flynn Traeger on 06/04/2021.
//
// MODEL // used for scoring too

import Foundation

//struct hold_Theme {
//    var themeName: String
//    var themeColor: ColorTheme
//    var themeEmojis: [String]
//    var themeCount: Int
//    
//    enum ColorTheme: String {
//        case red
//        case blue
//        case yellow
//        case green
//        case orange
//        case purple
//    }
//}

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp  = ($0 == newValue) } }
    }
    
    private (set) var score = 0
    
    mutating func choose(_ card: Card) {
//same..if let chosenIndex = cards.firstIndex(where: {aCardInTheCardsArray in aCardInTheCardsArray.id == card.id}) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content { //if cards match
                    cards[chosenIndex].isMatched = true             //registered a match
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 //if match +2 points
                } else {
                    if cards[chosenIndex].picked == false {
                        cards[chosenIndex].picked = true //if card not chosen then show as 'picked'
                    } else {
                        score -= 1  //if card already picked then deduct 1 point
                    }
                    if cards[potentialMatchIndex].picked == false {
                        cards[potentialMatchIndex].picked = true
                    } else {
                        score -= 1
                    }
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        //add numberOfPairsOfCards x 2 cards  to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, picked: false, id: pairIndex*2))
            cards.append(Card(content: content, picked: false, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false  {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched =  false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var picked = false //keep track of whether a card has been picked previously for scoring
        var id: Int
        
        
        // MARK: - Bonus Time

        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up

        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 { //really self.count because code is within Array
            return first
        } else {
            return nil
        }
    }
}

