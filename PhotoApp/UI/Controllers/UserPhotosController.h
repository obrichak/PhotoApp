#import <UIKit/UIKit.h>
#import "PhotosCollectionView.h"
#import "PhotosCollectionCell.h"

@interface UserPhotosController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger itemsCount;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong) IBOutlet PhotosCollectionView* photosView;

@end
