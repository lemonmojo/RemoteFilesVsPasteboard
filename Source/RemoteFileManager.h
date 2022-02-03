@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@interface RemoteFileManager : NSObject

- (instancetype)initWithMainWindow:(NSWindow*)mainWindow;

- (void)addRemoteFileToClipboard:(NSString*)remoteFileName;
- (void)removeAllRemoteFilesFromClipboard;

@end

NS_ASSUME_NONNULL_END
