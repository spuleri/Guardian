//
//  AppCoordinator.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

final class AppCoordinator: Coordinator, OnboardFinisherDelegate {
    
    func start() {
        // TODO: hacky for deving and testing.
        // in future will check if a user is currently signed in
        let doOnboard = true
        
        if doOnboard {
            self.doOnboard()
        } else {
            self.doDash()
        }
    }
    
    private func doOnboard() {
        let vc = OnboardViewController(coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func doDash() {
        let vc = DashViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func finishCurrentVC() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func finishOnboard() {
        finishCurrentVC()
        doDash()
    }
    
    // Coordinator finishers
//    func onboardCoordinatorCompleted(coordinator: OnboardCoordinator) {
//        // do some stuff before releasing if necessary
//        if let index = childCoordinators.index(where: { $0 === coordinator }) {
//            childCoordinators.remove(at: index)
//        }
//    }
//    
//    func dashboardCoordinatorCompleted(coordinator: DashboardCoordinator) {
//        // do some stuff before releasing
//        if let index = childCoordinators.index(where: { $0 === coordinator }) {
//            childCoordinators.remove(at: index)
//        }
//    }
    
}
