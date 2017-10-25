//
//  GameViewController.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var game = Game()
    var layout = Layout(colums: 4, rows: 5, insets: UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40), footerHeight: 80)
    var checkingGameStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GameViewController { // MARK: - Game
    
    fileprivate func configureGame() {
        game.startGame()
    }
    
    fileprivate func checkGameStatus() {
        if checkingGameStatus {
            return
        }
        checkingGameStatus = true
        if game.isFinished {
            showPrizeViewController()
        } else {
            checkingGameStatus = false
        }
    }
}

extension GameViewController { // MARK: - Navigation
    
    fileprivate func showPrizeViewController() {
        self.performSegue(withIdentifier: "ShowPrize", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "ShowPrize", let priceViewController = segue.destination as? PrizeViewController {
            priceViewController.mode = game.prize
        }
    }
}

extension GameViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.numberOfCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.ReuseIdentifier, for: indexPath)
        if let cardCell = cell as? CardCollectionViewCell {
            cardCell.configureWithCard(card: game.cardAtIndex(index: indexPath.item))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return game.canSelectCardAtIndex(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let cardCell = cell as? CardCollectionViewCell {
            game.inTurn = true
            let card = game.cardAtIndex(index: indexPath.item)
            cardCell.selectWithCard(card: card, completion: {
                self.game.selectCardAtIndex(index: indexPath.item) { turn, indexA, indexB in
                    collectionView.deselectItem(at: indexPath, animated: false)
                    if let indexA = indexA, let cellA = collectionView.cellForItem(at: IndexPath(item: indexA, section: 0)) as? CardCollectionViewCell {
                        cellA.updateWithTurn(turn: turn, completion: {
                            self.game.inTurn = false
                            self.checkGameStatus()
                        })
                    }
                    if let indexB = indexB, let cellB = collectionView.cellForItem(at: IndexPath(item: indexB, section: 0)) as? CardCollectionViewCell {
                        cellB.updateWithTurn(turn: turn, completion: {
                            self.game.inTurn = false
                            self.checkGameStatus()
                        })
                    }                                        
                }
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return layout.insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return layout.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return layout.footerSize
    }
}
