//
//  AppCoordinator.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation
import LocalAuthentication



final class AppCoordinator: Coordinator, OnboardFinisherDelegate, DashboardNavDelegate {
    
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
    
    // MARK: Navigation
    private func doOnboard() {
        let vc = OnboardViewController(coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func doDash() {
        let viewModel = DashboardViewModel()
        let vc = DashViewController(viewModel: viewModel, navDelegate: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func finishCurrentVC() {
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    // MARK: OnboardFinisherDelegate
    
    func finishOnboard() {
        finishCurrentVC()
        doDash()
    }

    // MARK: DashboardNavDelegate
    func goToSettings() {
        finishCurrentVC()
    }
    
    func goToContacts() {
//        finishCurrentVC()
        
        let vc = ContactsViewController()
        let viewModel = ContactsViewModel(dragDelegate: vc)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func touchIdAuth(isSuccess: @escaping (Bool) -> Void) {
        return authenticateUser(isSuccess: isSuccess)
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
    
    // MARK: Touch ID Auth
    func authenticateUser(isSuccess: @escaping (Bool) -> Void) {
        let context: LAContext = LAContext()
        
        // Setup data
        var error: NSError?
        var localizedReasonStringThatIsntReallyLocalized = "We need to verify your safety via your fingerprint so others cant oretend to be you!"
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReasonStringThatIsntReallyLocalized) {
                (success, error) in
                if success {
                    self.touchIDSuccess()
                    isSuccess(true)
                } else {
                    // Authentification failed
                    print(error!.localizedDescription)
                    
                    isSuccess(false)
//                    switch error as! LAError {
//                        case .systemCancel:
//                            print("Authentication cancelled by the system")
//                        case .userCancel:
//                            print("Authentication cancelled by the user")
//                        case .userFallback:
//                            println("User wants to use a password")
//                            // We show the alert view in the main thread (always update the UI in the main thread)
//                            OperationQueue.main.addOperation {
//                                self.showPasswordAlert()
//                            }
//                        default:
//                            print("Authentication failed")
//                            OperationQueue.main.addOperation {
//                                print("Successfully validated fingerprint!!! YAY")
//                            }
//                    }
                }
            }

        }
        
        return isSuccess(false)

        
    }
    
    private func touchIDSuccess() {
        // Update UI!
        // do so on main queue
        OperationQueue.main.addOperation {
            print("Successfully validated fingerprint!!! YAY")
        }
        
        
    }
    
}
