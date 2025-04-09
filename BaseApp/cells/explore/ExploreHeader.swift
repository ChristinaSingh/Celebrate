//  ExploreHeader.swift
//  BaseApp
//
//  Created by Ihab yasser on 24/04/2024.
//
import UIKit
import SnapKit

class ExploreHeader: UIView {
    // MARK: - Properties
    /// When set, updates the eventDateBtn's title to the formatted date.
    var selectedDate: Date? {
        didSet {
            guard let date = selectedDate else {
                eventDateBtn.title = "Select Date".localized
                return
            }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            eventDateBtn.title = formatter.string(from: date)
        }
    }

    // MARK: - UI Components
    let eventLocationBtn: C8IconButton = {
        let btn = C8IconButton()
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.icon = UIImage(named: "location")
        btn.title = "Event location".localized
        btn.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 12)
        btn.iconColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        btn.titleColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        btn.iconSize = CGSize(width: 16, height: 16)
        
        // Glass effect
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        blurView.frame = btn.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.9
        btn.insertSubview(blurView, at: 0)
        return btn
    }()

    let eventDateBtn: C8IconButton = {
        let btn = C8IconButton()
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.icon = UIImage(named: "date")
        // Initially show a placeholder; this will update when selectedDate is set.
        btn.title = "Event date".localized
        btn.font = AppFont.shared.font(family: .Inter, fontWeight: .medium, size: 14)
        btn.iconColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        btn.titleColor = UIColor(red: 0.243, green: 0.165, blue: 0.733, alpha: 1)
        btn.iconSize = CGSize(width: 16, height: 16)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        blurView.frame = btn.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.9
        btn.insertSubview(blurView, at: 0)
        return btn
    }()

    let searchBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    // MARK: - Private Views
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            createButtonContainer(button: eventLocationBtn),
            createButtonContainer(button: eventDateBtn)
        ])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()

    private let searchCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 28
        view.layer.borderColor = UIColor(red: 0.122, green: 0.098, blue: 0.149, alpha: 0.1).cgColor
        view.layer.borderWidth = 1

        // Shadow configuration
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        
        return view
    }()

    private let searchLabel: C8Label = {
        let lbl = C8Label()
        lbl.font = AppFont.shared.font(family: .Inter, fontWeight: .regular, size: 14)
        lbl.textColor = .black
        lbl.text = "Search from over 8,000+ products".localized
        lbl.textAlignment = AppLanguage.isArabic() ? .right : .left
        return lbl
    }()

    private let searchIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "home_search")
        icon.contentMode = .scaleAspectFit
        return icon
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        addSubview(buttonStack)
        addSubview(searchCard)
        searchCard.addSubview(searchLabel)
        searchCard.addSubview(searchIcon)
        searchCard.addSubview(searchBtn)
    }

    private func setupConstraints() {
        buttonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalTo(searchCard.snp.top).offset(-16)
        }

        searchCard.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(56)
        }

        searchIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        searchLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(searchIcon.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }

        searchBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Shadow Container Helper
    private func createButtonContainer(button: C8IconButton) -> UIView {
        let container = UIView()
        container.addSubview(button)

        // Shadow configuration
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        container.layer.shadowRadius = 8
        container.layer.cornerRadius = 20

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return container
    }
}
