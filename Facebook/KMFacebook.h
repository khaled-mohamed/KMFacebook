//
//  KMFacebook.h
//  Facebook
//
//  Created by khaled el morabea on 2/4/15.
//  Copyright (c) 2015 Ibtikar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
@protocol KMFacebookDelegate <NSObject>
@optional
-(void)didGetUserData:(BOOL)success andResult:(id)result andError:(NSError*)error;
@end
@interface KMFacebook : NSObject
@property (nonatomic,strong) id <KMFacebookDelegate> delegate;
- (void)getFacebookData:(NSArray*)permissions;
+(void)startFacebookWithPermissions:(NSArray*)permissions;
@end