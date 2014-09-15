#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize loginField, passwordField;

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
    loginField.delegate = self;
    passwordField.delegate = self;
    
    if ([[ParseManager getInstance] isCurrenUserLoggedIn])
    {
        [self logInFinished];
    }
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated
{
    [ParseManager getInstance].delegate = self;
    
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [ParseManager getInstance].delegate = nil;
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

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

#pragma mark buttons

- (IBAction)loginAction:(id)sender
{
    if ([passwordField.text length] == 0 || [loginField.text length] == 0)
    {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password and username must contain symbols" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
    }
    else
    {
        [[ParseManager getInstance] loginUser:loginField.text Pass:passwordField.text];
    }
}

-(void) logInFinished
{
    [self performSegueWithIdentifier:@"loggedIn" sender:self];
}

-(void) logInFailed:(NSString *)reason
{
    errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlertView show];
}


-(BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
