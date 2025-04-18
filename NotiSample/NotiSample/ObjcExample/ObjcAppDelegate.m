//
//  ObjcAppDelegate.m
//  NotiSample
//
//  Created by mobilePartners on 4/15/25.
//

#import "ObjcAppDelegate.h"

@interface ObjcAppDelegate ()

@end

@implementation ObjcAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // -----------------------------------------------------------------------------------------
    // APNS 권한 및 등록
    // -----------------------------------------------------------------------------------------
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    // -----------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------------------------------------
    // AppBoxNotification 초기화
    // -----------------------------------------------------------------------------------------
    [AppBoxNotification.shared initSDKWithProjectId:@"YOUR_PROJECT_ID" debugMode:true completion:^(AppBoxNotiResultModel *result, NSError *error, NSNumber *granted) {
        if (error != nil) {
            NSLog(@"error :: %@", error);
        } else {
            NSLog(@"success :: %@", result.message);
        }
        
        if (granted != nil) {
            if (![granted boolValue]) {
                NSLog(@"권한 미허용");
            }
        }
    }];
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
