//
//  LoginViewController.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/20.
//

import Foundation
import UIKit
import SnapKit
import SwiftKeychainWrapper
import AuthenticationServices
//import KakaoSDKUser
//import NaverThirdPartyLogin
import Alamofire

class LoginViewController : UIViewController {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    private let TitleView : UIStackView = {
       let view = UIStackView()
        view.distribution = .fill
        view.axis = .vertical
        view.backgroundColor = .white
        view.spacing = 20
        //한글 제목
        let FirstView = UIView()
        let Title = UILabel()
        Title.text = "궁금한"
        Title.font = UIFont.boldSystemFont(ofSize: 50)
        Title.backgroundColor = .white
        Title.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        let Title2 = UILabel()
        Title2.text = "국회"
        Title2.font = UIFont.boldSystemFont(ofSize: 50)
        Title2.textColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 0.3
        )
        Title2.backgroundColor = .white
        FirstView.addSubview(Title)
        FirstView.addSubview(Title2)
        //SnapKit으로 오토레이아웃
        Title.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(10)
        }
        Title2.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.equalTo(Title.snp.trailing).offset(0)
        }
        
        //영어 제목
        let SecondView = UIView()
        let Content = UILabel()
        Content.text = "Curious"
        Content.font = UIFont.boldSystemFont(ofSize: 20)
        Content.backgroundColor = .white
        Content.textColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 0.3
        )
        let Content2 = UILabel()
        Content2.text = "NationalAssembly"
        Content2.font = UIFont.boldSystemFont(ofSize: 20)
        Content2.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        Content2.backgroundColor = .white
        SecondView.addSubview(Content)
        SecondView.addSubview(Content2)
        Content.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().inset(0)
        }
        Content2.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(50)
            make.leading.equalTo(Content.snp.trailing).offset(0)
        }
        
        view.addArrangedSubview(FirstView)
        view.addArrangedSubview(SecondView)
        FirstView.snp.makeConstraints{ (make) in
//            make.leading.trailing.equalToSuperview().inset(25)
        }
        SecondView.snp.makeConstraints{ (make) in
            make.top.equalTo(FirstView.snp.bottom).offset(10)
        }
        return view
    }()
    //네이버 소셜 로그인
//    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    private let NaverBtn : UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "NaverIcon"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.setTitle("  네이버 로그인", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(red: 3.0 / 255.0, green: 199.0 / 255.0, blue: 90.0 / 255.0, alpha: 1)
        btn.addTarget(self, action: #selector(NaverBtnTapped), for: .touchUpInside)
        return btn
    }()
    //카카오 소셜 로그인
    private let KakaoBtn : UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "KakaoIcon"), for: .normal)
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(KakaoBtnTapped), for: .touchUpInside)
        return btn
    }()
    //애플 소셜 로그인
    private let AppleBtn : ASAuthorizationAppleIDButton = {
       let btn = ASAuthorizationAppleIDButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(AppleBtnTapped), for: .touchUpInside)
        
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController - called()")
//        naverLoginInstance?.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        self.view.backgroundColor = UIColor(
            red: CGFloat(0xE5) / 255.0,
            green: CGFloat(0xE5) / 255.0,
            blue: CGFloat(0xE5) / 255.0,
            alpha: 1.0
        )
        setupView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
    }
}
extension LoginViewController {
    //제목 뷰를 스택뷰, 스냅킷을 활용해 오토레이아웃
    func setupView() {
        let StackView = UIStackView()
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.axis = .vertical
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(TitleView)
        StackView.addArrangedSubview(NaverBtn)
        StackView.addArrangedSubview(KakaoBtn)
        StackView.addArrangedSubview(AppleBtn)
        let Spacing = UIView()
        Spacing.backgroundColor = .white
        StackView.addArrangedSubview(Spacing)
        self.view.addSubview(StackView)
        //Snapkit 오토레이아웃
        StackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        TitleView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(self.view.frame.height / 3.5)
            make.leading.trailing.equalToSuperview().inset(self.view.frame.width / 5)
            make.height.equalTo(self.view.frame.height / 3)
        }
        NaverBtn.snp.makeConstraints{ (make) in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        KakaoBtn.snp.makeConstraints{ (make) in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        AppleBtn.snp.makeConstraints{ (make) in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        Spacing.snp.makeConstraints{ (make) in
            make.height.equalTo(50)
        }
    }
}
//MARK: - KakaoLogin
extension LoginViewController {
    //네이버 로그인 버튼 메서드
    @objc func NaverBtnTapped() {
        print("NaverBtnTapped - called()")
        UserDefaults.standard.set("Naver", forKey: "LoginMethod")
        self.navigationController?.pushViewController(MainViewController(), animated: true)
        
        //로그인 성공 시, 메인뷰로 이동
//        naverLoginInstance?.requestThirdPartyLogin()
    }
    //카카오 로그인 버튼 메서드
    @objc func KakaoBtnTapped() {
        print("KakaoBtnTapped - called()")
        UserDefaults.standard.set("Kakao", forKey: "LoginMethod")
        self.navigationController?.pushViewController(MainViewController(), animated: true)
        KakaoLoginService.isKakaoTalkLogin { success in
            if success {
                //로그인 성공 시, 메인뷰로 이동
                self.navigationController?.pushViewController(MainViewController(), animated: true)
            }
        }
    }
}
//MARK: - NaverLogin
//extension LoginViewController : NaverThirdPartyLoginConnectionDelegate {
//    func naverLogout(completion: @escaping (Bool) -> Void) {
//        naverLoginInstance?.requestDeleteToken()
//    }
//    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
//            print("네이버 로그인 성공")
//            self.naverLoginPaser()
//        }
//        func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
//            print("네이버 토큰\(naverLoginInstance?.accessToken)")
//        }
//        func oauth20ConnectionDidFinishDeleteToken() {
//            print("네이버 로그아웃")
//        }
//        func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
//            print("에러 = \(error.localizedDescription)")
//        }
//    func naverLoginPaser() {
//              guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
//
//              if !accessToken {
//                return
//              }
//
//              guard let tokenType = naverLoginInstance?.tokenType else { return }
//              guard let accessToken = naverLoginInstance?.accessToken else { return }
//              guard let refreshToken = naverLoginInstance?.refreshToken else {return}
//
//              let requestUrl = "https://openapi.naver.com/v1/nid/me"
//              let url = URL(string: requestUrl)!
//
//              let authorization = "\(tokenType) \(accessToken)"
//
//              let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
//
//              req.responseJSON { response in
//
//                guard let body = response.value as? [String: Any] else { return }
//
//                  if let resultCode = body["message"] as? String{
//                      if resultCode.trimmingCharacters(in: .whitespaces) == "success"{
//                          let resultJson = body["response"] as! [String: Any]
//                          let name = resultJson["name"] as? String ?? ""
//                          let email = resultJson["email"] as? String ?? ""
//                          LoginServiceAuth.saveAuthToken(accessToken: "Bearer " + accessToken, refreshToken: "Bearer " + refreshToken, email: email, name: name)
//                          self.navigationController?.pushViewController(MainTapBarController(), animated: true)
//                      }
//                      else{
//                          //실패
//                          print("Invalid JSON Error")
//                      }
//                  }
//              }
//        }
//}
//MARK: - AppleLogin
extension LoginViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    //애플 로그인 버튼 메서드
    @objc func AppleBtnTapped() {
        print("AppleBtnTapped - called()")
        UserDefaults.standard.set("Apple", forKey: "LoginMethod")
        //로그인 성공 시, 메인뷰로 이동
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    func AppleTokenValid() {
        
    }
    // 성공 후 동작
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            //액세스 토큰
            let idToken = credential.identityToken!
            let tokeStr = String(data: idToken, encoding: .utf8) ?? ""
            
            //리프레시 토큰
            guard let code = credential.authorizationCode else { return }
            let codeStr = String(data: code, encoding: .utf8) ?? ""
            //유저정보
            let user = credential.user
            //이름(제공 안하면 빈 옵셔널)
            let fullName = credential.fullName as? String ?? ""
            
            //이메일(제공 안하면 빈 옵셔널)
            let email = credential.email ?? ""
            LoginServiceAuth.saveAuthToken(accessToken: "Bearer " + tokeStr, refreshToken: "Bearer " + codeStr, email: user, name: fullName)
            self.navigationController?.pushViewController(MainViewController(), animated: true)

        }
    }
    // 실패 후 동작
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error")
    }
}
