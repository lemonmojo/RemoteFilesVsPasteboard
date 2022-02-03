#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemoteFile : NSObject

@property (readonly, copy) NSString* remoteFileName;
@property (readonly, copy) NSURL* localTemporaryFileURL;

- (instancetype)initWithRemoteFileName:(NSString*)remoteFileName;

- (BOOL)createLocalTemporaryFile;

@end

NS_ASSUME_NONNULL_END
