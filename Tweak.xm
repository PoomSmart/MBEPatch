#import <UIKit/UIKit.h>
#define PREF_PATH @"/var/mobile/Library/Preferences/com.PS.MBEPatch.plist"
#define RECT_KEY @"Rect"

// Prediction, using Hopper Disassembler program
@interface MenuButtonEmulator : UIView
+ (id)sharedInstance;
- (id)init;
- (void)setupGestureRecognizers;
- (void)setFrame:(CGRect)frame;
- (void)handlePanGesture:(id)arg1;
- (BOOL)isPanning;
- (void)setIsPanning:(BOOL)pan;
@end

%group MenuButtonEmulator

%hook MenuButtonEmulator

- (void)setupGestureRecognizers
{
	%orig;
	NSString *rect = [[NSDictionary dictionaryWithContentsOfFile:PREF_PATH] objectForKey:RECT_KEY];
	if (rect != nil) {
		[self setIsPanning:YES];
		[self setFrame:CGRectFromString(rect)];
		[self setIsPanning:NO];
	}
}

- (void)setIsPanning:(BOOL)pan
{
	%orig;
	if (!pan) {
		NSString *rect = NSStringFromCGRect([self frame]);
		NSMutableDictionary *dict = [[NSDictionary dictionaryWithContentsOfFile:PREF_PATH] mutableCopy];
		if (dict == nil)
			dict = [NSMutableDictionary dictionary];
		[dict setObject:rect forKey:RECT_KEY];
		[dict writeToFile:PREF_PATH atomically:YES];
	}
}

%end

%end

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1
{
	%orig;
	%init(MenuButtonEmulator, MenuButtonEmulator = objc_getClass("MenuButtonEmulator"));
}

%end

%ctor
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	[pool drain];
}