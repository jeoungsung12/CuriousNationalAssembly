//
//  IntroViewController.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/20.
//

import Foundation
import UIKit
import SnapKit
import SwiftKeychainWrapper
//인트로 화면을 2~3초간 보여주고 로그인 뷰로 이동
class IntroViewController : UIViewController {
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
            alpha: 1.0
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
        //CuriousNationalAssembly
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
            alpha: 1.0
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
//            make.leading.equalToSuperview().inset(0)
        }
        SecondView.snp.makeConstraints{ (make) in
            make.top.equalTo(FirstView.snp.bottom).offset(10)
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IntroViewController - called()")
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        setupView()
        //화면을 2초간 보여주고 로그인 페이지로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }
}
//오토레이아웃
extension IntroViewController {
    //제목 뷰를 스택뷰, 스냅킷을 활용해 오토레이아웃
    func setupView() {
        self.view.addSubview(TitleView)
        //Snapkit 오토레이아웃
        TitleView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(self.view.frame.height / 2.5)
            make.leading.trailing.equalToSuperview().inset(self.view.frame.width / 5)
        }
    }
}
