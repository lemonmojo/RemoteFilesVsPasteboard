#import "RemoteFile.h"
#import "FileSystemUtils.h"

@interface RemoteFile ()

@property (readwrite, copy) NSString* remoteFileName;
@property (readwrite, copy) NSURL* localTemporaryFileURL;

@end

@implementation RemoteFile

- (instancetype)initWithRemoteFileName:(NSString *)remoteFileName {
	self = [super init];
	
	if (self) {
		self.remoteFileName = remoteFileName;
	}
	
	return self;
}

- (BOOL)createLocalTemporaryFile {
	NSURL* localTemporaryFileURL = [FileSystemUtils temporaryFileURLForFileNamed:self.remoteFileName];
	
	NSLog(@"Creating parent directory of temporary file at \"%@\"...", localTemporaryFileURL.path);
	
	BOOL parentDirCreateSuccess = [FileSystemUtils createParentDirectoriesForFileURLIfRequired:localTemporaryFileURL];
	
	if (!parentDirCreateSuccess) {
		return NO;
	}
	
	NSString* localTemporaryFilePath = localTemporaryFileURL.path;
	
	NSLog(@"Creating empty temporary file at \"%@\"...", localTemporaryFilePath);
	
	BOOL tempFileCreateSuccess = [NSFileManager.defaultManager createFileAtPath:localTemporaryFilePath contents:nil attributes:nil];
	
	if (!tempFileCreateSuccess) {
		return NO;
	}
	
	self.localTemporaryFileURL = localTemporaryFileURL;
	
	return YES;
}

@end
