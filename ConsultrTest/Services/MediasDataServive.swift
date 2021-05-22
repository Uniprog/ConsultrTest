//
//  MediasDataServive.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 21/05/2021.
//

import Foundation

class MediasDataServive {
    
    private
    let api: APIProtocol
    
    private(set)
    var isReloading = false
    
    private(set)
    var isLoadingMore = false
    
    private(set)
    var isAllLoaded = false

    private(set)
    var medias = [Media]()
    
    init(api: APIProtocol) {
        self.api = api
    }
    
    func loadMedias(completion: @escaping (Result<[Media], Error>) -> Void) {
        isReloading = true
        
        api.loadMedias {[weak self] result in
            switch result {
            case .success(let medias):
                self?.medias = medias
                self?.isReloading = false
                completion(.success(medias))
            case .failure(let error):
                self?.isReloading = false
                completion(.failure(error))
            }
        }
        
    }
    
    // TODO: Fix load more for API with paging
    func loadMore(completion: @escaping (Result<[Media], Error>) -> Void) {
        isLoadingMore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoadingMore = false
            //self.isAllLoaded = true
            completion(.success([]))
        }
    }
}
