//
//  LoginServiceAuth.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/20.
//

import SwiftKeychainWrapper
import Foundation
import UIKit
//import NaverThirdPartyLogin
import AuthenticationServices
//import KakaoSDKAuth
//import KakaoSDKUser
class LoginServiceAuth{
    //로그인 사용자의 토큰을 저장하는 Keychain
    private let accessToken = "accessToken"
    private let refreshToken = "refreshToekn"
    private let email = "email"
    private let name = ""
    //키체인을 이용해 로그인 토큰 저장 메서드 -> 이름과 이메일도 저장해야할까?
    static func saveAuthToken(accessToken : String, refreshToken : String, email : String, name : String) {
        print("LoginServiceAuth.saveAuthToken - called()")
        KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(refreshToken, forKey: "refreshToken")
        KeychainWrapper.standard.set(email, forKey: "email")
        KeychainWrapper.standard.set(name, forKey: "name")
    }
    //로그인 토큰 삭제(로그아웃) 메서드
    static func logoutUser(){
        print("LoginServiceAuth.logoutUser - called()")
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "refreshToken")
//        let naverLoginService = LoginViewController()
//        naverLoginService.naverLogout { success in
//            if success {
//                print("Naver logout success")
//            } else {
//                print("Naver logout failed")
//            }
//        }
        //로그아웃 시킴 -> 로그인 화면으로 이동 -> 루트뷰를 로그인뷰로 전환
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    //현재 로그인 상태 확인
    static func isUserLoggedIn() -> Bool {
        print("LoginSeriveAuth.isUserLoggedIn - called()")
        if let token = KeychainWrapper.standard.string(forKey: "accessToken"){
            // 저장된 토큰이 있을 경우, 토큰이 유효한지 검사
            let loginmethod = UserDefaults.standard.string(forKey: "LoginMethod")
            return isTokenValid(LoginMethod: loginmethod ?? "")
        }
        return false
    }
    //로그인 토큰 유효성 검사 메서드
    static func isTokenValid(LoginMethod : String) -> Bool {
        print("LoginServiceAuth.isTokenValid - called()")
        print("로그인 방법 : \(LoginMethod)")
        //재발행은 카카오, 네이버, 애플 각 SDK에서 자동으로 시킴.
        //리프레시 토큰 만료시 로그아웃 처리
        if LoginMethod == "Kakao" {
            //카카오 로그인일 경우 -> 리프레시 토큰 유효성 검사
            
        }else if LoginMethod == "Naver" {
            //네이버 로그인일 경우 -> 리프레시 토큰 유효성 검사
            
        }else if LoginMethod == "Apple" {
            //애플 로그인일 경우 -> 리프레시 토큰 유효성 검사
            
        }
        return true
    }
}
