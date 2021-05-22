//
//  AppCoordinator.swift
//  NotificationsTest
//
//  Created by Alexander Bukov on 09/03/2021.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    let router:Routerable

    init(router: Routerable) {
        self.router = router
    }
    
    override func start() {
        start(route: AppCoordinator.Route.SuperHero.showSuperHero)
    }
}

extension AppCoordinator {
    enum Route {
        case showTabBarAsRoot
        case clear
        case popToRoot
    }
}

extension AppCoordinator.Route {
    enum SuperHero {
        case showSuperHero
    }
}
