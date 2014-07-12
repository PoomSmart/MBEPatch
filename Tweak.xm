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
		CGRect frame = CGRectFromString(rect);
		CGRect correctFrame = CGRectMake(frame.origin.x, frame.origin.y, 60, 60);
		[self setFrame:correctFrame];
		[self setIsPanning:NO];
	}
}

- (void)setIsPanning:(BOOL)pan
{
	%orig;
	if (!pan) {
		CGRect frame = [self frame];
		CGRect correctFrame = CGRectMake(frame.origin.x, frame.origin.y, 60, 60);
		NSString *saveRect = NSStringFromCGRect(correctFrame);
		NSMutableDictionary *dict = [[NSDictionary dictionaryWithContentsOfFile:PREF_PATH] mutableCopy];
		if (dict == nil)
			dict = [NSMutableDictionary dictionary];
		[dict setObject:saveRect forKey:RECT_KEY];
		[dict writeToFile:PREF_PATH atomically:YES];
		
		// My draggable stuff
		/*int orient = [[UIApplication sharedApplication] statusBarOrientation];
		UIView *VIEW = [UIApplication sharedApplication].keyWindow;
		CGFloat space = 0;
		CGRect rect = CGRectFromString(saveRect);
		if (orient == 1 || orient == 2) {
			if ([self frame].origin.x > VIEW.frame.size.width - [self frame].size.width - space)
    			rect = CGRectMake(VIEW.frame.size.width - [self frame].size.width - space, [self frame].origin.y, [self frame].size.width, [self frame].size.height);
			else if ([self frame].origin.x < space)
    			rect = CGRectMake(space, [self frame].origin.y, [self frame].size.width, [self frame].size.height);
			if ([self frame].origin.y > VIEW.frame.size.height - [self frame].size.height - space)
    			rect = CGRectMake([self frame].origin.x, VIEW.frame.size.height - [self frame].size.height - space, [self frame].size.width, [self frame].size.height);
			else if ([self frame].origin.y < space)
    			rect = CGRectMake([self frame].origin.x, space, [self frame].size.width, [self frame].size.height);
		}
		else if (orient == 3 || orient == 4) {
			if ([self frame].origin.x > VIEW.frame.size.height - [self frame].size.width - space)
    			rect = CGRectMake(VIEW.frame.size.height - [self frame].size.width - space, [self frame].origin.y, [self frame].size.width, [self frame].size.height);
			else if ([self frame].origin.x < space)
    			rect = CGRectMake(space, [self frame].origin.y, [self frame].size.width, [self frame].size.height);
			if ([self frame].origin.y > VIEW.frame.size.width - [self frame].size.height - space)
    			rect = CGRectMake([self frame].origin.x, VIEW.frame.size.width - [self frame].size.height - space, [self frame].size.width, [self frame].size.height);
			else if ([self frame].origin.y < space)
    			rect = CGRectMake([self frame].origin.x, space, [self frame].size.width, [self frame].size.height);
		}
		%orig(YES);
		[self setFrame:rect];
		%orig(NO);*/
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