//
//  MediaImageHelper.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 22/05/2021.
//

import Foundation
import UIKit

class MediaImageHelper: MediaImageHelperProtocol {
    
    func imageUrl(for size: CGSize, media: Media) -> URL? {
        let scale = CGFloat(3)
        let md = CGFloat(960 / scale)
        let sm = CGFloat(480 / scale)
        let xs = CGFloat(96 / scale)
        
        switch size.height {
        case ..<xs      where (media.images?.xs != nil):
            return URL(string: media.images!.xs!)
        case xs..<sm    where (media.images?.sm != nil):
            return URL(string: media.images!.sm!)
        case sm..<md    where (media.images?.md != nil):
            return URL(string: media.images!.md!)
        case md...      where (media.images?.lg != nil):
            return URL(string: media.images!.lg!)
        default:
            return largestAvailableImageUrl(for: media)
        }
    }
    
    func largestAvailableImageUrl(for media: Media) -> URL? {
        guard let images = media.images else {
            return nil
        }
        if let urlString = images.lg, // 960x1280
           let url = URL(string: urlString) {
            return url
        }
        else if let urlString = images.md, // 640x960
                let url = URL(string: urlString) {
            return url
        }
        else if let urlString = images.sm, // 320x480
                let url = URL(string: urlString) {
            return url
        }
        else if let urlString = images.xs, // 64x96
                let url = URL(string: urlString) {
            return url
        }
        
        return nil
    }
    
    private lazy
    var gradientImage: UIImage? = {
        let image = UIImage.gradientImage(with: CGSize(width: 200, height: 300),
                                          startColor: UIColor(white: 0.9, alpha: 0),
                                          endColor: UIColor(white: 0, alpha: 0.8),
                                          startPoint: CGPoint(x: 0, y: 0),
                                          endPoint: CGPoint(x: 0, y: 1))
        return image
    }()
    
    func gardientImage() -> UIImage? {
        return gradientImage
    }
}
