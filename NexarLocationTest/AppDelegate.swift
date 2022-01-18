//
//  AppDelegate.swift
//  NexarLocationTest
//
//  Created by Ruslan Ponomarenko on 1/18/22.
//

import UIKit
import Combine


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationPublisher = LocationPublisher()
    var cancellables = [AnyCancellable]()
    var currentFileName: String?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupStuff()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
          
          completionHandler()
      }

    private func setupStuff() {
        
        let namePublisher = NamePublisher(timeInterval: Constants.timeInterval)
        guard let baseInFolder = Constants.baseInternalFolder  else { return }
        let fileManager = INFileManager.init(namePublisher: namePublisher, baseFolder: baseInFolder)
         
        locationPublisher.sink(receiveValue: fileManager.addLogToFile).store(in: &cancellables)

        
    }
    
}

