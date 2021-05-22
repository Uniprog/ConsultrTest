//
//  EmptyCell.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 21/05/2021.
//

import UIKit

class EmptyCell: UICollectionViewCell {
    
    enum Constants {
        static let Identifier = "EmptyCell"
    }
    
    
    @IBOutlet weak var messageLabel: UILabel!
}
