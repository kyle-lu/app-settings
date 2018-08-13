#include <syslog.h>
#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@interface AppSettings : NSObject {
	UITapGestureRecognizer* _tapRecognizer;
}
@end

@implementation AppSettings

- (id)init {
	self = [super init];
	if (self) {
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		_tapRecognizer.numberOfTouchesRequired = 3;
	}
	return self;
}

- (void)windowDidBecomeKey:(NSNotification*)notification {
	UIWindow *window = notification.object;
	[window addGestureRecognizer:_tapRecognizer];
}

- (void)windowDidResignKey:(NSNotification*)notification {
	UIWindow *window = notification.object;
	[window removeGestureRecognizer:_tapRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
	if (recognizer.state == UIGestureRecognizerStateRecognized) {
		syslog(LOG_DEBUG, "UIApplicationOpenSettingsURLString: '%s'\n", UIApplicationOpenSettingsURLString.UTF8String); // 'app-settings:'
		NSURL* url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
		if ([UIApplication.sharedApplication canOpenURL:url]) [UIApplication.sharedApplication openURL:url];
	}
}

+ (void)load {
	syslog(LOG_NOTICE, "EntryPoint\n");
	AppSettings* observer = [[AppSettings alloc] init];
	NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
	[center addObserver:observer selector:@selector(windowDidBecomeKey:) name:UIWindowDidBecomeKeyNotification object:nil];
	[center addObserver:observer selector:@selector(windowDidResignKey:) name:UIWindowDidResignKeyNotification object:nil];
}

@end
