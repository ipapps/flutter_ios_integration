
# Flutter module in iOS app

## Installation
### Documentation
We have followed the [tutorial here](https://docs.flutter.dev/add-to-app/ios/project-setup) by the Flutter team, with option B (no Cocoapods for Flutter SDK)
### Info.plist
We need to create two `Info.plist`, one for Debug and one for Release.
In `Info-Debug.plist`, add the following key/value to allow debugging:

    <key>NSBonjourServices</key>
	<array>
		<string>_dartVmService._tcp</string>
	</array>
	<key>NSLocalNetworkUsageDescription</key>
	<string>Local Network Usage for Flutter Debugging</string>
In both `Info.plist`, please add the following key/value in order to use the older Flutter engine (the Impeller one crashes the app):

    <key>FLTEnableImpeller</key>
	<false/>
### AppDelegate
Add all the callbacks as follow and create an instance of the Flutter Engine to warm it up as soon as possible:
```
import UIKit
import Flutter
// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

@main
class AppDelegate: UIResponder, UIApplicationDelegate, FlutterAppLifeCycleProvider, ObservableObject {
    
    private let lifecycleDelegate = FlutterPluginAppLifeCycleDelegate()

    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run();
        // Connects plugins with iOS platform code to this app.
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
        return lifecycleDelegate.application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      lifecycleDelegate.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      lifecycleDelegate.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      lifecycleDelegate.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      return lifecycleDelegate.application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
      return lifecycleDelegate.application(application, handleOpen: url)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return lifecycleDelegate.application(application, open: url, sourceApplication: sourceApplication ?? "", annotation: annotation)
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
      lifecycleDelegate.application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
      lifecycleDelegate.application(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      lifecycleDelegate.application(application, performFetchWithCompletionHandler: completionHandler)
    }

    func add(_ delegate: FlutterApplicationLifeCycleDelegate) {
      lifecycleDelegate.add(delegate)
    }
}
```
### Launching the Flutter module
Within the context of launching the module, do as follows. Get the flutterEngine from the app delegate and launch the Flutter View Controller:
```
    @IBAction func didClickFlutterButton(_ sender: UIButton) {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController =
            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        flutterViewController.modalPresentationStyle = .overCurrentContext
        flutterViewController.isViewOpaque = false
        present(flutterViewController, animated: true, completion: nil)
    }
```
### Manually add the frameworks in Build Phases
You need to drag all the frameworks found in `/flutter_module/Release` in the phase "Link binary with Libraries".
### Embed and sign the frameworks
You then need to choose "Embed & Sign" on all added frameworks in the General tab, under "Frameworks, Libraries and Embedded Content". Then add in "Framework Search Paths" in the Build settings the following line :

    ${PROJECT_DIR}/flutter_module/$(CONFIGURATION)
Then normally, you will see the frameworks appear in the phase "Embed Frameworks" in the Build Phases.
### Manually modify the app pbxproj
Last but not least, in order to switch from Debug to Release configuration easily, you will need to manually modify the app project pbxproj.
Open the file `flutterintegration.xcodeproj/project.pbxproj` and change *all* the lines that contains :

    path = flutter_module/Release/SOMETHING.xcframework"
by:

    path = "flutter_module/$(CONFIGURATION)/SOMETHING.xcframework"
be careful of the `"`.
## Current features

1. Quit the Flutter module
2. Crash the Flutter module (throwing exception) without crashing the iOS app
3. Native share
