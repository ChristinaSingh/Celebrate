//
//  ToastBanner.swift
//  ToolTip
//
//  Created by Ihab yasser on 13/07/2023.
//

import UIKit

@available(iOS 13.0, *)
public protocol BannerTheme {
    var icon : UIImage? {get}
    var backgorundColor:UIColor {get}
    var iconColor:UIColor {get}
    var textColor:UIColor {get}
    var messageFont:UIFont {get}
    var titleFont:UIFont {get}
    var time:Int {get}
    var iconSize:CGFloat {get}
    var style:BannerStyle{ get set }
}
@available(iOS 13.0, *)
public enum BannerStyle{
    case error
    case warning
    case info
    case success
}

@available(iOS 13.0, *)
public enum BannerPosition{
    case Top
    case Bottom
}

@available(iOS 13.0, *)
public struct BannerSettings{
    public var theme:BannerTheme
    var position:BannerPosition = .Bottom
    
    public init(theme: BannerTheme) {
        self.theme = theme
    }
}

@available(iOS 13.0, *)
public class ToastBanner {
    public static let shared = ToastBanner()
    public var settings: BannerSettings?

    private var workItem: DispatchWorkItem?
    private var visibleBanners: [UIView] = [] // Array to track visible banners

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let icon: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    private let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private let titleLbl: LocalizedLable = {
        let lbl = LocalizedLable()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let messageLbl: LocalizedLable = {
        let lbl = LocalizedLable()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        return lbl
    }()

    public func show(title: String = "", message: String, style: BannerStyle, position: BannerPosition) {
        // Dismiss all currently visible banners
        dismissAll()

        guard let window = getWindowView() else { return }

        // Configure settings
        if settings == nil {
            settings = BannerSettings(theme: DefaultBannerStyle())
        }
        settings?.position = position
        settings?.theme.style = style

        // Create a new banner instance
        let banner = design()
        window.addSubview(banner)
        visibleBanners.append(banner)

        // Set constraints for banner position
        banner.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20).isActive = true
        banner.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20).isActive = true
        banner.heightAnchor.constraint(equalToConstant: 70).isActive = true

        if position == .Bottom {
            banner.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 120).isActive = true
        } else {
            banner.topAnchor.constraint(equalTo: window.topAnchor, constant: -120).isActive = true
        }

        // Add swipe gesture for dismissing
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissBanner(_:)))
        swipeGesture.direction = position == .Bottom ? .down : .up
        banner.addGestureRecognizer(swipeGesture)

        // Feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(style == .error ? .error : .success)

        // Animate banner into view
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
            banner.transform = CGAffineTransform(translationX: 0, y: position == .Bottom ? -190 : 190)
        })

        // Schedule automatic dismissal
        workItem = DispatchWorkItem { [weak self] in
            self?.dismiss(banner: banner)
        }
        let time = DispatchTimeInterval.seconds(settings?.theme.time ?? 3)
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: workItem!)

        // Set content
        if title.isEmpty {
            titleLbl.isHidden = true
        }
        if message.isEmpty {
            messageLbl.isHidden = true
        }
        titleLbl.text = title
        messageLbl.text = message
    }

    @objc private func dismissBanner(_ gesture: UISwipeGestureRecognizer) {
        if let banner = gesture.view {
            dismiss(banner: banner)
        }
    }

    public func dismiss(banner: UIView) {
        // Animate and remove the specific banner
        UIView.animate(withDuration: 0.5, animations: {
            banner.transform = CGAffineTransform(translationX: 0, y: self.settings?.position == .Bottom ? 200 : -200)
        }, completion: { _ in
            banner.removeFromSuperview()
            if let index = self.visibleBanners.firstIndex(of: banner) {
                self.visibleBanners.remove(at: index)
            }
        })
    }

    public func dismissAll() {
        for banner in visibleBanners {
            dismiss(banner: banner)
        }
    }

    fileprivate func getWindowView() -> UIView? {
        if var topController = UIApplication.shared.connectedScenes.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] }).last(where: { $0.isKeyWindow })?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController.view
        }
        return nil
    }

    fileprivate func design() -> UIView {
        let view = UIView()
        view.backgroundColor = settings?.theme.backgorundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.addSubview(stack)

        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        stack.addArrangedSubview(iconView)
        iconView.widthAnchor.constraint(equalToConstant: settings?.theme.iconSize ?? 32).isActive = true

        iconView.addSubview(icon)
        icon.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: settings?.theme.iconSize ?? 24).isActive = true
        icon.heightAnchor.constraint(equalToConstant: settings?.theme.iconSize ?? 24).isActive = true

        stack.addArrangedSubview(contentView)
        contentView.addSubview(contentStack)
        contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6).isActive = true
        contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true

        contentStack.addArrangedSubview(titleLbl)
        contentStack.addArrangedSubview(messageLbl)
        titleLbl.heightAnchor.constraint(equalToConstant: 32).isActive = true

        icon.image = settings?.theme.icon?.withRenderingMode(.alwaysTemplate).withTintColor(settings?.theme.iconColor ?? .label)
        icon.tintColor = settings?.theme.iconColor ?? .label
        titleLbl.textColor = settings?.theme.textColor
        titleLbl.font = settings?.theme.titleFont
        messageLbl.textColor = settings?.theme.textColor
        messageLbl.font = settings?.theme.messageFont
        return view
    }
}
class LocalizedLable: C8Label {
    override func layoutSubviews() {
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            textAlignment = .right
        }else{
            textAlignment = .left
        }
    }
}
class DefaultBannerStyle:BannerTheme{
    var style: BannerStyle = .info

    var icon:UIImage?{
        switch style {
        case .error:
            return UIImage(systemName: "wrongwaysign")
        case .warning:
            return UIImage(systemName: "exclamationmark.triangle")
        case .info:
            return UIImage(systemName: "info.circle")
        case .success:
            return UIImage(systemName: "checkmark")
        }
    }

    var color:UIColor{
        switch style {
        case .error:
            return .systemRed
        case .warning:
            return .systemYellow
        case .info:
            return .label
        case .success:
            return .systemGreen
        }
    }

    var backgorundColor: UIColor{
        switch style {
        case .error:
            return .systemGray6
        case .warning:
            return .systemYellow
        case .info:
            return .systemGray6
        case .success:
            return .systemBackground
        }
    }

    var iconColor: UIColor{
        switch style {
        case .error:
            return .black
        case .warning:
            return .white
        case .info:
            return .label
        case .success:
            return .systemGreen
        }
    }

    var textColor: UIColor{
        switch style {
        case .error:
            return .black
        case .warning:
            return .white
        case .info:
            return .black
        case .success:
            return .black
        }
    }

    var messageFont: UIFont = UIFont.systemFont(ofSize: 16)

    var titleFont:  UIFont = UIFont.systemFont(ofSize: 16 , weight: .medium)

    var time: Int = 4

    var iconSize: CGFloat = 32
    
    
}
