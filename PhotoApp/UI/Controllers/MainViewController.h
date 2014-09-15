#import <UIKit/UIKit.h>
#import "ParseManager.h"

@interface MainViewController : UIViewController <ParseManagerProtocol, UITextFieldDelegate>
{
    UIAlertView *errorAlertView;
}

- (IBAction)loginAction:(id)sender;

@property (strong) IBOutlet UITextField *loginField;
@property (strong) IBOutlet UITextField *passwordField;

@end
