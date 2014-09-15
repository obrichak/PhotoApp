#import "ParseManager.h"
#import "AlertManager.h"
#import "Constants.h"

static ParseManager* sharedManagerInstance = nil;

@implementation ParseManager

@synthesize delegate;

+(ParseManager *) getInstance
{
    if (!sharedManagerInstance)
    {
        sharedManagerInstance = [[ParseManager alloc] init];
    }
    return sharedManagerInstance;
}

-(id) init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void) uploadImage:(UIImage *)image
{
    
    [alertManager showWaitIndicator];
    
    NSData *data = UIImageJPEGRepresentation(image, 0);
    
    if ([data length] > 10485760)
    {
        data = UIImageJPEGRepresentation(image, 0.5);
        if ([data length] > 10485760)
        {
            data = UIImageJPEGRepresentation(image, 1);
        }
    }

    PFFile *file = [PFFile fileWithName:@"userimage.png" data:data];
    
    PFObject *userImage = [PFObject objectWithClassName:@"UserImage"];
    userImage[@"imageFile"] = file;
    userImage[@"username"] = [PFUser currentUser].username;
    userImage[@"status"] = @"Step 1";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd hh:mm a"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    userImage[@"timestamp"] = formattedDateString;
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error)
    {
        userImage[@"geo"] = geoPoint;
        [[PFUser currentUser][@"images"] addObject:userImage];
        
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (succeeded)
             {
                 [alertManager dismissWaitIndicator];
                 if ([delegate respondsToSelector:@selector(imageUploadFinished)])
                 {
                     [delegate imageUploadFinished];
                 }
             }
             else
             {
                 [alertManager dismissWaitIndicator];
                 if (error)
                 {
                     if ([delegate respondsToSelector:@selector(imageUploadFailed:)])
                     {
                         NSString *errorString = [error userInfo][@"error"];
                         [delegate imageUploadFailed:errorString];
                     }
                 }
             }
         }];
    }];
}

-(void) signUpUser:(NSString *)userName Pass:(NSString *)password Email:(NSString *)email
{
    [alertManager showWaitIndicator];
    PFUser *user = [PFUser user];
    user.username = userName;
    user.password = password;
    user.email = email;
    user[@"images"] = [[NSMutableArray alloc] init];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            [alertManager dismissWaitIndicator];
            if ([delegate respondsToSelector:@selector(signUpFinished)])
            {
                [delegate signUpFinished];
            }
        }
        else
        {
            [alertManager dismissWaitIndicator];
            if (error)
            {
                if ([delegate respondsToSelector:@selector(signUpFailed:)])
                {
                    NSString *errorString = [error userInfo][@"error"];
                    [delegate signUpFailed:errorString];
                }
            }
        }
    }];
}

-(void) loginUser:(NSString *)userName Pass:(NSString *)password
{
    [alertManager showWaitIndicator];
    [PFUser logInWithUsernameInBackground:userName password:password
                                    block:^(PFUser *user, NSError *error)
    {
        if (user)
        {
            [alertManager dismissWaitIndicator];
            NSLog(@"User name %@", user.username);
            NSLog(@"Images count %lu", (unsigned long)[user[@"images"] count]);
            if ([delegate respondsToSelector:@selector(logInFinished)])
            {
                [delegate logInFinished];
            }
        }
        else
        {
            [alertManager dismissWaitIndicator];
            if (error)
            {
                if ([delegate respondsToSelector:@selector(logInFailed:)])
                {
                    NSString *errorString = [error userInfo][@"error"];
                    [delegate logInFailed:errorString];
                }
            }
        }
    }];
}

-(void) logOutUser
{
    [PFUser logOut];
}

-(BOOL) isCurrenUserLoggedIn
{
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"User name %@", currentUser.username);
    if (currentUser.username)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
