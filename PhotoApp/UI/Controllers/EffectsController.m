#import "EffectsController.h"
#import "ParseManager.h"
#import "SWRevealViewController.h"
#import "StatsViewController.h"

@interface EffectsController ()

@end

@implementation EffectsController

@synthesize cropButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentModel = [[PhotoModelManager getInstance] selectedPhotoModel];
    
    [ParseManager getInstance].delegate = self;
    
    NSData* imageData = currentModel.imageData;
    UIImage* image = [UIImage imageWithData:imageData];
    self.photo.image = image;

    [cropButton setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    StatsViewController *destViewController = segue.destinationViewController;
    destViewController.photoIndex = -1;
    destViewController.currentModel = currentModel;
}


- (IBAction)continueBtn:(id)sender {
    
    //[[ParseManager getInstance] uploadImage:self.photo.image];
    [[ParseManager getInstance] uploadImage:[UIImage imageWithData:currentModel.imageData]];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filter1Action:(id)sender
{
    UIImage *currentImage = self.photo.image;

    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[currentImage CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 10] forKey: @"inputRadius"];
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    
    [self.photo setImage:[UIImage imageWithCIImage:outputImage]];
    
    currentImage = self.photo.image;
    
    CGSize destinationSize = CGSizeMake(currentImage.size.width,currentImage.size.height);
    UIGraphicsBeginImageContext(destinationSize);
    [currentImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *filedata  = UIImagePNGRepresentation(newImage);
    
    currentModel.imageData = filedata;
}

- (IBAction)filter2Action:(id)sender
{

}

- (IBAction)filter3Action:(id)sender
{
    
}
- (IBAction)cropButtonAction:(id)sender
{

}

#pragma mark - ParseManager Delegate methods

-(void) imageUploadFinished
{
    successAlertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                  message:@"Photo was uploaded. Would you like to go to start screen?"
                                                 delegate:self
                                        cancelButtonTitle:@"YES"
                                        otherButtonTitles:@"NO", nil];
    [successAlertView show];
}

-(void) imageUploadFailed:(NSString *)reason
{
    failAlertView = [[UIAlertView alloc] initWithTitle:@"Upload failed!" message:reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failAlertView show];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == successAlertView)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self performSegueWithIdentifier:@"goStats" sender:self];
        }
    }
}

@end
