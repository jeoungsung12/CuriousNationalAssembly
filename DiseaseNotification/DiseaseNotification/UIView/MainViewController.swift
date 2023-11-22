//
//  ViewController.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/20.
//

import UIKit
import Foundation
import WebKit
class MainViewController: UIViewController, WKNavigationDelegate {
    var WeatherView: WKWebView!
    var loadingIndicator: UIActivityIndicatorView!
    private let TitleView : UIView = {
       let view = UIView()
        let Title = UILabel()
        Title.text = "궁금한국회"
        Title.font = UIFont.boldSystemFont(ofSize: 25)
        Title.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        Title.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let Title2 = UILabel()
        Title2.text = "CuriousNationalAssembly"
        Title2.font = UIFont.boldSystemFont(ofSize: 15)
        Title2.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        Title2.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(Title)
        view.addSubview(Title2)
        //SnapKit으로 오토레이아웃
        Title.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(50)
        }
        Title2.snp.makeConstraints{ (make) in
            make.top.equalTo(Title.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(-10)
        }
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //로그아웃 버튼
        let LogoutBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(LogoutBtnTapped))
        navigationItem.rightBarButtonItems = [LogoutBtn]
        self.view.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        // 로딩 인디케이터 생성
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
        setupView()
    }
    @objc func LogoutBtnTapped() {
        print("LogoutBtnTapped - called()")
        //팝업 -> 로그아웃 시킴
        let Alert = UIAlertController(title: "로그아웃", message: nil, preferredStyle: .alert)
        let Ok = UIAlertAction(title: "확인", style: .default){_ in
            LoginServiceAuth.logoutUser()
        }
        let Cancel = UIAlertAction(title: "취소", style: .default){_ in }
        Alert.addAction(Ok)
        Alert.addAction(Cancel)
        present(Alert, animated: true)
    }
    //검색 통신 메서드
    @objc func SearchBtnTapped() {
        print("SearchBtnTapped - called()")
        if local.text == "" {
            local.text = "진행입법"
        }
        UserDefaults.standard.set(local.text, forKey: "title")
        let title = local.text
        local.text = ""
        switch title{
        case "청원현황":
            self.navigationController?.pushViewController(PetitionTableViewController(), animated: true)
        case "진행입법":
            self.navigationController?.pushViewController(ProgressingTableView(), animated: true)
        case "처리결과":
            self.navigationController?.pushViewController(ResultLawViewController(), animated: true)
        default:
            self.navigationController?.pushViewController(ProgressingTableView(), animated: true)
        }
    }
    //지역 전역변수
    let local = UITextField()
    func setupView() {
        let StackView = UIStackView()
        StackView.spacing = 10
        StackView.distribution = .fill
        StackView.axis = .vertical
        StackView.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        let FirstView = UIView()
        FirstView.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        let view = UIView()
        view.backgroundColor = .white
        //검색
        let Title = UIView()
        Title.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        Title.addSubview(TitleView)
        TitleView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(self.view.frame.width / 3.5)
            make.height.equalTo(60)
        }
        let SearchBtn = UIButton(type: .system)
        SearchBtn.tintColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        SearchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        SearchBtn.backgroundColor = .white
        SearchBtn.addTarget(self, action: #selector(SearchBtnTapped), for: .touchUpInside)
        view.addSubview(SearchBtn)
        SearchBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(20)
        }
        self.local.backgroundColor = .white
        local.placeholder = "청원현황/처리결과/진행입법"
        view.addSubview(local)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        self.local.snp.makeConstraints{ (make) in
            make.leading.equalTo(SearchBtn.snp.trailing).offset(30)
            make.top.equalToSuperview().inset(15)
        }
        FirstView.addSubview(Title)
        FirstView.addSubview(view)
        Title.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(100)
        }
        view.snp.makeConstraints{ (make) in
            make.top.equalTo(Title.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let ExplainView = UIStackView()
        ExplainView.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        ExplainView.distribution = .fill
        ExplainView.spacing = 60
        ExplainView.axis = .vertical
        ExplainView.layer.cornerRadius = 10
        ExplainView.layer.masksToBounds = true
        //제목
        let TitleLabel = UITextView()
        TitleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        TitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        TitleLabel.textAlignment = .left
        TitleLabel.text = "열린국회에서 제공하는 공공데이터를 기반합니다. \n\n청원현황 / 처리결과 / 진행입법 등 대해 검색이 가능\n합니다."
        TitleLabel.isEditable = false
        TitleLabel.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        ExplainView.addArrangedSubview(TitleLabel)
        TitleLabel.snp.makeConstraints{ (make) in
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        //내용
        WeatherView = WKWebView(frame: self.view.bounds)
        WeatherView.navigationDelegate = self
        WeatherView.layer.cornerRadius = 10
        WeatherView.layer.masksToBounds = true
        WeatherView.backgroundColor = .white
        WeatherView.contentMode = .scaleAspectFit
        ExplainView.addArrangedSubview(WeatherView)
        WeatherView.snp.makeConstraints{(make) in
            make.top.equalTo(TitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        if let url = URL(string: "https://www.naon.go.kr"){
            // 웹 페이지를 로드하기 전에 로딩 화면 표시
            loadingIndicator.startAnimating()
            // 웹 페이지를 로드
            let request = URLRequest(url:url)
            WeatherView.load(request)
        }
        
        StackView.addArrangedSubview(FirstView)
        StackView.addArrangedSubview(ExplainView)
        self.view.addSubview(StackView)
        StackView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 18)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        FirstView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(self.view.frame.height / 5)
        }
        ExplainView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    // 웹 페이지 로딩이 시작될 때 호출되는 메서드
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 로딩 화면 표시
        loadingIndicator.startAnimating()
    }
    // 웹 페이지 로딩이 종료될 때 호출되는 메서드
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 로딩 화면 숨김
        loadingIndicator.stopAnimating()
    }
}

