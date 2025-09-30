import UIKit
import Flutter
import SwiftUI

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
let viewModel = ContentViewModel()
var openDoc: Bool = true// Declare the viewModel property

private var textField = UITextField()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {



    let controller : FlutterViewController = self.window?.rootViewController as! FlutterViewController
            let Testing = window?.rootViewController as? FlutterViewController

    let methodChannel = FlutterMethodChannel(name: "com.example.flutter/native", binaryMessenger:controller.binaryMessenger)



                    methodChannel.setMethodCallHandler({
                      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

                      if call.method == "startNewActivity" {

                     // if the .swift  contiain UIViewController////
                     //let mainVC = SecondViewController()
                     // let navigationController = UINavigationController(rootViewController: mainVC)
                    //self.window.rootViewController = navigationController
                     //  self.window.makeKeyAndVisible()

                      //if the .swift not contiain UIViewController////

                          /*This is to rout to EKYC Screen */
                          let contentView = ContentView(viewModel: ContentViewModel())
                          let viewController = UIHostingController(rootView: contentView)
                          UIApplication.shared.windows.first?.rootViewController = viewController
                          UIApplication.shared.windows.first?.makeKeyAndVisible()
                          result(nil)


                      }
                        if call.method == "InitSDKios" {
                            /*This is to call just function*/
                            self.initSDK(result: result)

                        }

                        if call.method == "OCRID" {
                            /*This is to call just function*/


                               let contentView = ContentView(viewModel: ContentViewModel())
                               contentView.viewModel.currentSection = .genericOCRMenu
                               contentView.openDoc = true
                               let viewController = UIHostingController(rootView: contentView)
                               UIApplication.shared.windows.first?.rootViewController = viewController
                               UIApplication.shared.windows.first?.makeKeyAndVisible()
                               result(nil)

                        }


                        if call.method == "LivenessSDKios" {
                            /*This is to call just function*/

                              let contentID = ContentID(viewModel: ContentViewModel())
                              contentID.viewModel.currentSection = .livenessFacematch
                              contentID.openLiv = true
                              let viewController = UIHostingController(rootView: contentID)
                              UIApplication.shared.windows.first?.rootViewController = viewController
                              UIApplication.shared.windows.first?.makeKeyAndVisible()

                              result(nil)
                        }


                    })





    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    /*private func genericOCR(result: FlutterResult) {
        let contentView = ContentView(viewModel: ContentViewModel())
          // contentView.viewModel.currentSection = .livenessFacematch
           contentView.viewModel.currentSection = .genericOCRMenu
           contentView.openLiv = true
           result(nil)
    }*/
   /* private func genericOCR(result: FlutterResult) {
        let contentView = ContentView(viewModel: ContentViewModel())
           contentView.viewModel.currentSection = .genericOCRMenu
           contentView.openDoc = true
           result(nil)
    }*/

    private func initSDK(result: FlutterResult) {
       // Your SDK initialization code
       let contentView = ContentView(viewModel: ContentViewModel())
       contentView.viewModel.initSDK()
       result(nil)
     }

    private func navigateToFlutterScreen() {
        let engine = FlutterEngine(name: "my_app_engine")
        let flutterScreen = FlutterViewController(nibName: nil, bundle: nil)
        self.window?.rootViewController = flutterScreen
        self.window?.makeKeyAndVisible()

        }


}
