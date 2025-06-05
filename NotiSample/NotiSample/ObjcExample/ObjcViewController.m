//
//  ObjcViewController.m
//  NotiSample
//
//  Created by mobilePartners on 4/15/25.
//

#import "ObjcViewController.h"

@interface ObjcViewController ()

@end

@implementation ObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // -----------------------------------------------------------------------------------------
    // 푸시 토큰 갱신 이벤트를 수신받기 위한 delegate
    // -----------------------------------------------------------------------------------------
    AppBoxNotification.shared.delegate = self;
    // -----------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------------------------------------
    // 푸시 토큰 가져오기
    // -----------------------------------------------------------------------------------------
    NSString *pushToken = [AppBoxNotification.shared getPushToken];
    NSLog(@"getPushToken :: %@", pushToken ?: @"(null)");
    // -----------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------------------------------------
    // 푸시 토큰 저장하기
    // -----------------------------------------------------------------------------------------
    
    if (pushToken != nil) {
        [AppBoxNotification.shared savePushTokenWithToken:pushToken pushYn:true completion:^(AppBoxNotiResultModel *result, NSError *error) {
            if (error != nil) {
                NSLog(@"error :: %@", error);
            } else {
                NSLog(@"success :: %@ pushToken :: %@", result.message, result.token);
            }
        }];
    }
    // -----------------------------------------------------------------------------------------
    
    // -----------------------------------------------------------------------------------------
    // 세그먼트 저장
    // -----------------------------------------------------------------------------------------
    NSDictionary *segmentModel = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"이름", @"name",
                                  @"12", @"age",
                                  nil];
    
    [AppBoxNotification.shared saveSegmentWithSegment:segmentModel completion:^(AppBoxNotiResultModel * _Nullable result, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error :: %@", error);
        } else {
            NSLog(@"success :: %@", result.message);
        }
    }];
    // -----------------------------------------------------------------------------------------
    
}

// -----------------------------------------------------------------------------------------
// 푸시 토큰 갱신 이벤트를 수신받기 위한 delegate
// -----------------------------------------------------------------------------------------
- (void)appBoxPushTokenDidUpdate:(NSString *)token {
    NSLog(@"appBoxPushTokenDidUpdate :: %@", token ?: @"(null)");
}
// -----------------------------------------------------------------------------------------

@end
