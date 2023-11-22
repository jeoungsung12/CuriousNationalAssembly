//
//  ResultLawViewController.swift
//  DiseaseNotification
//
//  Created by 정성윤 on 2023/11/22.
//

import Foundation
import UIKit
import UserNotifications
struct ResultPost: Decodable {
    let bill_name : String //의안명
    let proposer : String //제안자
    let committee : String //소관위원회
    let bill_no : String //의안번호
    let proc_result : String //본회의심의결과
    let proc_dt : String //의결일
}
class ResultLawViewController : UIViewController {
    var tableView = UITableView()
    var currentPage = 0
    let activityIndicator = UIActivityIndicatorView(style: .large) // 로딩 인디케이터 뷰
    var posts : [ResultPost] = [
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        let title = UserDefaults.standard.string(forKey: "title")
        self.title = title
        if let navigationBar = navigationController?.navigationBar {
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]}
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(
            red: CGFloat((0x17ACFF & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((0x17ACFF & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(0x17ACFF & 0x0000FF) / 255.0,
            alpha: 1.0
        )
        // 로딩 인디케이터 뷰 초기 설정
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        setTableview()
        setUpViews()
        // 처음에 초기 데이터를 불러옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
                guard let self = self else { return }
                    
                if let newPosts = newPosts {
                    // 초기 데이터를 posts 배열에 추가
                    self.posts += newPosts
                        
                    // 테이블 뷰 갱신
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Initial data fetch - Success")
                } else if let error = error {
                // 오류 처리
                print("Error fetching initial data: \(error.localizedDescription)")
            }
        }
    }
    func setUpViews() {
        let StackView = UIStackView()
        StackView.distribution = .fill
        StackView.backgroundColor = .white
        StackView.axis = .vertical
        StackView.addArrangedSubview(tableView)
        self.view.addSubview(StackView)
        StackView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.bottom.equalToSuperview().offset(-0)
        }
        tableView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
    }
    var isScrolling = false
    var lastContentOffsetY : CGFloat = 0
    var isScrollingDown = false
    var loadNextPageCalled = false // loadNextPage가 호출되었는지 여부를 추적
    var updatePageCalled = false // updatePageCalled가 호출되었는지 여부를 추적
    var isLoading = false  // 중복 로드 방지를 위한 플래그
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let screenHeight = scrollView.bounds.size.height
        let threshold: CGFloat = -150 // 이 임계값을 조절하여 스크롤 감지 정확도를 조절할 수 있습니다

        if contentOffsetY >= 0 {
            isScrollingDown = true
        } else {
            isScrollingDown = false
        }

        if isScrollingDown && contentOffsetY + screenHeight >= scrollView.contentSize.height {
            if !loadNextPageCalled { // 호출되지 않은 경우에만 실행
                loadNextPageCalled = true // 호출되었다고 표시
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating() // 로딩 인디케이터 시작
                loadNextPage()
            }
        } else if !isScrollingDown && contentOffsetY < threshold {
            if !updatePageCalled { //호출되지 않은 경우에만 실행
                updatePageCalled = true // 호출되었다고 표시
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating() // 로딩 인디케이터 시작
                updatePage()
            }
        }
    }
    //새로운 페이지 새로고침
    @objc func updatePage() {
        print("updatePage() - called")
        if isLoading {
                return // 이미 로딩 중이면 중복 로딩 방지
            }
            
        isLoading = true
        currentPage = 0 //처음 페이지부터 다시 시작
        //스크롤을 감지해서 인디케이터가 시작되면 종료가 되면 로딩인디케이터를 멈처야함
        // 서버에서 다음 페이지의 데이터를 가져옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            self.isLoading = false // 로딩 완료
            // 데이터를 비워줌
            self.posts.removeAll()
            if let newPosts = newPosts {
                // 새로운 데이터를 기존 데이터와 병합
                self.posts += newPosts
                
                // 테이블 뷰 갱신
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("updatePage - Success")
            } else if let error = error {
                // 오류 처리
                print("Error fetching next page: \(error.localizedDescription)")
            }
            // 로딩 인디케이터 멈춤
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            self.updatePageCalled = false // 데이터가 로드되었으므로 호출 플래그 초기화
        }
    }
    //스크롤이 아래로 내려갈때 기존페이지 + 다음 페이지 로드
    func loadNextPage() {
        print("loadNextPage() - called")
        currentPage += 1
        if isLoading {
                return // 이미 로딩 중이면 중복 로딩 방지
            }
        isLoading = true
        //스크롤을 감지해서 인디케이터가 시작되면 통신이 완료되면 종료해야함.

        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            self.isLoading = false // 로딩 완료
            if let newPosts = newPosts {
                self.posts += newPosts
                // 테이블뷰 갱신
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("loadNextPage - Success")
            } else if let error = error {
                print("Error fetching next page: \(error.localizedDescription)")
            }
            // 로딩 인디케이터 멈춤
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            self.isLoading = false
            self.loadNextPageCalled = false // 데이터가 로드되었으므로 호출 플래그 초기화
        }
    }
}
extension ResultLawViewController : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func setTableview() {
        //UITableViewDelegate, UITableDataSource 프로토콜을 해당 뷰컨트롤러에서 구현
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        //UITableView에 셀 등록
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .white
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let post = posts[indexPath.row]
        cell.titleLabel.text = post.bill_name
        cell.commentLabel.text = "의결일 : " + post.proc_dt
        cell.dangerView.text = "심의결과 : " + "\(post.proc_result)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        showPostDetail(post: post)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //셀을 선택했을 때 해당 게시물의 상세 내용을 보여주기 위함
    func showPostDetail(post: ResultPost){
        let detailViewController = ResultLawDetailViewController(post: post)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    //법률안 심사 및 처리(계류의안)
    func fetchPosts(page: Int, completion: @escaping ([ResultPost]?, Error?) -> Void) {
        let urls = "https://open.assembly.go.kr/portal/openapi/nxjuyqnxadtotdrbw?KEY=9aabb437e71540e5a02aee015757865e&Type=json&plndex=\(page)&pSize=20&AGE=21"
        let urlss = URL(string: urls)
        // URLRequest 생성
        var request = URLRequest(url: urlss!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("에러 : \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, nil)
                return
            }
            print(String(data: data, encoding: .utf8) ?? "데이터 출력 실패")

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let nknalejkafmvgzmpt = json?["nxjuyqnxadtotdrbw"] as? [[String: Any]],
                   let row = nknalejkafmvgzmpt.last?["row"] as? [[String: Any]] {
                    print("심사 결과 : \(nknalejkafmvgzmpt)")
                    var posts = [ResultPost]()
                    for item in row {
                        if let billName = item["BILL_NAME"] as? String,
                           let proposer = item["PROPOSER"] as? String,
                           let committee = item["CURR_COMMITTEE"] as? String,
                           let billNo = item["BILL_NO"] as? String
                            ,
                            let proc_result = item["PROC_RESULT_CD"] as? String,
                           let proc_dt = item["PROC_DT"] as? String
                        {
                            if(proc_result == "원안가결") {
                                LocalNotificationHelper.scheduleNotification(title: "궁금한국회", body: "\(billName)이 가결되었습니다. 어플에서 확인해보세요!", seconds: 20, identifier: "identifier")
                            }
                            let post = ResultPost(bill_name: billName, proposer: proposer, committee: committee, bill_no: billNo, proc_result: proc_result, proc_dt: proc_dt)
                            posts.append(post)
                        }
                    }
                    completion(posts, nil)
                }
            } catch let error as DecodingError {
                print("JSON 디코딩 에러: \(error)")
                completion(nil, error)
            } catch {
                print("기타 에러: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
}
