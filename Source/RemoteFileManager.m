#import "RemoteFileManager.h"

#import "RemoteFile.h"
#import "RemoteFileDownloader.h"
#import "RemoteFilePresenter.h"

@interface RemoteFileManager ()<RemoteFilePresenterDelegate>

@property (strong) RemoteFileDownloader* remoteFileDownloader;
@property (strong) NSMutableArray<RemoteFilePresenter*>* remoteFilePresenters;

@end

@implementation RemoteFileManager

- (instancetype)initWithMainWindow:(NSWindow*)mainWindow {
	self = [super init];
	
	if (self) {
		RemoteFileDownloader* remoteFileDownloader = [RemoteFileDownloader new];
		remoteFileDownloader.mainWindow = mainWindow;
		
		self.remoteFileDownloader = remoteFileDownloader;
		self.remoteFilePresenters = [NSMutableArray array];
	}
	
	return self;
}

- (void)addRemoteFileToClipboard:(NSString*)remoteFileName {
	RemoteFile* remoteFile = [self remoteFileNamed:remoteFileName];
	
	if (!remoteFile) {
		return;
	}
	
	[self writeRemoteFile:remoteFile toPasteboard:NSPasteboard.generalPasteboard];
}

- (void)removeAllRemoteFilesFromClipboard {
	[self removeAllRemoteFilePresenters];
}

- (void)removeAllRemoteFilePresenters {
	for (RemoteFilePresenter* remoteFilePresenter in self.remoteFilePresenters) {
		NSLog(@"Removing file presenter for remote file named \"%@\"", remoteFilePresenter.remoteFile.remoteFileName);
		
		remoteFilePresenter.delegate = nil;
		[remoteFilePresenter stopPresenting];
	}
	
	[self.remoteFilePresenters removeAllObjects];
}

- (void)addRemoteFilePresenter:(RemoteFilePresenter*)remoteFilePresenter {
	[self.remoteFilePresenters addObject:remoteFilePresenter];
}

- (void)removeRemoteFilePresenter:(RemoteFilePresenter*)remoteFilePresenter {
	NSLog(@"Removing file presenter for remote file named \"%@\"", remoteFilePresenter.remoteFile.remoteFileName);
	
	remoteFilePresenter.delegate = nil;
	[remoteFilePresenter stopPresenting];
	
	[self.remoteFilePresenters removeObject:remoteFilePresenter];
}

- (nullable RemoteFile*)remoteFileNamed:(NSString*)remoteFileName {
	RemoteFile* remoteFile = [[RemoteFile alloc] initWithRemoteFileName:remoteFileName];
	
	if (![remoteFile createLocalTemporaryFile] ||
		!remoteFile.localTemporaryFileURL) {
		NSLog(@"Error: Failed to create local temporary file");
		return nil;
	}
	
	return remoteFile;
}

- (void)writeRemoteFile:(RemoteFile*)remoteFile toPasteboard:(NSPasteboard*)pasteboard {
	NSLog(@"Registering a remote file presenter for remote file named \"%@\"", remoteFile.remoteFileName);
	
	// Register a file presenter for the remote file we will put on the pasteboard
	RemoteFilePresenter* filePresenter = [[RemoteFilePresenter alloc] initWithRemoteFile:remoteFile];
	filePresenter.delegate = self;
	
	// Keep a reference of the file presenter around so that we can remove it in case the user copies something else on the remote clipboard
	[self addRemoteFilePresenter:filePresenter];
	
	NSLog(@"Clearing contents of clipboard");
	
	// Clear contents of pasteboard
	[pasteboard clearContents];
	
	NSLog(@"Announcing availability of new file URL on clipboard");
	
	// Announce new data availability
	[pasteboard prepareForNewContentsWithOptions:NSPasteboardContentsCurrentHostOnly];
	[pasteboard declareTypes:@[ NSURLPboardType ] owner:nil];
	[pasteboard writeObjects:@[ remoteFile.localTemporaryFileURL ]];
}

- (void)remoteFilePresenter:(RemoteFilePresenter *)remoteFilePresenter writeDataWithCompletion:(void (^)(BOOL))completionHandler {
	RemoteFile* remoteFile = remoteFilePresenter.remoteFile;
	
	NSLog(@"System requested data for remote file named \"%@\"", remoteFile.remoteFileName);
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.remoteFileDownloader retrieveAndSaveDataForRemoteFile:remoteFile completion:^(BOOL success) {
			completionHandler(success);
			
			// Remove reference of file presenter
			[self removeRemoteFilePresenter:remoteFilePresenter];
		}];
	});
}

@end
