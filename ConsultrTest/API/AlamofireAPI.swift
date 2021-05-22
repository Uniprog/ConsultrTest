//
//  AlamofireAPI.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 22/05/2021.
//

import Foundation
import Alamofire

struct AlamofireAPI: APIProtocol {
    
    // TODO: Move API description to separate file and implement injection
    struct APIUrl: APIUrlProtocol {
        
        static let base = "https://dev.consultr.net"
        
        enum Medias {
            static let superHero = "/superhero.json"
        }
        
        let medias = base + Medias.superHero
    }
    
    // Injected on init
    private
    var apiUrl: APIUrlProtocol
    
    init(apiUrl: APIUrlProtocol = APIUrl()) {
        self.apiUrl = apiUrl
        
        // TODO: Configure url session
    }
    
    // TODO: Add pagination parameters
    func loadMedias(completion: @escaping (Result<[Media], Error>) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: apiUrl.medias)!)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        URLCache.shared.removeCachedResponse(for: urlRequest)

        AF.request(urlRequest)
            .responseDecodable(of: [Media].self) { response in
                switch response.result {
                case .success(let medias):
                    completion(.success(medias))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
}
