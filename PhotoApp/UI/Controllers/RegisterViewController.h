#import <UIKit/UIKit.h>
#import "ParseManager.h"

@interface RegisterViewController : UIViewController <ParseManagerProtocol, UITextFieldDelegate>
{
    UIAlertView *errorAlertView;
}

- (IBAction)backAction:(id)sender;
- (IBAction)registerAction:(id)sender;

@property (strong) IBOutlet UITextField *loginField;
@property (strong) IBOutlet UITextField *passwordField;
@property (strong) IBOutlet UITextField *emailField;

@end
