//
//  AppCoordinator.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation
import LocalAuthentication
import UserNotifications



final class AppCoordinator: Coordinator, OnboardFinisherDelegate, DashboardNavDelegate {
    
    // hacky lol
    var dashViewModel: DashboardViewModel? = nil
    
    func start() {
        // TODO: hacky for deving and testing.
        // in future will check if a user is currently signed in
        let doOnboard = true
        
        
        
        if doOnboard {
            self.doOnboard()
        }
//        } else {
//            self.doDash()
//        }
    }
    
    // MARK: Navigation
    func doOnboard() {
        let vc = OnboardViewController(coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func doDash() {
        dashViewModel = DashboardViewModel()
        let vc = DashViewController(viewModel: dashViewModel!, navDelegate: self)
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
        let vc = SettingsViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToContacts() {
        let vc = ContactsViewController()
        let viewModel = ContactsViewModel(dragDelegate: vc)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func touchIdAuth(isSuccess: @escaping (Bool) -> Void) {
        return authenticateUser(noteToRemove: nil, isSuccess: isSuccess)
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
    func authenticateUser(noteToRemove: String?, isSuccess: @escaping (Bool) -> Void) {
        let context: LAContext = LAContext()
        
        // Setup data
        var error: NSError?
        let localizedReasonStringThatIsntReallyLocalized = "Verify your safety via your fingerprint please"
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReasonStringThatIsntReallyLocalized) {
                (success, error) in
                // sry mom this is way too hacky and messy, but i have limited time
                if success {
                    self.touchIDSuccess(noteToRemove: noteToRemove, sucess: success)
                    return
                } else {
                    // Authentification failed
                    print(error!.localizedDescription)
                    self.touchIDSuccess(noteToRemove: noteToRemove, sucess: success)
                    isSuccess(false)

                }
            }
            
            return isSuccess(false)

        }
        
        return isSuccess(false)

        
    }
    
    private func touchIDSuccess(noteToRemove: String?, sucess: Bool) {
        // Update UI!
        // do so on main queue
        OperationQueue.main.addOperation {
            print("Successfully validated fingerprint!!! YAY")
            self.presentAuthAlert(isAuthed: sucess)
            
            if let noteTitle = noteToRemove {
                // Remove from the data source
                _ = self.dashViewModel?.removeEventByTitle(title: noteTitle)
            }
        }
        
    }
    
    func presentAuthAlert(isAuthed: Bool) {
        var msg = "This is not the correct fingerprint. Please contact the owner."
        if isAuthed {
            msg = "Thanks for checking in and letting your loved ones know that you're safe"
        }
        let alertController = UIAlertController(title: "Check In", message: msg, preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(OkAction)
        
        self.navigationController?.visibleViewController?.present(alertController, animated: true, completion: nil)
    }
    
}


extension AppCoordinator: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
        print("presented notification")
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Determine the user action
        switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
                print("Dismiss Action")
            case UNNotificationDefaultActionIdentifier:
                print("Default - tapped notifiation and opened app!!")
                let title = response.notification.request.identifier
                self.authenticateUser(noteToRemove: title, isSuccess: {_ in })
            
            case "Snooze":
                print("Snooze")
            case "Delete":
                print("Delete")
            default:
                print("Unknown action")
        }
        completionHandler()
    }
}

