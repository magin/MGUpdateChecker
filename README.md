MGUpdateChecker is a software update kit for enterprise distributed apps. Works pretty much like HockeyApp updating.

You must specify the path to your enterprise .plist file:

#define kMGUpdateCheckerDefaultPlistURL @"https://YOUR SERVER HERE/manifest.plist"

And then put this wherever you want to check for updates:
        [[MGUpdateChecker defaultChecker] checkForUpdates];

A good practice is to put it in your ‘application:willFinishLaunchingWithOptions:’