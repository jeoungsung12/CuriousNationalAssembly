//
//  SceneDelegate.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/20.
//

import UIKit
import KakaoSDKAuth
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
        guard let windowScene = scene as? UIWindowScene else { return }
            
        window = UIWindow(windowScene: windowScene)
        
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
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        UNUserNotificationCenter.current().getNotificationSettings { settings in // 앱의 알람 설정 상태 확인
                   print("Notification")
                   
                   if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                       // setting이 알람을 받는다고 한 상태가 권한을 받은 상태라면
//                       LocalNotificationHelper.scheduleNotification(title: "알려질병", body: "유행 질병이 위험 수준입니다.\n행동요령을 확인해주세요!", seconds: 2, identifier: "identifier")
                   } else {
                       print("알림설정 X")
                   }
               }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

