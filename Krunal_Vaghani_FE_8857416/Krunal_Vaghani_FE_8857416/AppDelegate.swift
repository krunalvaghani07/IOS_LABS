//
//  AppDelegate.swift
//  Krunal_Vaghani_FE_8857416
//
//  Created by user228677 on 8/8/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //inserting initial data when app launch
        //condition for the not aallowing all the time insert only first time
        if !UserDefaults.standard.bool(forKey: "InitialLocationsInserted") {
            //saving initial data
            insertInitialLocations()
            //set key for location inserted
            UserDefaults.standard.set(true, forKey: "InitialLocationsInserted")
        }
        return true
    }
    func insertInitialLocations() {
        let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let cityList = ["Toronto","Vancouver","Ottawa","Calgary","Winnipeg"]
        let latitudeList = [43.651070,49.246292,45.424721,51.049999,49.895077]
        let longitudeList = [-79.347015,-123.116226,-75.695000,-114.066666,-97.138451]
        let imageUrls = ["https://images.unsplash.com/photo-1517935706615-2717063c2225?ixid=M3w0ODc1MTV8MHwxfHNlYXJjaHwxfHxUb3JvbnRvfGVufDB8fHx8MTY5MTk1MDY1MHww&ixlib=rb-4.0.3","https://images.unsplash.com/photo-1559511260-66a654ae982a?ixid=M3w0ODc1MTV8MHwxfHNlYXJjaHwxfHxWYW5jb3V2ZXJ8ZW58MHx8fHwxNjkxOTUwNzA2fDA&ixlib=rb-4.0.3","https://images.unsplash.com/photo-1613059488547-0fc691db5231?ixid=M3w0ODc1MTV8MHwxfHNlYXJjaHwxfHxPdHRhd2F8ZW58MHx8fHwxNjkxOTUwNzg1fDA&ixlib=rb-4.0.3","https://images.unsplash.com/photo-1526863336296-fac32d550655?ixid=M3w0ODc1MTV8MHwxfHNlYXJjaHwxfHxDYWxnYXJ5fGVufDB8fHx8MTY5MTk1MDgzMXww&ixlib=rb-4.0.3","https://images.unsplash.com/photo-1591658522986-9eb791d2a89a?ixid=M3w0ODc1MTV8MHwxfHNlYXJjaHwxfHx3aW5uaXBlZ3xlbnwwfHx8fDE2OTE5NTA4Njd8MA&ixlib=rb-4.0.3"]
        //inserting 5 canadian cities
        for index in 0...4 {
            let location = Location(context: content)
            location.address = cityList[index]
            location.city = cityList[index]
            location.latitude = latitudeList[index]
            location.longitude = longitudeList[index]
            location.imageUrl = imageUrls[index]
            do{
                try content.save()
            }catch{
                print("Error saving data")
                return
            }
        }
        
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
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Krunal_Vaghani_FE_8857416")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

