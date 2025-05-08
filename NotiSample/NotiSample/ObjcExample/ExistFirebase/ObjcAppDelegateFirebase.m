//
//  ObjcAppDelegateFirebase.m
//  NotiSample
//
//  Created by mobilePartners on 4/15/25.
//

#import "ObjcAppDelegateFirebase.h"

@interface ObjcAppDelegateFirebase ()

@end

@implementation ObjcAppDelegateFirebase

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // -----------------------------------------------------------------------------------------
    // FirebaseApp 초기화
    // -----------------------------------------------------------------------------------------
    [FIRApp configure];
    // -----------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------------------------------------
    // AppBoxNotification 초기화
    // -----------------------------------------------------------------------------------------
    [AppBoxNotification.shared initSDKWithProjectId:@"YOUR_PROJECT_ID" debugMode:true autoRegisterForAPNS: false completion:^(AppBoxNotiResultModel *result, NSError *error, __unused NSNumber *granted) {
        if (error != nil) {
            NSLog(@"error :: %@", error);
        } else {
            NSLog(@"success :: %@", result.message);
        }
    }];
    // -----------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------------------------------------
    // AppBoxNotification 푸시권한 요청
    // -----------------------------------------------------------------------------------------
    [AppBoxNotification.shared requestPushAuthorizationWithCompletion:^(BOOL granted) {
        if (granted) {
            NSLog(@"권한 허용");
        } else {
            NSLog(@"권한 실패");
        }
    }];
    // -----------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------------------------------------
    // APNS 권한 및 등록
    // -----------------------------------------------------------------------------------------
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    [application registerForRemoteNotifications];
    // -----------------------------------------------------------------------------------------

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // -----------------------------------------------------------------------------------------
    // AppBoxNotification APNS 토큰 등록 및 푸시토큰 저장
    // -----------------------------------------------------------------------------------------
    [AppBoxNotification.shared applicationWithDidRegisterForRemoteNotificationsWithDeviceToken: deviceToken completion:^(AppBoxNotiResultModel *result, NSError *error) {
        if (error != nil) {
            NSLog(@"error :: %@", error);
        } else {
            NSLog(@"success :: %@ pushToken :: %@", result.message, result.token);
        }
    }];
    // -----------------------------------------------------------------------------------------
}

// 알림이 클릭이 되었을 때
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // -----------------------------------------------------------------------------------------
    // AppBoxNotification 클릭 데이터 제공
    // -----------------------------------------------------------------------------------------
    [AppBoxNotification.shared saveNotiClick:response];
    AppBoxNotiModel *notiReceive = [AppBoxNotification.shared receiveNotiModel:response];
    if (notiReceive != nil) {
        NSLog(@"push received :: %@", notiReceive.params);
    }
    // -----------------------------------------------------------------------------------------
    completionHandler();
}

// foreground일 때
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // -----------------------------------------------------------------------------------------
    // AppBoxNotification sound 설정
    // -----------------------------------------------------------------------------------------
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
    // -----------------------------------------------------------------------------------------
}
@end
