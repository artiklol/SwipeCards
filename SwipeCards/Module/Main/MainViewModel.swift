//
//  MainViewModel.swift
//  SwipeCards
//
//  Created by Artem Sulzhenko on 07.01.2024.
//

import UIKit

protocol MainViewModelProtocol {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> CardView
    func emptyView() -> UIView?
}

class MainViewModel: MainViewModelProtocol {
    private var viewModelData = [
        Card(image: "image1", title: "SUSHI", description: "Fresh and delicious sushi is the perfect choice for lovers of Japanese cuisine!"),
        Card(image: "image2", title: "DONUT", description: "Fragrant doughnuts are juicy and sweet - a great morning treat or dessert for tea!"),
        Card(image: "image3", title: "ICE CREAM", description: "Natural ice cream with a variety of flavors - every sip will give you an unforgettable pleasure!")]

    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }

    func card(at index: Int) -> CardView {
        let card = CardView()
        card.dataSource = viewModelData[index]
        return card
    }

    func emptyView() -> UIView? {
        return nil
    }
}
