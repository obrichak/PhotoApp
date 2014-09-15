#import "UserPhotosController.h"
#import "StatsViewController.h"
#import <Parse/Parse.h>
#import "SWRevealViewController.h"

@interface UserPhotosController ()

@end

@implementation UserPhotosController

@synthesize photosView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    photosView.delegate = self;
    photosView.dataSource = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count = [[PFUser currentUser][@"images"] count];
    NSLog(@"Found %ld images Will create %ld sections", (long)count, count / 3 + 1);
    itemsCount = count;
    return count / 3 + 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;// [[PFUser currentUser][@"images"] count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photosCell" forIndexPath:indexPath];
    
    NSInteger currentIndex = indexPath.item + indexPath.section * 3;
    
    if (currentIndex >= itemsCount) return cell;
    
    PFObject *userImage = [[PFUser currentUser][@"images"] objectAtIndex:indexPath.item + indexPath.section * 3];
    
    [userImage fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error)
     {
         if (!error)
         {
             PFFile *imageFile = [userImage objectForKey:@"imageFile"];
             [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
              {
                  if (!error)
                  {
                      UIImage *image = [[UIImage alloc] initWithData:data];
                      [cell.imageView setImage:image];
                  }
              }];
             
         }
     }];
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger currentIndex = indexPath.item + indexPath.section * 3;
    if (currentIndex >= itemsCount) return;
    
    [self performSegueWithIdentifier:@"goToStatsFromPhotos" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [[photosView indexPathsForSelectedItems] objectAtIndex:0];
    StatsViewController *destViewController = segue.destinationViewController;
    destViewController.photoIndex = indexPath.item + indexPath.section * 3;
}


@end
