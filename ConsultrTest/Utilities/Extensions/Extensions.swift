//
//  Extensions.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation
import UIKit

extension UIViewController {
    class func instantiate<T: UIViewController>(storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

extension UIFont {
    enum OpenSans: String {
        case regular = "OpenSans"
        case italic = "OpenSans-Italic"
        case light = "OpenSans-Light"
        case lightItalic = "OpenSansLight-Italic"
        case semibold = "OpenSans-Semibold"
        case semiboldItalic = "OpenSans-SemiboldItalic"
        case bold = "OpenSans-Bold"
        case boldItalic = "OpenSans-BoldItalic"
        case extrabold = "OpenSans-Extrabold"
        case extraboldItalic = "OpenSans-ExtraboldItalic"
    }
    
    static func openSans(type: UIFont.OpenSans, size: CGFloat) -> UIFont? {
        return UIFont(name: type.rawValue, size: size)
    }
}

extension UIFont {
    static func printAllFonts() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }
}

extension UserDefaults {
    func save<T>(_ value: T, forKey: String) where T: Encodable {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: forKey)
        }
    }
    
    func load<T>(forKey: String) -> T? where T: Decodable {
        guard let data = self.value(forKey: forKey) as? Data,
              let decodedData = try? JSONDecoder().decode(T.self, from: data)
        else { return nil }
        return decodedData
    }
}

extension MutableCollection where Self : RandomAccessCollection {
    mutating func sort(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates: ((Element, Element) -> Bool)...
    ) {
        sort(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for predicate in otherPredicates {
                if predicate(lhs, rhs) { return true }
                if predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}

extension Sequence {
    mutating func sorted(
        by firstPredicate: (Element, Element) -> Bool,
        _ secondPredicate: (Element, Element) -> Bool,
        _ otherPredicates: ((Element, Element) -> Bool)...
    ) -> [Element] {
        return sorted(by:) { lhs, rhs in
            if firstPredicate(lhs, rhs) { return true }
            if firstPredicate(rhs, lhs) { return false }
            if secondPredicate(lhs, rhs) { return true }
            if secondPredicate(rhs, lhs) { return false }
            for predicate in otherPredicates {
                if predicate(lhs, rhs) { return true }
                if predicate(rhs, lhs) { return false }
            }
            return false
        }
    }
}

extension Array {
    
    @discardableResult
    mutating
    func append(elements: [Element]) -> Range<Int> {
        guard !elements.isEmpty else {
            return 0..<0
        }
        let oldCount = self.count
        append(contentsOf: elements)
        return oldCount..<(oldCount + elements.count)
    }
    
    @discardableResult
    mutating
    func append(element: Element) -> IndexSet {
        append(element)
        return IndexSet(integer: self.count - 1)
    }
    
    @discardableResult
    mutating
    func remove(element: Element) -> [IndexSet] where Element: Equatable {
        let indeces = self.indices.filter({ self[$0] == element })
        indeces.forEach { self.remove(at: $0) }
        return indeces.map { IndexSet(integer: $0) }
    }
    
    @discardableResult
    mutating
    func remove(elements: [Element]) -> [IndexSet] where Element: Equatable {
        let indeces = self.indices.filter { elements.contains(self[$0]) }
        indeces.forEach { self.remove(at: $0) }
        return indeces.map { IndexSet(integer: $0) }
    }
}

extension UICollectionView {
    
    public final func dequeueCell<T: UICollectionViewCell>(identifier: String = String(describing: T.self), indexPath: IndexPath, cellType: T.Type = T.self) -> T {
      guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
        fatalError("Failed to dequeue a cell with identifier \(identifier) matching type \(cellType.self). Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand")
      }
      return cell
    }
}

extension UIRefreshControl {
    func beginRefreshingProgrammatically() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}

extension UIImage {
    static func gradientImage(with size: CGSize,
                              startColor: UIColor,
                              endColor: UIColor,
                              startPoint: CGPoint,
                              endPoint: CGPoint) -> UIImage? {
        
        
        let layer = CAGradientLayer()
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layer.colors = [startColor.cgColor, endColor.cgColor]
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
