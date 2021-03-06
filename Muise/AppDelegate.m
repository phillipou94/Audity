//
//  AppDelegate.m
//  Muise
//
//  Created by Phillip Ou on 10/2/14.
//  Copyright (c) 2014 Phillip Ou. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"Lbz6dBlQtPiLeuHbGUi0uRE7HbU7iPYUNBVguoMY"
                  clientKey:@"tJRlQrMQWSud9tajyvPQvUmzoBx5m9YzbkvRizZ5"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFImageView class];
    [self.window makeKeyAndVisible];
    if(![PFUser currentUser]){
        [self presentLoginControllerAnimated:NO];}
    
    
    
    
    
    
    //if user is not logged in
    return YES;
}
-(void) presentLoginControllerAnimated:(BOOL) animated{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
    [self.window.rootViewController presentViewController:loginNavigationController animated:animated completion:nil];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
