# Remote Files vs. Pasteboard
A macOS demo project to demonstrate how to put remote files on local clipboard and provide data asynchronously when pasting in Finder

## How to use the Demo Project
- Build and Run using Xcode
- Provide a fake remote file name in the text field (or keep the default)
- Click "Trigger Remote File Copy"
- Open Finder
- Go to "Edit - Paste Item" or press Command+V
- The app will automatically become active again and prompt you to provide some dummy data for the remote file
- Enter some text into the text field (or keep the default)
- Notice that if you switch back to Finder after a second or two a progress dialog appeared
- This dialog will stay on screen until you click either "OK" or "Cancel" in the alert in the demo app
- To complete the paste, either click "OK" or "Cancel" in the alert in the demo app
- If you click cancel, the file will be copied to the destination anyway, but it will remain empty

## How it works
Here's a basic overview of how this works:
- An empty temporary file is written to a temporary path on the file system using the provided file name
- A class implementing the [`NSFilePresenter`](https://developer.apple.com/documentation/foundation/nsfilepresenter?language=objc) protocol is passed to [`-[NSFileCoordinator addFilePresenter:]`](https://developer.apple.com/documentation/foundation/nsfilecoordinator/1417120-addfilepresenter?language=objc)
- The pasteboard's contents are cleared
- The temporary file URL is written to the pasteboard
- As soon as paste is triggered in Finder, [`-[NSFilePresenter relinquishPresentedItemToReader:]`](https://developer.apple.com/documentation/foundation/nsfilepresenter/1410743-relinquishpresenteditemtoreader) is called
- The data is written asynchronously to the temporary file (in a real application, the data would first be downloaded, then written to disk)
- Once the write is complete, the completion handler is invoked
- The file presenter is removed from `NSFileCoordinator` to prevent further invocations
- This returns control of the paste operation to the system
- The temporary file is finally copied to its target location
