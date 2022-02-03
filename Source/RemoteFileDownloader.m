#import "RemoteFileDownloader.h"
#import "RemoteFile.h"

@implementation RemoteFileDownloader

- (void)retrieveAndSaveDataForRemoteFile:(RemoteFile*)remoteFile completion:(void (^)(BOOL success))completionHandler {
	NSLog(@"Retrieving data for remote file named \"%@\"", remoteFile.remoteFileName);
	
	NSAlert* alert = [NSAlert new];
	alert.messageText = [NSString stringWithFormat:@"Provide data for \"%@\"", remoteFile.remoteFileName];
	alert.informativeText = @"This is the part where the data of the remote file should be downloaded. To simulate the download, you can provide some text in the textbox below which will be written to the local file.";
	
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	
	NSTextField* textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
	textField.usesSingleLineMode = YES;
	textField.editable = YES;
	textField.lineBreakMode = NSLineBreakByClipping;
	textField.cell.wraps = NO;
	textField.cell.scrollable = YES;
	
	textField.placeholderString = @"Data for file";
	textField.stringValue = @"Put data for file here";
	
	alert.accessoryView = textField;
	
	NSWindow* window = self.mainWindow;
	
	[NSApp activateIgnoringOtherApps:YES];
	[window makeKeyAndOrderFront:nil];
	
	[alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
		BOOL success = NO;
		
		if (returnCode == NSAlertFirstButtonReturn) {
			NSData* data = [textField.stringValue dataUsingEncoding:NSUTF8StringEncoding];
			
			if (data) {
				NSLog(@"Writing contents of remote file named \"%@\" to temporary file at \"%@\"...", remoteFile.remoteFileName, remoteFile.localTemporaryFileURL.path);
				
				success = [data writeToURL:remoteFile.localTemporaryFileURL atomically:NO];
			}
		}
		
		completionHandler(success);
	}];
}

- (BOOL)saveData:(NSData*)data ofRemoteFile:(RemoteFile*)remoteFile {
	NSLog(@"Writing contents of remote file named \"%@\" to temporary file at \"%@\"...", remoteFile.remoteFileName, remoteFile.localTemporaryFileURL.path);
	
	BOOL success = [data writeToURL:remoteFile.localTemporaryFileURL atomically:NO];
	
	return success;
}

@end
