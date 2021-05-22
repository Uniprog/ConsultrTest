//
//  CollectionDataProvider.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 21/05/2021.
//

import Foundation
import UIKit

class CollectionDataProvider<Element> {
    
    enum Section<Element>: Equatable {
        
        case items([Element] = [])
        case loadMore
        case empty(String?)
        
        static func == (lhs: Section<Element>, rhs: Section<Element>) -> Bool {
            switch (lhs, rhs) {
            case (.items(_), .items(_)), (.loadMore, .loadMore), (.empty, .empty): return true
            default: return false
            }
        }
    }
    
    private(set)
    var sections = [Section<Element>]()
    
    var collectionView: UICollectionView? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    open
    func reloadItems(items: [Element]) {
        sections = [.items(items)]
        collectionView?.reloadData()
        collectionView?.isScrollEnabled = true
    }
    
    func append(models: [Element], animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let index = sections.firstIndex(of: .items()),
              case .items(var items) = sections[index] else {
            completion?()
            return
        }
        guard let collectionView = collectionView else {
            sections.remove(at: index)
            sections.insert(.items(items + models), at: index)
            completion?()
            return
        }
        
        if animated {
            collectionView.performBatchUpdates {
                
                let range = items.append(elements: models)
                sections.remove(at: index)
                sections.insert(.items(items), at: index)
                let indexPaths = range.map { IndexPath(item: $0, section: index) }
                collectionView.insertItems(at: indexPaths)
                
            } completion: { (finished) in
                completion?()
            }
        } else {
            items.append(elements: models)
            sections.remove(at: index)
            sections.insert(.items(items), at: index)
            collectionView.reloadData()
            completion?()
        }
    }
    
    func showLoadMore(animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let collectionView = collectionView else {
            if !sections.contains(.loadMore) {
                sections.append(element: .loadMore)
            }
            completion?()
            return
        }
        
        if animated {
            collectionView.performBatchUpdates {
                if !sections.contains(.loadMore) {
                    let indexSet = sections.append(element: .loadMore)
                    collectionView.insertSections(indexSet)
                }
            } completion: { (finished) in
                completion?()
            }
        } else {
            if !sections.contains(.loadMore) {
                sections.append(element: .loadMore)
                collectionView.reloadData()
            }
            completion?()
        }
    }
    
    func hideLoadMore(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let collectionView = collectionView else {
            sections.remove(element: .loadMore)
            completion?()
            return
        }
        
        if animated {
            collectionView.performBatchUpdates {
                let indexSets = sections.remove(element: .loadMore)
                indexSets.forEach { collectionView.deleteSections($0) }
            } completion: { (finished) in
                completion?()
            }
        } else {
            sections.remove(element: .loadMore)
            collectionView.reloadData()
            completion?()
        }
    }
    
    open
    func showEmpty(message: String?) {
        sections = [.empty(message)]
        collectionView?.reloadData()
        collectionView?.setNeedsLayout()
        collectionView?.layoutIfNeeded()
        collectionView?.isScrollEnabled = false
    }
}
