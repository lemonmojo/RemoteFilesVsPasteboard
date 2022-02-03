#import "AppDelegate.h"

#import "RemoteFileManager.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow* window;
@property (weak) IBOutlet NSTextField *textFieldRemoteFileName;

@property (strong) RemoteFileManager* remoteFileManager;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.remoteFileManager = [[RemoteFileManager alloc] initWithMainWindow:self.window];
}

- (IBAction)buttonTriggerRemoteFileCopy_action:(id)sender {
	NSString* remoteFileName = self.textFieldRemoteFileName.stringValue;
	
	[self.remoteFileManager removeAllRemoteFilesFromClipboard];
	[self.remoteFileManager addRemoteFileToClipboard:remoteFileName];
}

@end
