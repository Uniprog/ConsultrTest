//
//  API.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 21/05/2021.
//

import Foundation

protocol APIProtocol {
    // TODO: Add pagination parameters
    func loadMedias(completion: @escaping (Result<[Media], Error>) -> Void)
}

protocol APIUrlProtocol {
    var medias: String { get }
}


