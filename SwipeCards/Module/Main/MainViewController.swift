//
//  ViewController.swift
//  SwipeCards
//
//  Created by Artem Sulzhenko on 06.01.2024.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Properties
    private lazy var stackCards: StackCardsView = {
        let stackView = StackCardsView()
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var buttonArea: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSizeZero
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("START", for: .normal)
        button.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 18)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var viewModel = MainViewModel()


    //MARK: - Override Methods
    override func viewWillLayoutSubviews() {
        if stackCards.checkLastCard() {
            button.setTitle("CLOSE", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubview()
        configureLayout()
        configureButtonArea()
        stackCards.dataSource = viewModel
    }


    //MARK: - Configurations
    private func configureSubview() {
        view.backgroundColor = .white
        [stackCards, buttonArea, button].forEach(view.addSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            stackCards.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            stackCards.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 22),
            stackCards.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22),
            stackCards.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -220),

            buttonArea.heightAnchor.constraint(equalToConstant: 80),
            buttonArea.leftAnchor.constraint(equalTo: view.leftAnchor),
            buttonArea.rightAnchor.constraint(equalTo: view.rightAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            button.topAnchor.constraint(equalTo: buttonArea.topAnchor),
            button.rightAnchor.constraint(equalTo: buttonArea.rightAnchor, constant: -22),
            button.bottomAnchor.constraint(equalTo: buttonArea.bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func configureButtonArea() {
        let gradient = CAGradientLayer()
        let blue = UIColor(red: 255/255, green: 113/255, blue: 38/255, alpha: 1)
        let green = UIColor(red: 245/255, green: 170/255, blue: 93/255, alpha: 1)
        gradient.colors = [blue.cgColor, green.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x : 0, y : 0)
        gradient.endPoint = CGPoint(x : 1, y: 0)
        gradient.frame = view.bounds
        buttonArea.layer.insertSublayer(gradient, at: 0)
    }


    //MARK: - Handlers

    @objc func buttonAction() {

        switch button.currentTitle {
        case "START":
            stackCards.isHidden = false
            buttonArea.layer.sublayers?.remove(at: 0)
            button.setTitle("NEXT", for: .normal)
            button.setTitleColor(.orange, for: .normal)

        case "NEXT":
            stackCards.nextCardButtunAction()
            if stackCards.checkLastCard() {
                button.setTitle("CLOSE", for: .normal)
            }

        case "CLOSE":
            stackCards.resetData()
            configureButtonArea()
            button.setTitle("START", for: .normal)
            button.setTitleColor( .white, for: .normal)
            stackCards.isHidden = true
        default:
            print("Default Case")
        }
    }
}
