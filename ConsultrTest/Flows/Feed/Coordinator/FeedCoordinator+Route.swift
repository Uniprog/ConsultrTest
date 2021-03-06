//
//  FeedCoordinator+Route.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation

extension FeedCoordinator {
    
    func start(route: FeedCoordinator.Route) {
        switch route {
        case .showAsRoot:
            let viewController: FeedViewController = FeedViewController.instantiate(storyboardName: "Feed")

            router.rootController?.viewControllers = [viewController]
        }
    }

}
