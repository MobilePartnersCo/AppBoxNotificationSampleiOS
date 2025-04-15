//
//  AppDelegate.swift
//  NotiSample
//
//  Created by mobilePartners on 3/27/25.
//

import UIKit
import AppBoxNotificationSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // -----------------------------------------------------------------------------------------
        // AppBoxNotification 초기화
        // -----------------------------------------------------------------------------------------
        AppBoxNotification.shared.initSDK(projectId: "", debugMode: true) { result, error in
            if let error = error {
                print("error :: \(error)")
            } else {
                print("success :: \(String(describing: result?.message))")
            }
            application.registerForRemoteNotifications()
        }
        // -----------------------------------------------------------------------------------------
        
        
        // -----------------------------------------------------------------------------------------
        // APNS 권한 및 등록
        // -----------------------------------------------------------------------------------------
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        // -----------------------------------------------------------------------------------------
     
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // -----------------------------------------------------------------------------------------
        // AppBoxNotification APNS 토큰 등록 및 푸시토큰 저장
        // -----------------------------------------------------------------------------------------
        AppBoxNotification.shared.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) { result, error in
            if let error = error {
                print("error :: \(error)")
            } else {
                print("success:: \(String(describing: result?.message)) pushToken :: \(String(describing: result?.token))")
            }
        }
        // -----------------------------------------------------------------------------------------
    }

}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    //알림이 클릭이 되었을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // -----------------------------------------------------------------------------------------
        // AppBoxNotification 클릭 데이터 제공
        // -----------------------------------------------------------------------------------------
        if let notiReceive = AppBoxNotification.shared.receiveNotiModel(response) {
            print("push received :: \(notiReceive.params)")
        }
        // -----------------------------------------------------------------------------------------
        completionHandler()
    }
    
    // foreground일 때, 알림이 발생
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // -----------------------------------------------------------------------------------------
        // AppBoxNotification sound 설정
        // -----------------------------------------------------------------------------------------
        completionHandler([.badge, .alert, .sound])
        // -----------------------------------------------------------------------------------------
    }
}

