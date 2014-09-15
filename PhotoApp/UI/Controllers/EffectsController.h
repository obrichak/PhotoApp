#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseManager.h"
#import "PhotoModelManager.h"

@interface EffectsController : UIViewController <ParseManagerProtocol>
{
    UIAlertView *successAlertView;
    UIAlertView *failAlertView;
    PhotoModel *currentModel;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)back:(id)sender;
- (IBAction)filter1Action:(id)sender;
- (IBAction)filter2Action:(id)sender;
- (IBAction)filter3Action:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UITextField *comboBox;

@property (strong) IBOutlet UIButton *filter1Button;
@property (strong) IBOutlet UIButton *filter2Button;
@property (strong) IBOutlet UIButton *filter3Button;

@property (strong) IBOutlet UIButton *cropButton;

@end
