//
//  AppDelegate.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/20.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]) { (didAllow,e) in
                notificationCenter.delegate = self
                application.registerForRemoteNotifications()
            }
        window = UIWindow(frame: UIScreen.main.bounds)
        KakaoSDK.initSDK(appKey: "ecbb6e3c201bd1f98e42f083229fb8ec")
        //MARK: - 로그인 검사(토큰유효성검사)
        if LoginServiceAuth.isUserLoggedIn() {
            // 사용자가 로그인되어 있는 경우 탭바 컨트롤러를 보여줌
            print("첫 로그인 - 탭바뷰를 보여줍니다.")
            let mainViewController = MainViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }else{
            // 사용자가 로그인되어 있지 않은 경우 로그인 뷰 컨트롤러를 보여줌
            print("첫 로그인 - 로그인뷰를 보여줍니다.")
            let introViewController = IntroViewController()
            let navigationController = UINavigationController(rootViewController: introViewController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
        window?.makeKeyAndVisible()
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            if response.notification.request.identifier == "notificationIdentifier" {
                let userInfo = response.notification.request.content.userInfo
                print(userInfo["name"]!)
            }
            completionHandler()
        }
    // Handle the registration for remote notifications.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        // Send this device token to your server
    }

    // Handle remote notification registration failure.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error.localizedDescription)")
    }
    // Handle notification when the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Process the notification
        completionHandler([.alert, .sound, .badge])
    }
    // Handle notification when the user taps on it.
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//            // Handle the response
//        completionHandler()
//    }
           
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

