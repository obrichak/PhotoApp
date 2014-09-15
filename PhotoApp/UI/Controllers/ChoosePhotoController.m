#import "ChoosePhotoController.h"
#import <AVFoundation/AVFoundation.h>
#import "PhotoModelManager.h"
#import "SWRevealViewController.h"
#import "Constants.h"

@interface ChoosePhotoController ()

@end

@implementation ChoosePhotoController

PhotoModel* currentPhotoModel;

AVCaptureSession * session;
AVCaptureStillImageOutput * stillImageOutput;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initAVCaptureDevice
{
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError * error;
    AVCaptureDeviceInput * deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if([session canAddInput:deviceInput])
    {
        [session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer * rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.frameForCamera.frame;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex: 0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * settings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    
    [stillImageOutput setOutputSettings:settings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
}

- (void)viewDidLoad
{
    currentPhotoModel = [[PhotoModel alloc] init];
    
    [super viewDidLoad];
    
    [self initAVCaptureDevice];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    self.title = @"Help App";
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    if(self.resultsBtn.isEnabled)
        [self.resultsBtn setEnabled:NO];
    
    // Do any additional setup after loading the view.
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

#pragma mark UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    if(!self.resultsBtn.isEnabled)
        [self.resultsBtn setEnabled:YES];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.imageView.image = nil;
    
    if(self.resultsBtn.isEnabled)
        [self.resultsBtn setEnabled:NO];
    
}

- (IBAction)uploadPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)goResult:(id)sender {
    
    if(currentPhotoModel == nil)
        currentPhotoModel = [[PhotoModel alloc] init];
    
    currentPhotoModel.imageData = UIImageJPEGRepresentation(self.imageView.image, 0);
    
    [[PhotoModelManager getInstance] setSelectedPhotoModel:currentPhotoModel];
    
    self.imageView.image = nil;
    
    [self.resultsBtn setEnabled:NO];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString: SEGUE_LOGOUT]) {
        [self logout];
    }
    
}

- (IBAction)watchPhotosAction:(id)sender
{
    [self performSegueWithIdentifier:@"goToPhotos" sender:self];
}

- (void)logout
{
    NSLog(@"logout");

    [[ParseManager getInstance] logOutUser];
}

- (IBAction)takePhoto:(id)sender {
    
    if(self.imageView.image != nil)
    {
        self.imageView.image = nil;
        
        [[PhotoModelManager getInstance] setSelectedPhotoModel:nil];
        
        if(self.resultsBtn.isEnabled)
           [self.resultsBtn setEnabled:NO];
        
        return;
    }
    
    if(!self.resultsBtn.isEnabled)
        [self.resultsBtn setEnabled:YES];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection * connection in stillImageOutput.connections) {
        for(AVCaptureInputPort * port in [connection inputPorts]){
            if([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if(videoConnection) {
            break;
        }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer != NULL)
        {
            NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage* image = [UIImage imageWithData:imageData];
            
            self.imageView.image = image;

        }
    }];
}


@end
