#import "StatsViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>

@interface StatsViewController ()

@end

@implementation StatsViewController

@synthesize photoIndex, currentModel;

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
    [super viewDidLoad];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    NSData* imageData;
    if (photoIndex < 0)
    {
        if (currentModel)
        {
            imageData = currentModel.imageData;
            UIImage* image = [UIImage imageWithData:imageData];
            self.photo.image = image;
        }
    }
    else
    {
        PFObject *userImage = [[PFUser currentUser][@"images"] objectAtIndex:photoIndex];
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
                          self.photo.image = image;
                      }
                  }];
                 
             }
         }];
    }

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
