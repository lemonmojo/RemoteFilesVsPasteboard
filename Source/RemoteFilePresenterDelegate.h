#ifndef RemoteFilePresenterDelegate_h
#define RemoteFilePresenterDelegate_h

NS_ASSUME_NONNULL_BEGIN

@class RemoteFilePresenter;

@protocol RemoteFilePresenterDelegate <NSObject>

- (void)remoteFilePresenter:(RemoteFilePresenter*)remoteFilePresenter writeDataWithCompletion:(void (^)(BOOL success))completionHandler;

@end

NS_ASSUME_NONNULL_END

#endif /* RemoteFilePresenterDelegate_h */
