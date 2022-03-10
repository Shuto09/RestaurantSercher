//
//  AppDelegate.swift
//  RestaurantSercher
//
//  Created by 渡邊秋斗 on 2022/03/03.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //ユーザの位置情報
    var userLat:Float = 0.0
    var userLng:Float = 0.0
    
    //APIから取得する値
    //検索結果画面
    var searchName:[String] = []
    var searchAccess:[String] = []
    var searchLogo:[String] = []
    //店舗詳細画面
    var retrieveName:[String] = []
    var retrieveAddress:[String] = []
    var retrieveTime:[String] = []
    var retrievePhoto:[String] = []
    var retrieveClose:[String] = []
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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


}
