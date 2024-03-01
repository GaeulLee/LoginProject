//
//  ViewController.swift
//  LoginProject
//
//  Created by 이가을 on 2/26/24.
//

import UIKit

final class ViewController: UIViewController {
    
    // ⭐️ 따로 분리한 view는 인스턴스 생성하고 변수에 담아 사용
    private let loginView = LoginView()
    
    // ⭐️ viewDidLoad보다 먼저 실행됨!
    override func loadView() {
        // ⭐️ 기존 view를 loginView로 교체
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAddTarget()
    }
    
    // ⭐️ view가 분리되었을 때, add target은 이런 방식으로 VC에 구현
    func setUpAddTarget() {
        loginView.loginBtn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        loginView.passwordResetBtn.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
    }

    @objc func loginBtnTapped() {
        print(#function)
    }
    
    
    @objc func resetBtnTapped(){
        // alert 창 띄우기
        let alert = UIAlertController(title: "Change Password", message: "비밀번호를 바꾸시겠습니까?", preferredStyle: .alert) //  alert 창 설정
        let success = UIAlertAction(title: "OK" , style: .default) { action in //  alert 창 안에 들어갈 액션 설정
            print("OK Clicked")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { cancel in
            print("Cancel Clicked")
        }
        
        alert.addAction(success) // 설정한 액션을 alert창에 넣어줌
        alert.addAction(cancel)
        
        present(alert, animated: true) { // 만든 alert 창 띄어줌 (alert 창 띄어주는 것도 다음 화면으로 넘어가는 것임)
            print("alert")
        }
    }
}
