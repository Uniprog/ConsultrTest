//
//  MockAPI.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 22/05/2021.
//

import Foundation

struct MockAPI: APIProtocol {
    
    func loadMedias(completion: @escaping (Result<[Media], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            completion(.success(mockMedias()))
        }
    }
    
    private
    func mockMedias() -> [Media] {
        let media = Media(id: 1,
                          name: "",
                          slug: "",
                          powerstats: nil,
                          appearance: nil,
                          biography: nil,
                          work: nil,
                          connections: nil,
                          images: nil)
        
        return [media, media, media, media, media, media, media, media, media]
    }
}
