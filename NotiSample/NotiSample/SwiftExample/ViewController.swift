//
//  ViewController.swift
//  NotiSample
//
//  Created by mobilePartners on 3/27/25.
//

import UIKit
import AppBoxNotificationSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------------------------------------------------------------------------------------
        // 푸시 토큰 갱신 이벤트를 수신받기 위한 delegate
        // -----------------------------------------------------------------------------------------
        AppBoxNotification.shared.delegate = self
        // -----------------------------------------------------------------------------------------
        
        // -----------------------------------------------------------------------------------------
        // 푸시 토큰 가져오기
        // -----------------------------------------------------------------------------------------
        let pushToken: String? = AppBoxNotification.shared.getPushToken()
        print("getPushToken :: \(String(describing: pushToken))")
        // -----------------------------------------------------------------------------------------
        
        // -----------------------------------------------------------------------------------------
        // 푸시 토큰 저장하기
        // -----------------------------------------------------------------------------------------
        
        if let pushToken = pushToken {
            AppBoxNotification.shared.savePushToken(token: pushToken, pushYn: true) { result, error in
                if let error = error {
                    print("error :: \(error)")
                } else {
                    print("success :: \(String(describing: result?.message)) pushToken :: \(String(describing: result?.token))")
                }
            }
        }
        // -----------------------------------------------------------------------------------------
    }
}

// -----------------------------------------------------------------------------------------
// 푸시 토큰 갱신 이벤트를 수신받기 위한 delegate
// -----------------------------------------------------------------------------------------
extension ViewController: AppBoxNotificationDelegate {
    func appBoxPushTokenDidUpdate(_ token: String?) {
        if let token = token {
            print("appBoxPushTokenDidUpdate :: \(token)")
        } else {
            print("appBoxPushTokenDidUpdate :: nil")
        }
    }
}
// -----------------------------------------------------------------------------------------
