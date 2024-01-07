//
//  CardView.swift
//  SwipeCards
//
//  Created by Artem Sulzhenko on 07.01.2024.
//

import UIKit

class CardView: UIView {

    //MARK: - Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    var delegate : StackCardsViewModelProtocol?
    var dataSource : Card? {
        didSet {
            guard let image = dataSource?.image else { return }
            imageView.image = UIImage(named: image)
            titleLabel.text = dataSource?.title
            descriptionLabel.text = dataSource?.description
        }
    }

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)

        configureSubview()
        configureLayout()
        configureLayer()
        configurePanGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Configuration
    private func configureSubview() {
        backgroundColor = .white
        [imageView, descriptionLabel,titleLabel].forEach(addSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -30),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30),

            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    private func configureLayer() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSizeZero
        layer.shadowRadius = 10
        layer.cornerRadius = 5
    }

    private func configurePanGesture() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }

    //MARK: - Handlers
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer){
        guard let card = sender.view as? CardView else { return }
        guard let delegate else { return }
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: frame.width / 2, y: frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x,
                              y: centerOfParentContainer.y + point.y)
        switch sender.state {
        case .ended:
            if !delegate.checkLastCard() {
                if card.center.x < -60 || card.center.x > 400 {
                    delegate.swipeCardAction(on: card)
                    UIView.animate(withDuration: 0.4) {
                        card.alpha = 0
                        self.layoutIfNeeded()
                    }
                    return
                }
            }
            UIView.animate(withDuration: 0.4) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
        default:
            break
        }
    }
}
