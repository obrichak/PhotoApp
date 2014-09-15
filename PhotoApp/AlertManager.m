#import "AlertManager.h"

static AlertManager * sharedInstance;

@implementation AlertManager

+(AlertManager*) sharedAlertManager
{
    if (!sharedInstance)
    {
        sharedInstance = [[AlertManager alloc] init];
    }
    
    return sharedInstance;
}

-(id) init
{
    if (self == [super init])
    {
        
    }
    
    return self;
}

- (void) showWaitIndicator
{
    if (activityIndicator)
    {
        [self dismissWaitIndicator];
    }
    
    activityIndicator = [ActivityIndicatorView createActivityIndicatorView];
    [activityIndicator present];
}

- (void) dismissWaitIndicator
{
    [activityIndicator dismiss];
    activityIndicator = nil;
}

-(void)showWaitMsg: (NSString*) title
{
    [self dismissWaitIndicator];
    
    if (!title)
    {
        title = NSLocalizedString(@"Please wait...",);
    }
    
    if (waitAlert && waitAlert.isVisible)
    {
        [self dismissWaitMsg];
    }
    
    waitAlert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    
    [waitAlert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if (xPos < 0.00001)
    {
        xPos = waitAlert.bounds.size.width / 2;
    }
    
    if (yPos < 0.00001)
    {
        yPos = waitAlert.bounds.size.height - 50;
    }
    
    indicator.center = CGPointMake(xPos, yPos);
    [indicator startAnimating];
    [waitAlert addSubview:indicator];
    
}

-(void)dismissWaitMsg
{
    [self dismissWaitIndicator];
    [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) showAlert:(NSString *)title
{
    [self showAlert:title errorMsg:nil];
}

-(void) showAlert:(NSString *)title errorMsg:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Ok", )
                                          otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

-(void) showAlert:(NSString *)title errorMsg:(NSString *)msg delegate:(id) _delegate cancelBtn:(NSString*) cancel otherBtn:(NSString*) other
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:_delegate
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:other, nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];
}

@end
