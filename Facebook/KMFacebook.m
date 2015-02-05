//
//  KMFacebook.m
//  Facebook
//
//  Created by khaled el morabea on 2/4/15.
//  Copyright (c) 2015 Ibtikar. All rights reserved.
//

#import "KMFacebook.h"

@implementation KMFacebook

+(void)startFacebookWithPermissions:(NSArray*)permissions
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          
                                              [KMFacebook sessionStateChanged:session state:state error:error];
                                      }];
    }
    else
    {
        // is Not LoggedIn
        
        
    }

}

-(void)shareUsingDailogeWithName:(NSString*)name andCaption:(NSString*)caption andDescription:(NSString*)description andPictureURL:(NSString*)pictureURL andshareLink:(NSString*)shareLink
{
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   name, @"name",
                                   caption, @"caption",
                                   description, @"description",
                                   shareLink, @"link",
                                   pictureURL, @"picture",
                                   nil];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
        // Present share dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:paramsDict
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    
}


-(void)shareUsingAPIWithName:(NSString *)name andCaption:(NSString *)caption andDescription:(NSString *)description andPictureURL:(NSString *)pictureURL andshareLink:(NSString *)shareLink
{
    if (FBSession.activeSession.state != FBSessionStateOpen) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_birthday",@"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [KMFacebook sessionStateChanged:session state:state error:error];
                                          
                                          
                                          NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                         name, @"name",
                                                                         caption, @"caption",
                                                                         description, @"description",
                                                                         shareLink, @"link",
                                                                         pictureURL, @"picture",
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

                                      }];
    }
    else
    {
        // is Not LoggedIn
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       name, @"name",
                                       caption, @"caption",
                                       description, @"description",
                                       shareLink, @"link",
                                       pictureURL, @"picture",
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
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
+ (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            NSLog(@"Something went wrong");
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                NSLog(@"Your current session is no longer valid. Please log in again.");
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                NSLog(@"Something went wrong");
                NSLog(@"%@",[NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]]);
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        NSLog(@"User LogOut");
    }
}


- (void)getFacebookData:(NSArray*)permissions
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        // [FBSession.activeSession closeAndClearTokenInformation];
        
        [self requestUserInfo:nil];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [KMFacebook sessionStateChanged:session state:state error:error];
             
             [self requestUserInfo:permissions];
         }];
    }
}

- (void)requestUserInfo:(NSArray*)permissions
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded =permissions;
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // Parse the list of existing permissions and extract them for easier use
                                  NSMutableArray *currentPermissions = [[NSMutableArray alloc] init];
                                  NSArray *returnedPermissions = (NSArray *)[result data];
                                  for (NSDictionary *perm in returnedPermissions) {
                                      if ([[perm objectForKey:@"status"] isEqualToString:@"granted"]) {
                                          [currentPermissions addObject:[perm objectForKey:@"permission"]];
                                      }
                                  }
                                  
                                  // Build the list of requested permissions by starting with the permissions
                                  // needed and then removing any current permissions
                                  NSLog(@"Needed: %@", permissionsNeeded);
                                  NSLog(@"Current: %@", currentPermissions);
                                  
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:permissionsNeeded copyItems:YES];
                                  [requestPermissions removeObjectsInArray:currentPermissions];
                                  
                                  NSLog(@"Asking: %@", requestPermissions);
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"error %@", error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
    
    
    
}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            [self.delegate didGetUserData:YES andResult:result andError:error];
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            [self.delegate didGetUserData:NO andResult:nil andError:error];

        }
    }];
}



@end
