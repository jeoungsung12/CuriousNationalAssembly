//
//  KakaoLoginService.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/21.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import KakaoSDKAuth
import KakaoSDKUser
class KakaoLoginService {
    static func isKakaoTalkLogin(completion: @escaping (Bool) -> Void){
        print("isKakaoTalkLogin - called()")
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    completion(false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    //do something
                    if let token = oauthToken,
                       let scopes = token.scopes {
                        if scopes.contains("account_email") && scopes.contains("profile_nickname"){
                            UserApi.shared.me{ (user, error) in
                                if let error = error {
                                    print("프로필 정보 요청 오류: \(error)")
                                }else{
                                    let kakaoAccessToken = oauthToken?.accessToken as? String ?? ""
                                    let kakaorefreshToken = oauthToken?.refreshToken as? String ?? ""
                                    let kakaoEmail = user?.kakaoAccount?.email ?? ""
                                    let kakaoname = user?.kakaoAccount?.profile?.nickname ?? ""
                                    LoginServiceAuth.saveAuthToken(accessToken: kakaoAccessToken, refreshToken: kakaorefreshToken, email: kakaoEmail, name: kakaoname)
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            }
        }else{
            //카카오톡이 설치되어 있지 않은 경우 웹으로 로그인
            UserApi.shared.loginWithKakaoAccount{ (oauthToken, error) in
                if let error = error {
                    print("에러:\(error)")
                    completion(false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    //do something
                    if let token = oauthToken,
                       let scopes = token.scopes {
                        if scopes.contains("profile_nickname"){
                            UserApi.shared.me{ (user, error) in
                                if let error = error {
                                    print("프로필 정보 요청 오류: \(error)")
                                }else{
                                    let kakaoAccessToken = oauthToken?.accessToken as? String
                                    ?? ""
                                    let kakaorefreshToken = oauthToken?.refreshToken as? String ?? ""
                                    let kakaoEmail = ""
                                    let kakaoname = user?.kakaoAccount?.profile?.nickname ?? ""
                                    LoginServiceAuth.saveAuthToken(accessToken: "Bearer " + kakaoAccessToken, refreshToken: "Bearer " + kakaorefreshToken, email: kakaoEmail, name: kakaoname)

                                    completion(true)
                                }
                            }
                        }
                    }
                }
            }
        }
        completion(false)
    }
}
