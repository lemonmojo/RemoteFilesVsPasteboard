@import Cocoa;

NS_ASSUME_NONNULL_BEGIN

@class RemoteFile;

@interface RemoteFileDownloader : NSObject

@property (weak) NSWindow* mainWindow;

- (void)retrieveAndSaveDataForRemoteFile:(RemoteFile*)remoteFile completion:(void (^)(BOOL success))completionHandler;

@end

NS_ASSUME_NONNULL_END
