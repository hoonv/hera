//
//  AppDelegate.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/20.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
                
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        //유효기간 알림 기능
        
            //권한 설정
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
            guard didAllow else{
                return
            }
            DispatchQueue.main.sync{
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
        return true
    }
    
    private func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
                
        print("application:didReceiveRemoteNotification:fetchCompletionHandler: \(userInfo)")
       completionHandler(.newData)  
    }
    
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

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("User email: \(user.profile.email ?? "No email")")
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate{
    // 앱이 foreground상태 일 때, 알림이 온 경우 처리
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        // 푸시가 오면 alert, badge, sound표시를 하라는 의미
        if #available(iOS 14.0, *) {
            completionHandler([.list, .sound, .banner])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }

    // push가 온 경우 처리
    // notrification을 누른 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                       return
                }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // deep link처리 시 아래 url값 가지고 처리
        if response.notification.request.identifier == "Local Notification" {
            if let secondVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? UIViewController,
                let navController = rootViewController as? UINavigationController{

                    navController.pushViewController(secondVC, animated: true)
                    
                }
        }

        completionHandler()


        // if url.containts("receipt")...
    }
    
    //- 디바이스 토큰 등록 성공 시 실행되는 메서드
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }
    //- 디바이스 토큰 등록 실패 시 실행되는 메서드

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
}


