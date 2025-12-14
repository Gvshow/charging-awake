#import <UIKit/UIKit.h>

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig(application);
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}
%end

%ctor {
    if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
}
