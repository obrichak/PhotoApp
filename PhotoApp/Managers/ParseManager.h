#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol ParseManagerProtocol <NSObject>

@optional
-(void) imageUploadFinished;
-(void) imageUploadFailed:(NSString *)reason;
-(void) signUpFinished;
-(void) signUpFailed:(NSString *)reason;
-(void) logInFinished;
-(void) logInFailed:(NSString *)reason;

@end

@interface ParseManager : NSObject

+(ParseManager *) getInstance;
-(void) uploadImage:(UIImage *)image;
-(void) signUpUser:(NSString *)userName Pass:(NSString *)password Email:(NSString *)email;
-(void) loginUser:(NSString *)userName Pass:(NSString *)password;
-(void) logOutUser;
-(BOOL) isCurrenUserLoggedIn;

@property (weak) id<ParseManagerProtocol> delegate;

@end
