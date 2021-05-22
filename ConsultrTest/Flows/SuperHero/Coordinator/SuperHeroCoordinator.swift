//
//  SuperHeroCoordinator.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 21/05/2021.
//

import Foundation

class SuperHeroCoordinator: Coordinator {
    let router:Routerable
    
    init(router:Routerable) {
        self.router = router
    }
    
    override func start() {
        start(route: .showAsRoot)
    }
}

extension SuperHeroCoordinator {
    enum Route {
        case showAsRoot
        case showDetails(for: Media)
    }
}
