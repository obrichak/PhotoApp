#import <UIKit/UIKit.h>
#import "PhotoModelManager.h"

@interface StatsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (assign) NSInteger photoIndex;
@property (strong) PhotoModel *currentModel;

@end
