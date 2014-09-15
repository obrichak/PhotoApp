#import "ActivityIndicatorView.h"

@implementation ActivityIndicatorView

+ (ActivityIndicatorView*) createActivityIndicatorView
{
    UIWindow* rootWindow = [[UIApplication sharedApplication] keyWindow];
    
    ActivityIndicatorView* view = [[ActivityIndicatorView alloc] initWithFrame: [rootWindow frame]];
    view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    [view setRootWindow:rootWindow];
    view.alpha = 0.0f;
    
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [activityView startAnimating];
    [view addSubview: activityView];
    
    CGRect frame = activityView.frame;
    
    frame.origin.x = ([rootWindow frame].size.width / 2.0f) - (frame.size.width / 2.0f);
    frame.origin.y = ([rootWindow frame].size.height / 2.0f) - (frame.size.height / 2.0f);
    
    activityView.frame = frame;
    
    return view;
}

-(void) setRootWindow:(UIWindow *)window
{
    rootWindow = window;
}

- (void) present
{
    [rootWindow addSubview: self];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f / 5.0f];
    [UIView setAnimationDelegate:self];
    
    self.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void) dismiss
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f / 5.0f];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector: @selector(removeDidFinish)];
    
    self.alpha = 0.0;
    
    [UIView commitAnimations];
}

- (void) removeDidFinish
{
    [self removeFromSuperview];
}

@end
