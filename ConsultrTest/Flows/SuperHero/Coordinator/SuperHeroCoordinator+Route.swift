//
//  SuperHeroCoordinator+Route.swift
//  ConsultrTest
//
//  Created by Alexander Bukov on 21/05/2021.
//

import Foundation

extension SuperHeroCoordinator {
    
    func start(route: SuperHeroCoordinator.Route) {
        switch route {
        case .showAsRoot:
            let viewController = SuperHeroViewController.instantiate(storyboardName: "SuperHero")
        
            router.rootController?.viewControllers = [viewController]
        case .showDetails(let media):
            print(media)
            // TODO: Implement Media details
            break
        }
    }

}
