#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize emailField, loginField, passwordField;

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
    emailField.delegate = self;
    loginField.delegate = self;
    passwordField.delegate = self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerAction:(id)sender
{
    if ([passwordField.text length] == 0 || [loginField.text length] == 0)
    {
        errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password and username must contain symbols" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlertView show];
    }
    else
    {
        [[ParseManager getInstance] signUpUser:loginField.text Pass:passwordField.text Email:emailField.text];
    }
}

-(void) signUpFinished
{
    [self performSegueWithIdentifier:@"registered" sender:self];
}

-(void) signUpFailed:(NSString *)reason
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
