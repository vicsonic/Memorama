//
//  CardCollectionViewCell.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    enum State {
        case Found
        case NotFound
    }
    
    static let ReuseIdentifier = "CardCollectionViewCell"
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var stateView: UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWithCard(card: Card){
        frontImage.image = card.image
        if(card.found){
            backImage.isHidden = true
            frontImage.isHidden = false
        } else {
            backImage.isHidden = false
            frontImage.isHidden = true
        }
    }
    
    func selectWithCard(card: Card, completion: (()->Void)?) {
        configureWithCard(card: card)
        if(!card.found) {
            UIView.transition(from: backImage,
                              to: frontImage,
                              duration: 0.4,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: { _ in
                completion?()
            })
        }
    }
    
    func deselectWith(completion: (()->Void)?) {
        UIView.transition(from: frontImage,
                          to: backImage,
                          duration: 0.4,
                          options: [.transitionFlipFromRight, .showHideTransitionViews],
                          completion: { _ in
            completion?()
        })
    }
    
    func updateWithTurn(turn: Game.Turn, completion: (()->Void)?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            switch turn {
            case .None:
                self.updateState(.NotFound, completion: {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.deselectWith(completion: completion)
                    }
                })
            case .Two:
                self.updateState(.Found, completion: completion)
            case .One:
                completion?()
            }
        }
    }
    
    func updateState(_ state: State, completion: (()->Void)?) {
        let color : UIColor = state == .Found ? .green : .red
        stateView.backgroundColor = color.withAlphaComponent(0.6)
        stateView.layer.opacity = 0
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        animation.duration = 0.2
        CATransaction.commit()
        stateView.layer.add(animation, forKey: "opacity")
    }        
}
