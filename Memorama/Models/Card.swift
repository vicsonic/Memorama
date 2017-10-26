//
//  Card.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

class Card {
    
    var identifier = UUID()
    var image: UIImage
    var found: Bool = false
    var prize: Prize = .None
    
    init(imageName: String) {
        self.image = UIImage(named: imageName)!
        self.prize = Game.prizes[imageName]!
    }
    
    init(card: Card) {
        self.identifier = card.identifier
        self.image = card.image
        self.found = card.found
        self.prize = card.prize
    }
    
}
