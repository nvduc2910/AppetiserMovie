//
//  UIImageView+Extension.swift
//  AppetiserMovie
//
//  Created by Duckie N on 2/24/23.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    public func setImageURL(_ url: URL?,
                            placeholder: Placeholder? = nil,
                            radius: CGFloat = 8.0,
                            corners: RectCorner? = nil,
                            backgroundColor: UIColor = .white,
                            retryStrategy: RetryStrategy? = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .accumulated(3)),
                            preferAssets: Bool = false,
                            completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        
        var options: KingfisherOptionsInfo
        
        if let corners = corners {
            let roundProcessor = RoundCornerImageProcessor(cornerRadius: radius,
                                                           roundingCorners: corners,
                                                           backgroundColor: backgroundColor)
            options = getCommonOptions(proccessor: roundProcessor, retryStrategy: retryStrategy)
        } else {
            options = getCommonOptions(proccessor: nil)
        }
        
        guard !preferAssets else {
            if let imageName = url?.absoluteString.components(separatedBy: "/").last,
               let image = UIImage(named: imageName) {
                self.image = image
            } else {
                self.kf.setImage(with: url,
                                 placeholder: placeholder,
                                 options: options,
                                 progressBlock: nil,
                                 completionHandler: completionHandler)
            }
            return
        }
        
        self.kf.setImage(with: url, placeholder: placeholder, completionHandler: completionHandler)
    }
    
    public func getCommonOptions(proccessor: ImageProcessor?,
                                 retryStrategy: RetryStrategy? = nil) -> KingfisherOptionsInfo {
        
        var processors: ImageProcessor = DownsamplingImageProcessor(size: bounds.size)
        if let proccessor = proccessor {
            processors = processors.append(another: proccessor)
        }
        var options: KingfisherOptionsInfo = [.backgroundDecode,
                                              .cacheOriginalImage,
                                              .cacheSerializer(FormatIndicatedCacheSerializer.png),
                                              .scaleFactor(UIScreen.main.scale),
                                              .processor(processors)]
        
        guard let retryStrategy = retryStrategy else { return options }
        options.append(.retryStrategy(retryStrategy))
        return options
    }
}
