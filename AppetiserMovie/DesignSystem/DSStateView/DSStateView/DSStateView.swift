//
//  DSStateView.swift
//  Upscale
//
//  Created by Duckie N on 24/11/2021.
//

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import StatefulViewController
import UIKit
import RxOptional

public final class DSErrorStateView: DSStateView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }

    private func configureView() {
        backgroundColor = Colors.primary
        image = Assets.notFound.image
        title = StateConfig.error.title
        message = StateConfig.error.message
        actionTitle = StateConfig.error.actionTitle
    }
}

extension Reactive where Base: DSStateView {

    /// The event when did tap action button
    public var tapAction: ControlEvent<Void> {
        return base.actionButton.rx.tap
    }
}

open class DSStateView: UIView {

    public var imageHeight: CGFloat = 40 {
        didSet {
            self.imageView.snp.updateConstraints { $0.width.height.equalTo(self.imageHeight) }
        }
    }

    /// The image of state view
    ///
    /// The Value is nil
    public var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.isHidden = image == nil
            invalidateIntrinsicContentSize()
        }
    }

    /// The text title of state view
    ///
    /// The Value is nil
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title.orEmpty.isEmpty
            invalidateIntrinsicContentSize()
        }
    }

    /// The text message of state view
    ///
    /// The Value is nil
    public var message: String? {
        didSet {
            messageLabel.text = message
            messageLabel.isHidden = message.orEmpty.isEmpty
            invalidateIntrinsicContentSize()
        }
    }

    /// The text title of button of state view
    ///
    /// The Value is nil
    public var actionTitle: String? {
        didSet {
            actionButton.setTitle(actionTitle, for: .normal)
            actionButton.isHidden = actionTitle.orEmpty.isEmpty
            invalidateIntrinsicContentSize()
        }
    }

    /// The handler did tap action button
    ///
    /// The Value is nil
    public var actionHandler: (() -> Void)?

    /// The padding insets of state view
    ///
    /// The Value is zero
    public var insets: UIEdgeInsets = .zero

    /// The feature set image for state view
    /// - Parameters:
    ///   - URL: The image url of state view
    ///   - placeHolder: The image place holder of state view
    public func setImage(URL: URL?, placeHolder: UIImage?) {
        imageView.kf.setImage(with: URL, placeholder: placeHolder) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                strongSelf.imageView.isHidden = false
                strongSelf.invalidateIntrinsicContentSize()
            default: break
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        configureView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
        configureView()
    }

    override public var intrinsicContentSize: CGSize {
        var height: CGFloat = 0
        if self.imageView.image != nil {
            height += imageHeight
            height += containerStackViewSpacing
        }
        if title.orEmpty.isNotEmpty {
            height += titleLabel.intrinsicContentSize.height
            height += textStackViewSpacing
        }
        if message.orEmpty.isNotEmpty {
            height += messageLabel.intrinsicContentSize.height
            height += containerStackViewSpacing
        }
        if actionTitle.orEmpty.isNotEmpty {
            height += actionButtonHeight
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: height)
    }

    // MARK: - Private

    private lazy var imageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var messageLabel = UILabel()
    fileprivate lazy var actionButton = UIButton()
    private lazy var containerStackView = UIStackView()
    private lazy var textStackView = UIStackView()
}

extension DSStateView {

    private func setUpView() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        let blankView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        blankView.backgroundColor = .clear
        textStackView.addArrangedSubview(blankView)
        textStackView.addArrangedSubview(messageLabel)
        containerStackView.addArrangedSubview(actionButton)
        actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
    }

    private func configureView() {
        backgroundColor = Colors.primary
        constraints
            .filter { $0.firstAttribute == .height }
            .forEach { $0.isActive = false }

        backgroundColor = Colors.primary

        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.distribution = .fill
        containerStackView.spacing = containerStackViewSpacing
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.snp.makeConstraints { maker in
            maker.leading.equalTo(16)
            maker.trailing.equalTo(-16)
            maker.centerY.equalToSuperview()
        }

        imageView.tintColor = Colors.neutral
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { $0.width.height.equalTo(imageHeight) }
        imageView.isHidden = true

        textStackView.axis = .vertical
        textStackView.alignment = .center
        textStackView.distribution = .fill
        textStackView.spacing = textStackViewSpacing

        titleLabel.setStyle(DS.mobileH3(color: Colors.neutral))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.isHidden = true

        messageLabel.setStyle(DS.pDefault(color: Colors.neutral))
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.isHidden = true

        actionButton.setPlainStyle(title: actionTitle.orEmpty)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.snp.makeConstraints { maker in
            maker.width.equalTo(actionButtonWidth)
            maker.height.equalTo(actionButtonHeight)
        }
        actionButton.isHidden = true

        invalidateIntrinsicContentSize()
    }

    @objc
    private func didTapActionButton(_: UIButton) {
        actionHandler?()
    }
}

extension DSStateView: StatefulPlaceholderView {

    public func placeholderViewInsets() -> UIEdgeInsets {
        return insets
    }
}

private let actionButtonWidth: CGFloat = 248
private let actionButtonHeight: CGFloat = 48
private let containerStackViewSpacing: CGFloat = 12
private let textStackViewSpacing: CGFloat = 8
