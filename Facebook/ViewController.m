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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
