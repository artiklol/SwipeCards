//
//  StackCardsView.swift
//  SwipeCards
//
//  Created by Artem Sulzhenko on 07.01.2024.
//

import UIKit

protocol StackCardsViewModelProtocol {
    func resetData()
    func swipeCardAction(on view: CardView)
    func nextCardButtunAction()
    func checkLastCard() -> Bool
}

class StackCardsView: UIView, StackCardsViewModelProtocol {
    
    //MARK: - Properties
    private var remainingCards = 0
    private var cardViews = [CardView]()
    private var visibleCards: [CardView] {
        return subviews as? [CardView] ?? []
    }
    var dataSource: MainViewModelProtocol? {
        didSet {
            resetData()
        }
    }

    //MARK: - Private methods

    private func addCardView(cardView: CardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }

    private func addCardFrame(index: Int, cardView: CardView) {
        var cardViewFrame = bounds
        let horizontalInset = CGFloat(index) * 10.0
        let verticalInset = CGFloat(index) * 10.0

        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset

        cardView.frame = cardViewFrame
    }

    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }

    //MARK: - Methods

    func resetData() {
        var numberOfCardsToShow = 0
        let cardsToBeVisible = 3

        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()

        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingCards = numberOfCardsToShow

        for i in 0..<min(numberOfCardsToShow,cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: i), atIndex: i )

        }
    }

    func swipeCardAction(on view: CardView) {
        view.removeFromSuperview()
        cardViews.remove(at: 0)

        for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                cardView.center = self.center
                self.addCardFrame(index: cardIndex, cardView: cardView)
                self.layoutIfNeeded()
            })
        }
    }

    func nextCardButtunAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.cardViews[0].removeFromSuperview()
            self.cardViews.remove(at: 0)
        }

        for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
            let index = cardIndex + 1
            if cardIndex == 0 {
                UIView.animate(withDuration: 0.2) {
                    cardView.center.x *= 3
                    cardView.transform = CGAffineTransform(rotationAngle: .pi / 3)
                    self.layoutIfNeeded()
                }
            }

            if index <= self.visibleCards.count && index > 0 {
                UIView.animate(withDuration: 0.2, delay: 0.2) {
                    self.addCardFrame(index: index-2, cardView: cardView)
                    self.layoutIfNeeded()
                }
            }
        }


    }

    func checkLastCard() -> Bool {
        if visibleCards.count == 1 {
            return true
        } else {
            return false
        }
    }
}
