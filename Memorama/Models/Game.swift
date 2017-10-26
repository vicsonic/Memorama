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
    
    static let pairsToFind = 1
    static let maxNumberOfTurns = 3
    
    let images = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    static let prizes: [String : Prize] = ["A": .Sneakers,
                                           "B": .Sneakers,
                                           "C": .Sneakers,
                                           "D": .Sneakers,
                                           "E": .Sneakers,
                                           "F": .Textile,
                                           "G": .Textile,
                                           "H": .Textile,
                                           "I": .Textile,
                                           "J": .Textile]
    var cards: [Card] = []
    var foundPrizes: [Int] = []
    var currentCardIndex: Int? = nil
    var inTurn: Bool = false
    var numberOfPairsFound: Int = 0
    var numberOfTurns: Int = 0
    var prize: Prize = .None
    
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
            updateFoundPrizesWith(prize: card.prize)
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
    
    private func updateFoundPrizesWith(prize: Prize) {
        foundPrizes.append(prize.rawValue)
        var counts = [Int: Int]()
        foundPrizes.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        if let (priceValue, _) = counts.first(where: { key, value -> Bool in
            return value >= 1
        }), let prize = Prize(rawValue: priceValue) {
            self.prize = prize
        } else {
            self.prize = .None
        }
    }
    
    var isFinished: Bool {
        return (numberOfTurns == Game.maxNumberOfTurns) || (numberOfPairsFound == Game.pairsToFind)
    }
}
