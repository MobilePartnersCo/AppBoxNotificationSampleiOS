//
//  ObjcAppDelegateFirebase.h
//  NotiSample
//
//  Created by mobilePartners on 4/15/25.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@import AppBoxNotificationSDK;
@import Firebase;

@interface ObjcAppDelegateFirebase : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@end
