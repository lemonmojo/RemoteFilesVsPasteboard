@import Cocoa;

#import "RemoteFilePresenterDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class RemoteFile;

@interface RemoteFilePresenter : NSObject<NSFilePresenter>

@property (readonly, strong) RemoteFile* remoteFile;
@property (readwrite, weak) id<RemoteFilePresenterDelegate> delegate;

- (instancetype)initWithRemoteFile:(RemoteFile*)remoteFile;

- (void)stopPresenting;

@end

NS_ASSUME_NONNULL_END
