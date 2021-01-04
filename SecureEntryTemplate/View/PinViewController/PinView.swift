//
//  PinView.swift
//  SecureEntryTemplate
//
//  Created by Ацкий Станислав on 01.01.2021.
//

import UIKit

protocol PinViewDelegate: class {
    func numberButtonTapped(_ value: Int)
    func deleteButtonTapped()
    func biometryButtonTapped()
    func exitButtonTapped()
}

final class PinView: UIView {
    
    // MARK: - UI
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private var dotsImageViews: [UIImageView]!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private var numbersButtons: [UIButton]! {
        didSet {
            numbersButtons.indices.forEach {
                numbersButtons[$0].tag = $0
                numbersButtons[$0].addTarget(self,
                                             action: #selector(numberButtonTouchUpInside(_:)),
                                             for: .touchUpInside)
                numbersButtons[$0].addTarget(self,
                                             action: #selector(numberButtonTouchDown(_:)),
                                             for: .touchDown)
                numbersButtons[$0].addTarget(self,
                                             action: #selector(numberButtonTouchUpOutside(_:)),
                                             for: .touchUpOutside)
                numbersButtons[$0].setTitleColor(.white, for: .highlighted)
                numbersButtons[$0].layer.cornerRadius = numbersButtons[$0].bounds.width / 2
            }
        }
    }
    @IBOutlet private weak var exitButton: UIButton! {
        didSet {
            exitButton.addTarget(self, action: #selector(actionExit(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var deleteButton: UIButton! {
        didSet {
            deleteButton.setDeleteButtonAppearence()
            deleteButton.addTarget(self, action: #selector(actionDelete(_:)), for: .touchUpInside)
            deleteButton.isHidden = true
        }
    }
    @IBOutlet private weak var biometryButton: UIButton! {
        didSet {
            biometryButton.addTarget(self, action: #selector(biometryButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Public
    
    weak var delegate: PinViewDelegate?
    
    func setError(_ text: String) {
        errorLabel?.text = text
    }
    
    func setTitle(_ text: String) {
        greetingLabel?.text = text
    }
    
    // MARK: - Private
    
    private var digitCount = 0 {
        didSet {
            biometryButton.isHidden = digitCount > 0
            deleteButton.isHidden = !(digitCount > 0)
            dotsImageViews.forEach { $0.tintColor = Constants.Palette.dotInactiveColor }
            for i in 0..<digitCount {
                dotsImageViews[i].tintColor = Constants.Palette.dotActiveColor
            }
        }
    }
    
    // MARK: - Helpful
    
    private enum CounterBehaviour {
        case increment
        case decrement
    }
    
    private func digitsCounter(_ action: CounterBehaviour) {
        switch action {
        case .increment:
            if digitCount == 4 {
                digitCount = 0
            }
            if digitCount < 4 {
                digitCount += 1
            }
        case .decrement:
            if digitCount > 0 {
                digitCount -= 1
            }
        }
    }
    
    
    // MARK: - Actions
    
    @objc
    private func numberButtonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = Constants.Palette.buttonEnableBackgroundColor
    }
    
    @objc
    private func numberButtonTouchUpOutside(_ sender: UIButton) {
        sender.backgroundColor = .clear
    }
    
    @objc
    private func numberButtonTouchUpInside(_ sender: UIButton) {
        sender.backgroundColor = .clear
        digitsCounter(.increment)
        delegate?.numberButtonTapped(sender.tag)
    }
    
    @objc
    private func actionDelete(_ sender: UIButton) {
        sender.backgroundColor = .clear
        digitsCounter(.decrement)
        delegate?.deleteButtonTapped()
    }
    
    @objc
    private func biometryButtonTapped(_ sender: UIButton) {
        delegate?.biometryButtonTapped()
    }
    
    @objc
    private func actionExit(_ sender: UIButton) {
        delegate?.exitButtonTapped()
    }
    
}
