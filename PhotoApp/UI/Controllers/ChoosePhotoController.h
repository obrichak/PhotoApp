#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#import "ParseManager.h"

@interface ChoosePhotoController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{

}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *frameForCamera;
@property (strong, nonatomic) IBOutlet UIButton *resultsBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong) IBOutlet UIButton *watchPhotosButton;

- (IBAction)takePhoto:(id)sender;
- (IBAction)uploadPhoto:(id)sender;
- (IBAction)goResult:(id)sender;

@end
