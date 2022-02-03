@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface FileSystemUtils : NSObject

+ (NSURL*)temporaryFileURLForFileNamed:(NSString*)fileName;
+ (BOOL)createParentDirectoriesForFileURLIfRequired:(NSURL*)fileURL;

@end

NS_ASSUME_NONNULL_END
