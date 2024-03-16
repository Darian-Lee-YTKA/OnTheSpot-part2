//
//  SceneDelegate.swift
//  OnTheSpot
//
//  Created by Darian Lee on 3/9/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let _ = (scene as? UIWindowScene) else { return }

        NotificationCenter.default.addObserver(forName: Notification.Name("login"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.login()
        }

        NotificationCenter.default.addObserver(forName: Notification.Name("logout"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.logOut()
        }
        

        if User.current != nil {
            if User.current!.anwsered == false{
                firstTime()
            }
            else{
                login()
            }
        }
        else{
            logOut()
        }

    }
    private func login() {
        if User.current!.anwsered == false{
            firstTime()
        }
        else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let PostFeedVC = storyboard.instantiateViewController(withIdentifier: "feedVC") as? UIViewController {
                self.window?.rootViewController = PostFeedVC
                print(self.window?.rootViewController)
            }
        }
    }
    private func firstTime() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let firstTimeVC = storyboard.instantiateViewController(withIdentifier: "firstTime") as? UIViewController {
            self.window?.rootViewController = firstTimeVC
            print(self.window?.rootViewController)
        }
    }
    private func logOut() {
        User.logout { [weak self] result in

            switch result {
            case .success:

                // Make sure UI updates are done on main thread when initiated from background thread.
                DispatchQueue.main.async {

                    // Instantiate the storyboard that contains the view controller you want to go to (i.e. destination view controller).
                    let storyboard =  UIStoryboard(name: "Main", bundle: nil)

                    // Instantiate the destination view controller (in our case it's a navigation controller) from the storyboard.
                    if let loginVC = storyboard.instantiateViewController(withIdentifier: "loginFile") as? UIViewController {
                        self?.window?.rootViewController = loginVC
                    }
                }
            case .failure(let error):
                print("❌ Log out error: \(error)")
            }
        }

    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }


}

