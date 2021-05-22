//
//  SuperHeroViewController.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 21/05/2021.
//

import UIKit
import SDWebImage
import Reachability

class SuperHeroViewController: UIViewController {
    
    enum Constants {
        static let title = "Superhero App" // TODO: Add localization
        static let emptyMessage = "No Media" // TODO: Add localization
        
        static let height = "Height" // TODO: Add localization
        static let weight = "Weight" // TODO: Add localization

        // Medias settings
        static let numberOfColums = 2
        static let imageAspectRatio = 4.0 / 3.0
        static let insetForMediaSection = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        static let minimumLineSpacing = 12
        static let minimumInteritemSpacing = 12
        
        // Load more settings
        static let loadMoreCellHeight = 44
        
        // Loading spinner delay
        static let showSpinnerDelay = 2
    }
    
    @IBOutlet  var mediaCollectionView: UICollectionView!
    
    lazy private(set)
    var collectionDataProvider: CollectionDataProvider<Media> = {
        let dataProvider = CollectionDataProvider<Media>()
        dataProvider.collectionView = mediaCollectionView
        return dataProvider
    }()
    
    // TODO: Inject API and Service
    private lazy
    var mediaDataService: MediasDataServive = {
        let api = AlamofireAPI()
        let service = MediasDataServive(api: api)
        return service
    }()
    
    // TODO: Inject Image Helper
    private(set) lazy
    var mediaImageHelper: MediaImageHelperProtocol = {
        return MediaImageHelper()
    }()
    
    private lazy
    var refreshControl: UIRefreshControl = {
       let control = UIRefreshControl()
        control.addTarget(self, action: #selector(onRefreshAction(_:)), for: .valueChanged)
        return control
    }()
    
    // Temporary solution. Should be moved to sepatate file/service
    private
    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    // For iPad orientation chage
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mediaCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private
    func setup() {
        // Title
        let attributes: [NSAttributedString.Key : Any]
            = [NSAttributedString.Key.font: UIFont.openSans(type: .regular, size: 14) as Any]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        title = Constants.title
        
        // Temporary solution. Should be moved to sepatate file/service
        configureReachability()
        
        // Refresh control
        mediaCollectionView.refreshControl = refreshControl
                
        loadMessages(withSpinner: true)
    }
    
    private
    func scheduleSpinner() {
        // Show spinner if first request takes too long
        DispatchQueue
            .main
            .asyncAfter(deadline: .now() + Double(Constants.showSpinnerDelay)) { [weak self] in
                guard let self = self else {
                    return
                }
                if self.mediaDataService.isReloading {
                    self.refreshControl.beginRefreshingProgrammatically()
                }
            }
    }
    
    private
    func loadMessages(withSpinner: Bool = false) {
        
        if withSpinner {
            scheduleSpinner()
        }
        
        mediaDataService.loadMedias { [weak self] result in
            switch result {
            case .success(let medias):
                if medias.isEmpty {
                    self?.collectionDataProvider.showEmpty(message: Constants.emptyMessage)
                } else {
                    self?.collectionDataProvider.reloadItems(items: medias)
                }
            case .failure(let error):
                // TODO: Hanle error better to show user friendly message
                self?.collectionDataProvider.showEmpty(message: error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    private
    func loadMoreMessages() {
        collectionDataProvider.showLoadMore()
        
        mediaDataService.loadMore { [weak self] result in
            switch result {
            case .success(let medias):
                self?.collectionDataProvider.append(models: medias,
                                                    animated: true,
                                                    completion: {
                    self?.collectionDataProvider.hideLoadMore()
                })
            case .failure(_):
                // TODO: Show error
                self?.collectionDataProvider.hideLoadMore()
            }
        }
    }
    
    func checkNextPage(for indexPath: IndexPath) {
        guard !mediaDataService.isReloading,
              !mediaDataService.isLoadingMore,
              !mediaDataService.isAllLoaded,
              indexPath.item == mediaDataService.medias.count - 1 else {
            return
        }
        
        DispatchQueue.main.async {
            self.loadMoreMessages()
        }
    }
    
    @objc private
    func onRefreshAction(_ sender: UIRefreshControl) {
        loadMessages()
    }
}


extension SuperHeroViewController {
    // Temporary solution. Should be moved to sepatate file/service
    private
    func configureReachability() {
        do {
            reachability = try Reachability()
            
            reachability?.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                if !self.mediaDataService.isReloading {
                    self.loadMessages()
                }
            }
            
            reachability?.whenUnreachable = { _ in
                print("Not reachable")
            }
            
            try reachability?.startNotifier()
            
        } catch {
            
        }
    }
}

