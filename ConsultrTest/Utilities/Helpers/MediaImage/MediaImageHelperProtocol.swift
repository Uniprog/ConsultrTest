//
//  MediaImageHelperProtocol.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 22/05/2021.
//

import Foundation
import UIKit

protocol MediaImageHelperProtocol {
    func imageUrl(for size: CGSize, media: Media) -> URL?
    func largestAvailableImageUrl(for media: Media) -> URL?
    
    func gardientImage() -> UIImage?
}
