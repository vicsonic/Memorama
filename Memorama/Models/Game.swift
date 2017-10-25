//
//  Game.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

class Game {
    
    enum Turn {
        case One
        case Two
        case None
    }
    
    static let pairsToFind = 2
    static let maxNumberOfTurns = 3
    
    let images = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    var cards: [Card] = []
    var foundCards: [String] = []
    var currentCardIndex: Int? = nil
    var inTurn: Bool = false
    var numberOfPairsFound: Int = 0
    var numberOfTurns: Int = 0
    var prize: PrizeViewController.Mode = .Textile
    
    func startGame() {
        var cards: [Card] = []
        for image in images {
            let cardA = Card(imageName: image)
            let cardB = Card(card: cardA)
            cards.append(contentsOf: [cardA, cardB])
        }
        cards.shuffle()
        self.cards = cards
    }
    
    var numberOfCards: Int {
        return cards.count
    }

    func cardAtIndex(index: Int) -> Card {
        return cards[index]
    }
    
    func canSelectCardAtIndex(index: Int) -> Bool {
        let card = cardAtIndex(index: index)
        if let currentIndex = currentCardIndex {
            return (currentIndex != index) && !card.found && !inTurn
        } else {
            return !card.found && !inTurn
        }
    }
    
    func selectCardAtIndex(index: Int, completion: (Turn, Int?, Int?)->Void) {
        guard let currentIndex = currentCardIndex else {
            currentCardIndex = index
            completion(.One, index, nil)
            return
        }
        let currentCard = cardAtIndex(index: currentIndex)
        let card = cardAtIndex(index: index)
        if currentCard.identifier.uuidString == card.identifier.uuidString {
            foundCards.append(currentCard.identifier.uuidString)
            currentCard.found = true
            card.found = true
            cards[currentIndex] = currentCard
            cards[index] = card
            numberOfTurns += 1
            numberOfPairsFound += 1
            completion(.Two, currentIndex, index)
            currentCardIndex = nil
        } else {
            numberOfTurns += 1
            completion(.None, currentIndex, index)
            currentCardIndex = nil
        }
    }
    
    var isFinished: Bool {
        return (numberOfTurns == Game.maxNumberOfTurns) || (numberOfPairsFound == Game.pairsToFind)
    }
}
