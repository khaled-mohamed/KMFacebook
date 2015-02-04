//
//  ViewController.m
//  Facebook
//
//  Created by khaled el morabea on 2/4/15.
//  Copyright (c) 2015 Ibtikar. All rights reserved.
//

#import "ViewController.h"
#import "KMFacebook.h"
#import "AppDelegate.h"

@interface ViewController ()<KMFacebookDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)login:(id)sender
{
    KMFacebook *facebook=[[KMFacebook alloc] init];
    [facebook setDelegate:self];
    [facebook getFacebookData:@[@"public_profile", @"user_birthday",@"email"]];
}

-(void)didGetUserData:(BOOL)success andResult:(id)result andError:(NSError *)error
{
    if (success) {
        
        NSLog(@"%@",result);
    }
    else
    {
        NSLog(@"%@",error.description);

    }
}


-(IBAction)share:(id)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing Tutorial", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog(@"result: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"%@", error.description);
                              }
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
