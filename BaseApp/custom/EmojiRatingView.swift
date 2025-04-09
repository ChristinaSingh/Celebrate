//
//  EmojiRatingView.swift
//  BaseApp
//
//  Created by Ihab yasser on 14/12/2024.
//

import Foundation
import UIKit
import SnapKit

enum EmojiRating: String, CaseIterable {
    case verySad = "☹️"
    case sad = "🙁"
    case neutral = "😐"
    case happy = "🙂"
    case veryHappy = "😁"
    
    func intValue() -> Int {
        switch self {
        case .verySad: return 0
        case .sad: return 1
        case .neutral: return 2
        case .happy: return 3
        case .veryHappy: return 4
        }
    }
}


class EmojiRatingView: UIView {
    
    // MARK: - Properties
    private var buttons: [UIButton] = []
    private var selectedEmoji: EmojiRating?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    var valueDidChanged: ((EmojiRating?) -> Void)?
    
    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        
        for (index, emojiCase) in EmojiRating.allCases.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(emojiCase.rawValue, for: .normal) // Set emoji as button title
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            button.tintColor = .black
            button.backgroundColor = .white
            button.layer.cornerRadius = 24
            button.clipsToBounds = true
            button.tag = index
            button.layer.borderColor = UIColor(red: 0.12, green: 0.1, blue: 0.15, alpha: 0.1).cgColor
            button.layer.borderWidth = 1
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(48)
            }
        }
        
        addSubview(stackView)
        
        // Layout the stack view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        // Reset all buttons
        buttons.forEach { button in
            button.backgroundColor = .white
        }
        
        // Highlight the selected button
        sender.backgroundColor = .accent
        
        // Update the selected emoji
        selectedEmoji = EmojiRating.allCases[sender.tag]
        self.valueDidChanged?(self.selectedEmoji)
    }
    
    // MARK: - Public Getter
    func getSelectedEmoji() -> EmojiRating? {
        return selectedEmoji
    }
}
