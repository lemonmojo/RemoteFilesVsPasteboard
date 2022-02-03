#import "FileSystemUtils.h"

@implementation FileSystemUtils

+ (NSURL*)temporaryFileURLForFileNamed:(NSString*)fileName {
	NSString* tempDirPrefix = @"PasteboardTests";
	NSString* newUUID = NSUUID.UUID.UUIDString;
	NSString* tempDirName = [NSString stringWithFormat:@"%@_%@", tempDirPrefix, newUUID];
	
	NSString* tempDirRootPath = NSFileManager.defaultManager.temporaryDirectory.path;
	NSString* tempDirPath = [tempDirRootPath stringByAppendingPathComponent:tempDirName];
	
	NSString* tempFilePath = [tempDirPath stringByAppendingPathComponent:fileName];
	NSURL* tempFileURL = [NSURL fileURLWithPath:tempFilePath isDirectory:NO];
	
	return tempFileURL;
}

+ (BOOL)createParentDirectoriesForFileURLIfRequired:(NSURL*)fileURL {
	NSURL* parentDirectoryURL = fileURL.URLByDeletingLastPathComponent;
	
	NSFileManager* fileManager = NSFileManager.defaultManager;
	
	if (![fileManager fileExistsAtPath:parentDirectoryURL.path]) {
		BOOL createSuccess = [fileManager createDirectoryAtURL:parentDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil];
		
		return createSuccess;
	}
	
	return YES;
}

@end
