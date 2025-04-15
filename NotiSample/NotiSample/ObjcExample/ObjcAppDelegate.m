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
    // AppBoxNotification 초기화
    // -----------------------------------------------------------------------------------------
    [AppBoxNotification.shared initSDKWithProjectId:@"" debugMode:true completion:^(AppBoxNotiResultModel *result, NSError *error) {
        if (error != nil) {
            NSLog(@"error :: %@", error);
        } else {
            NSLog(@"success :: %@", result.message);
        }
        
        [application registerForRemoteNotifications];
    }];
    // -----------------------------------------------------------------------------------------
    
    
    // -----------------------------------------------------------------------------------------
    // APNS 권한 및 등록 
    // -----------------------------------------------------------------------------------------
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter]
        requestAuthorizationWithOptions:authOptions
        completionHandler:^(BOOL granted, NSError * _Nullable error) {
          
        }
    ];
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
