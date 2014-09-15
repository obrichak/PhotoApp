#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIView
{
    UIWindow* rootWindow;
}

+ (ActivityIndicatorView*) createActivityIndicatorView;

-(void) setRootWindow:(UIWindow *)window;
- (void) present;
- (void) dismiss;

@end
