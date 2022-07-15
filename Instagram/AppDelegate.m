//
//  AppDelegate.m
//  Instagram
//
//  Created by Chidi Onyekwelu on 6/27/22.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {

            configuration.applicationId = @"4WQcpoEIMisKNk0ajZoqxHJnwxgJAociu0l9OX14"; // <- UPDATE
            configuration.clientKey = @"zjh6C7KLVRPhUDC8TFzSDhQh4bqsLr1mUvbtLqHO"; // <- UPDATE
            configuration.server = @"https://parseapi.back4app.com";
        }];

    [Parse initializeWithConfiguration:config];

    return YES;
}



#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {

}


@end
