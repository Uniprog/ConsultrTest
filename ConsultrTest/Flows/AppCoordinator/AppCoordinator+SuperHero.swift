//
//  AppCoordinator+Notifications.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation
import UIKit

extension AppCoordinator {
    
    func start(route: AppCoordinator.Route.SuperHero) {
        switch route {
        case .showSuperHero:
            let coordinator = SuperHeroCoordinator(router: router)
            
            addDependency(coordinator)
            coordinator.start()
        }
    }
}
