//
//  OnboardViewController.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

protocol OnboardFinisherDelegate {
    func finishOnboard()
    func touchIdAuth(isSuccess: @escaping (Bool) -> Void)
}

class OnboardViewController: UIPageViewController {
    
    var onBoardDelegate: OnboardFinisherDelegate?
    
    convenience init(coordinator: OnboardFinisherDelegate) {
        // Init page view controller
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        self.onBoardDelegate = coordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove nav bar
        self.navigationController?.navigationBar.isHidden = true
        
        // Set color behind dots
        view.backgroundColor = UIColor.clear
        
        // Set datasource
        dataSource = self
        
        // Set first view controller
        setViewControllers([getStepOne()], direction: .forward, animated: false, completion: nil)
        
        print("Hi, we're about to onboard you")
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Eliminates white background for nav bar
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = self.view.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    func nextButtonPressed(currentPage: UIViewController) {
        
    }
    
    // Step View Controllers

    func getStepOne() -> UIViewController {
        let one = StepOneVC()
//        one.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: UIControlEvents.allTouchEvents)
        return one
    }
    
    func getStepTwo() -> UIViewController {
        let two = StepTwoVC()
        return two
    }
    
    func getStepThree() -> UIViewController {
        let three = StepThreeVC()
        return three
    }
    
    func getStepFour() -> UIViewController {
        let four = StepFourVC()
        return four
    }
    
    func finishOnboard() {
        print("Finishing onboard")
        
        self.onBoardDelegate?.finishOnboard()
        
//        self.onBoardDelegate?.touchIdAuth() {
//            isAuthed in
//            print("yoo am i authed in the onboardVC?? \(isAuthed)")
//        }
        
        
        
//        // Create user with information
//        let user = User(name: nameEntered, wordsToAvoid: avoidWordsEntered, wordsToUse: useWordsEntered, wordOfTheDay: "eloquence", lastSessionSentiment: 120.0)
//        print("completed an onboarding for:")
//        print(user)
//        
//        // Go back to parent
//        
//        // self.parent is IniitialViewController
//        self.willMove(toParentViewController: self.parent)
//        self.view.removeFromSuperview()
//        self.removeFromParentViewController()
//        
//        // Call container parent view controller
//        onboardDelegate?.onboardDidComplete(user: user)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OnboardViewController : UIPageViewControllerDataSource  {
    
    // Start at first dot when call setViewControllers()
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // 4 dots
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is StepFourVC {
            // 4 -> 3
            return getStepThree()
        } else if viewController is StepThreeVC {
            // 3 -> 2
            return getStepTwo()
        } else if viewController is StepTwoVC {
            // 2 -> 1
            return getStepOne()
        } else {
            // 1 -> end of the road, cant go back!
            return nil
        }
    }
    
    
    // Order of view controllers
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is StepOneVC {
            // 1 -> 2
            return getStepTwo()
        } else if viewController is StepTwoVC {
            // 2 -> 3
            return getStepThree()
        } else if viewController is StepThreeVC {
            // 3 -> 4
            return getStepFour()
        } else {
            // 4 -> end of the road
            finishOnboard()
            return nil
        }
    }
}
