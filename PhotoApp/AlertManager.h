#import <Foundation/Foundation.h>
#import "ActivityIndicatorView.h"

@interface AlertManager : NSObject
{
    ActivityIndicatorView* activityIndicator;
    
    UIAlertView* waitAlert;
    float xPos;
    float yPos;
}

+ (AlertManager*) sharedAlertManager;

-(void)showAlert: (NSString*) title;
-(void)showAlert: (NSString *) title errorMsg:(NSString*)msg;
-(void)showWaitMsg: (NSString*) title;
-(void)showAlert: (NSString *)title errorMsg:(NSString *)msg delegate:(id) _delegate cancelBtn:(NSString*) cancel otherBtn:(NSString*) other;
-(void)dismissWaitMsg;

- (void) showWaitIndicator;
- (void) dismissWaitIndicator;

@end
