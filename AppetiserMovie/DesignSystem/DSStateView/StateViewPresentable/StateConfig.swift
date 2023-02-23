//
//  StateConfig.swift
//  Upscale
//
//  Created by Duckie N on 24/11/2021.
//

import UIKit

public struct StateConfig {
    
    public var imageSource: ImageSource?
    public var title: String?
    public var message: String?
    public var actionTitle: String?
    public var insets: UIEdgeInsets
    public var actionHandler: (() -> Void)?
    public var imageHeight: CGFloat?
    
    public init(image: UIImage?,
                title: String? = nil,
                message: String? = nil,
                actionTitle: String? = nil,
                insets: UIEdgeInsets = .zero,
                imageHeight: CGFloat? = nil,
                actionHandler: (() -> Void)? = nil) {
        self.init(imageSource: ImageSource.local(image),
                  title: title,
                  message: message,
                  actionTitle: actionTitle,
                  insets: insets,
                  imageHeight: imageHeight,
                  actionHandler: actionHandler)
    }
    
    public init(imageSource: StateConfig.ImageSource? = nil,
                title: String? = nil,
                message: String? = nil,
                actionTitle: String? = nil,
                insets: UIEdgeInsets = .zero,
                imageHeight: CGFloat? = nil,
                actionHandler: (() -> Void)? = nil) {
        self.imageSource = imageSource
        self.title = title
        self.message = message
        self.imageHeight = imageHeight
        self.actionTitle = actionTitle
        self.insets = insets
        self.actionHandler = actionHandler
    }
}

extension StateConfig {
    
    public var image: UIImage? {
        get {
            if case let .local(localImage) = imageSource {
                return localImage
            }
            return nil
        }
        set {
            imageSource = .local(newValue)
        }
    }
}

public extension StateConfig {
    
    enum ImageSource {
        case local(UIImage?)
        case remote(url: URL, placeholder: UIImage?)
    }
}

// MARK: DSStateView + StateConfig

public extension DSStateView {
    
    func update(with config: StateConfig) {
        if let imageSource = config.imageSource {
            switch imageSource {
            case let .local(image):
                self.image = image
            case let .remote(url, placeholder):
                setImage(URL: url, placeHolder: placeholder)
            }
        }
        title = config.title
        message = config.message
        actionTitle = config.actionTitle
        actionHandler = config.actionHandler
        insets = config.insets
        if let imageHeight = config.imageHeight {
            self.imageHeight = imageHeight
        }
        
    }
}
