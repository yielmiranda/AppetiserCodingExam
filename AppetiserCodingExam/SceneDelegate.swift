//
//  SceneDelegate.swift
//  AppetiserCodingExam
//
//  Created by Marielle on 5/8/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    //MARK: - Properties

    var window: UIWindow?
    
    var lastVisitLocalLoader: LastVisitLocalLoader! //for loading of the user's last visit data
    var lastVisitLocalSaver: LastVisitLocalSaver! //for saving of the user's last visit data
    
    //MARK: - SceneDelegate Life Cycle
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        preloadUserLastVisitData(onScene: windowScene)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        
        saveUserLastVisitData()
    }
    
    //MARK: - Methods
    
    /**
    For loading user's last visit data to identify what screen to show at first loadb
    
    - Parameter windowScene: instance of UIWindowScene to display the last visited screen the app was in, if any
    */
    private func preloadUserLastVisitData(onScene windowScene: UIWindowScene) {
        lastVisitLocalLoader = DefaultLastVisitLocalLoader()
        lastVisitLocalSaver = DefaultLastVisitLocalSaver()
        
        lastVisitLocalLoader.load().subscribe(onNext: { (lastVisits) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! TrackListTableViewController
            
            self.window = UIWindow(windowScene: windowScene)
            self.window!.rootViewController = vc
            self.window!.makeKeyAndVisible()
            
            if let visit = lastVisits.last {
                vc.dateLastVisited = visit.dateLastVisited
                
                if visit.screenLastVisited == "\(TrackDetailsViewController.classForCoder())" {
                    vc.shouldShowTrackDetailsScreen(trackId: visit.trackLastVisited)
                }
            }
        }).dispose()
    }
    
    //For saving of the user's last visit data when the app enters the background state
    private func saveUserLastVisitData() {
        var viewController = window?.rootViewController
        if let presentedViewController = window?.rootViewController?.presentedViewController {
            viewController = presentedViewController
        }
        
        var lastVisit = LastVisit()
        lastVisit.dateLastVisited = NSDate()
        lastVisit.screenLastVisited = "\(viewController!.classForCoder)"
        
        if let trackDetailsVC = viewController as? TrackDetailsViewController {
            lastVisit.trackLastVisited = trackDetailsVC.track.trackId
        }
        
        lastVisitLocalSaver.save(visit: lastVisit).subscribe(onCompleted: {
        }).dispose()
        
        CoreDataManager.saveContext().subscribe(onCompleted: {
        }).dispose()
    }
}

