//
//  MediaBackgroundView.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 21/05/2021.
//

import UIKit

class MediaBackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        style()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
    
    private func style() {
        clipsToBounds = true
        layer.cornerRadius = 7
    }
}
