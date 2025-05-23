//
//  AppDelegate.swift
//  NotiSample
//
//  Created by mobilePartners on 4/15/25.
//

import UIKit
import AppBoxNotificationSDK
import Firebase

class AppDelegateFirebase: UIResponder, UIApplicationDelegate  {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // -----------------------------------------------------------------------------------------
        // FirebaseApp 초기화
        // -----------------------------------------------------------------------------------------
        FirebaseApp.configure()
        // -----------------------------------------------------------------------------------------
        
        // -----------------------------------------------------------------------------------------
        // AppBoxNotification 초기화
        // -----------------------------------------------------------------------------------------
        AppBoxNotification.shared.initSDK(projectId: "YOUR_PROJECT_ID", debugMode: true, autoRegisterForAPNS: false) { result, error, granted in
            if let error = error {
                print("error :: \(error)")
            } else {
                print("success:: \(String(describing: result?.message))")
            }
        }
        // -----------------------------------------------------------------------------------------
        
        // -----------------------------------------------------------------------------------------
        // AppBoxNotification 푸시권한 요청
        // -----------------------------------------------------------------------------------------
        AppBoxNotification.shared.requestPushAuthorization { granted in
            if granted {
                print("권한 허용")
            } else {
                print("권한 실패")
            }
        }
        // -----------------------------------------------------------------------------------------
        
        // -----------------------------------------------------------------------------------------
        // APNS 권한 및 등록
        // -----------------------------------------------------------------------------------------
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        // -----------------------------------------------------------------------------------------
        
        
        return true
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
extension AppDelegateFirebase: UNUserNotificationCenterDelegate {
    //알림이 클릭이 되었을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // -----------------------------------------------------------------------------------------
        // AppBoxNotification 클릭 데이터 제공
        // -----------------------------------------------------------------------------------------
        AppBoxNotification.shared.saveNotiClick(response)
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
