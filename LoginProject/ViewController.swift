//
//  ViewController.swift
//  LoginProject
//
//  Created by 이가을 on 2/26/24.
//

import UIKit

class ViewController: UIViewController {

    // 사용할 요소?들을 메모리에 올림
    // 클로저의 실행문을 사용 -> 코드가 정리됨
    // lazy var? -> view.addSubview(view)를 클로저의 실행문 내에 선언하기 위함 -> 이유는,, 확인 필요
    
    // 이메일 입력 텍스트 뷰
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.frame.size.height = 48
        view.backgroundColor = UIColor.darkGray // 백그라운드 색상 설정
        view.layer.cornerRadius = 5 // 모서리 설정
        view.clipsToBounds = true
        view.addSubview(emailInfoLabel)
        view.addSubview(emailTextField)
        return view
    }()
    
    // 이메일 입력 문구 레이블
    private var emailInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Email or Phone number"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    // 이메일 입력 텍스트 필드
    private lazy var emailTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear // 투명
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none // 첫글자 대문자 설정 X
        tf.autocorrectionType = .no // 자동 수정 설정 X
        tf.spellCheckingType = .no // 맞춤법 검사 설정 X
        tf.keyboardType = .emailAddress
        
        return tf
    }()
    
    // 비밀번호 입력 텍스트 뷰
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.frame.size.height = 48
        view.backgroundColor = UIColor.darkGray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addSubview(passwordInfoLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordSecureBtn)
        return view
    }()
    
    // 비밀번호 입력 문구 레이블
    private var passwordInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    // 비밀번호 입력 텍스트 필드
    private lazy var passwordTextField: UITextField = {
        var tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear // 투명
        tf.textColor = .white
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true // 입력된 값 복사 방지 및 *로 표시
        tf.clearsOnBeginEditing = false // 편집 시 기존 텍스트필드값 제거
        
        return tf
    }()
    
    // 패스워드 입력 뷰에 "표시" 버튼 - 비밀번호 가리기 기능
    private let passwordSecureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Show", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.addTarget(self, action: #selector(passwordSecureModeSetting), for: .touchUpInside)
        return btn
    }()
    
    // 로그인 버튼
    private let loginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 7
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.isEnabled = false // 버튼 비활성화
        
        return btn
    }()
    
    // set stack view
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView, loginBtn])
        sv.axis = .vertical // 축 설정
        sv.spacing = 18
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    // 비밀번호 재설정 버튼
    private let passwordResetBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Reset Password", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    // 3개의 각 텍스트필드 및 로그인 버튼의 높이 설정
    private let textViewHeight: CGFloat = 48
    
    // 애니메이션을 위한 오토레이아웃을 담을 수 있는 변수 생성
    lazy var emailInfoLabelCenterYConstraint = emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor)
    lazy var passwordInfoLabelCenterYConstraint = passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor)
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 델리게이트 설정
        // 왜? -> 이 설정을 해줘야지만 viewController가 대리자 역할을 하게 되고,
        // 대리자 역할을 해야지만 확장한 viewController에서 생성한 함수들이 작동을 함
        // 정확한 프로토콜 채택 및 대리자 메커니즘 확인 필요
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setUI()
    }

    
    func setUI(){
        view.backgroundColor = UIColor.black
        
        // 기본?메인?view에 하위 UIView를 넣어줌
        view.addSubview(stackView) // stackView안에 생성한 하위 뷰들이 있기 때문에 stackView만 넣어줌
        view.addSubview(passwordResetBtn)
        
        // ⭐️⭐️⭐️ 해당 속성을 false 해줘야만 코드로 UI 설정이 가능함
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordSecureBtn.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        passwordResetBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 레이아웃 설정 방식 1
        // 이메일 입력 안내 문구 레이아웃 설정
        // emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8).isActive = true
        // emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8).isActive true
        // emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor).isActive = true
        

        // 레이아웃 설정 방식 2
        // NSLayoutConstraint -> 방식1과 아래 방식 두가지가 있음 NSLayoutConstraint를 사용한 아래 방식이 훨씬 간결
        NSLayoutConstraint.activate([
            // 이메일 입력 안내 문구 레이아웃 설정
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8)
            , emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8)
            , emailInfoLabelCenterYConstraint // 애니메이션 효과를 주기 위한 동적 변수로 레이아웃 설정
            
            // 이메일 텍스트 필드 레이아웃 설정
            , emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8)
            , emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8)
            , emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15)
            , emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 2)
            
            // 비밀번호 입력 안내 문구 레이아웃 설정
            , passwordInfoLabel.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8)
            , passwordInfoLabel.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: 8)
            , passwordInfoLabelCenterYConstraint // 애니메이션 효과를 주기 위한 동적 변수로 레이아웃 설정
            
            // 비밀번호 텍스트 필드 레이아웃 설정
            , passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8)
            , passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: 8)
            , passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15)
            , passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: 2)
            
            // 비밀번호 표시 버튼 레이아웃 설정
            , passwordSecureBtn.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8)
            , passwordSecureBtn.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15)
            , passwordSecureBtn.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -15)
            
            // stackView 레이아웃 설정
            , stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
            , stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            , stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            , stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            , stackView.heightAnchor.constraint(equalToConstant: textViewHeight*3 + 36)
            
            // 비밀번호 표시 버튼 레이아웃 설정
            , passwordResetBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
            , passwordResetBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            , passwordResetBtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
            , passwordResetBtn.heightAnchor.constraint(equalToConstant: textViewHeight)
        ])
    }
    
    @objc func resetBtnTapped(){
        // print(#function)
        
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
    
    @objc func passwordSecureModeSetting(){
        //print(#function)
        passwordTextField.isSecureTextEntry.toggle() // 개편한 함수,,
    }
}

// 기존 ViewController에서 프로토콜을 채택할 수 있지만
// 코드가 복잡해지기 때문에 ViewController를 확장하고(extension) 확장한 ViewController에서 프로토콜 채택!
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        
        if textField == emailTextField {
            print("emailTextField Clicked")
            emailTextFieldView.backgroundColor = UIColor.gray
            emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
            emailInfoLabelCenterYConstraint.constant = -13
        }
        if textField == passwordTextField {
            print("passwordTextField Clicked")
            passwordTextFieldView.backgroundColor = UIColor.gray
            passwordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            passwordInfoLabelCenterYConstraint.constant = -13
        }
        
        // 애니메이션 호과를 주기위한 함수 -> 일단은 이렇게 사용하는 것만 알고 나중에 다시 확인
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextFieldView.backgroundColor = UIColor.darkGray
            if emailTextField.text == "" { // 빈칸이면 원래대로 돌리기
                emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
                emailInfoLabelCenterYConstraint.constant = 0
            }
        }
        if textField == passwordTextField {
            passwordTextFieldView.backgroundColor = UIColor.darkGray
            if passwordTextField.text == "" {
                passwordInfoLabel.font = UIFont.systemFont(ofSize: 18)
                passwordInfoLabelCenterYConstraint.constant = 0
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
}



