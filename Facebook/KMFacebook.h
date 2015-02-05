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


- (void)getFacebookData;
+(void)startFacebookWithPermissions:(NSArray*)permissions;
-(void)shareUsingDailogeWithName:(NSString*)name andCaption:(NSString*)caption andDescription:(NSString*)description andPictureURL:(NSString*)pictureURL andshareLink:(NSString*)shareLink;
-(void)shareUsingAPIWithName:(NSString *)name andCaption:(NSString *)caption andDescription:(NSString *)description andPictureURL:(NSString *)pictureURL andshareLink:(NSString *)shareLink;
-(void)sendingMessageUsingDialogueWithName:(NSString *)name andCaption:(NSString *)caption andDescription:(NSString *)description andPictureURL:(NSString *)pictureURL andshareLink:(NSString *)shareLink;
-(void)shareUsingNativeDialogueWithName:(NSString *)name andCaption:(NSString *)caption andDescription:(NSString *)description andPictureURL:(NSString *)pictureURL andshareLink:(NSString *)shareLink;
-(void)addLikeButtonWithURl:(NSString*)url andPosition:(CGPoint)likePosition toView:(UIView*)superView;

@end
