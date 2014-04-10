MGUpdateChecker is a software update kit for enterprise distributed apps. Works pretty much like the HockeyApp updating.

#Installation

Drag and drop into your project and specify the path to your enterprise .plist file:

	#define kMGUpdateCheckerDefaultPlistURL @"https://YOUR SERVER HERE/manifest.plist"

And then put this wherever you want to check for updates:

	[[MGUpdateChecker defaultChecker] checkForUpdates];

A good practice is to put it in your 	‘application:willFinishLaunchingWithOptions:’