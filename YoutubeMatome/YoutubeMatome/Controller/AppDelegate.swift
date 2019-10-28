//
//  AppDelegate.swift
//  YoutubeMatome
//
//  Created by 長坂豪士 on 2019/10/27.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // 通知する時間
    let hours = 19
    let minute = 00

    // フラグ
    var notificationGranted = true
    // 最初かどうかのhuragu
    var isFirst = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 許可を促すアラート
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
            if error != nil {
                print("エラーです")
            }
        }
        
        isFirst = false
        setNotification()
        
        return true
    }
    
    func setNotification() {
        
        // 通知時間・条件を初期化
        var notificationTime = DateComponents()
        var trigger:UNNotificationTrigger
        
        // 条件追加
        notificationTime.hour = hours
        notificationTime.minute = minute
        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "19時になりました！"
        content.body = "ニュースが更新されました！"
        content.sound = .default
        
        // 通知スタイル
        let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    // バックグラウンド処理
    func applicationDidEnterBackground(_ application: UIApplication) {
        setNotification()
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

