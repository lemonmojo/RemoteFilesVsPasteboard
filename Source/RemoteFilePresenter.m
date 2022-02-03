#import "RemoteFilePresenter.h"

#import "RemoteFile.h"

@interface RemoteFilePresenter ()

@property (readwrite, strong) RemoteFile* remoteFile;
@property (readwrite, strong) NSOperationQueue* queue;

@end

@implementation RemoteFilePresenter

- (instancetype)initWithRemoteFile:(RemoteFile*)remoteFile {
	self = [super init];
	
	if (self) {
		self.remoteFile = remoteFile;
		
		NSOperationQueue* queue = [NSOperationQueue new];
		queue.maxConcurrentOperationCount = 1;
		
		self.queue = queue;
		
		[self present];
	}
	
	return self;
}

- (void)dealloc {
	[self stopPresenting];
}

- (void)present {
	[NSFileCoordinator addFilePresenter:self];
}

- (void)stopPresenting {
	[NSFileCoordinator removeFilePresenter:self];
}

- (NSURL *)presentedItemURL {
	return self.remoteFile.localTemporaryFileURL;
}

- (NSOperationQueue *)presentedItemOperationQueue {
	return self.queue;
}

- (void)relinquishPresentedItemToReader:(void (^)(void (^ _Nullable)(void)))reader {
	if (self.delegate) {
		[self.delegate remoteFilePresenter:self writeDataWithCompletion:^(BOOL success) {
			reader(^{ });
			
			[self stopPresenting];
		}];
	} else {
		reader(^{ });
		
		[self stopPresenting];
	}
}

@end
