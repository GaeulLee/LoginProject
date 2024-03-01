//
//  LoginView.swift
//  LoginProject
//
//  Created by 이가을 on 3/1/24.
//

import UIKit

// view와 관련된 모든 코드 (delegate 포함!)
class LoginView: UIView {
    
    // MARK: - 이메일 입력 텍스트 뷰
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
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return tf
    }()
    
    // MARK: - 비밀번호 입력 텍스트 뷰
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
        tf.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
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
    let loginBtn: UIButton = {
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
        //btn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        // -> 여기에 구현하면 안됨 VC에 구현되어야 함
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
    let passwordResetBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("Reset Password", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        //btn.addTarget(self, action: #selector(resetBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    // 3개의 각 텍스트필드 및 로그인 버튼의 높이 설정
    private let textViewHeight: CGFloat = 48
    
    // 애니메이션을 위한 오토레이아웃을 담을 수 있는 변수 생성
    lazy var emailInfoLabelCenterYConstraint = emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor)
    lazy var passwordInfoLabelCenterYConstraint = passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor)
    
    
    // MARK: - UIView의 생성자 호출, 필수 생성자도 재정의 해야 함!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        addViews()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        backgroundColor = UIColor.black
    }
    
    func addViews() {
        [stackView, passwordResetBtn].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        emailInfoLabelConstraints()
        emailTextFieldConstraints()
        passwordInfoLabelConstraints()
        passwordTextFieldConstraints()
        passwordSecureButtonConstraints()
        stackViewConstraints()
        passwordResetButtonConstraints()
    }
    
    private func emailInfoLabelConstraints() {
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8),
            emailInfoLabelCenterYConstraint
        ])
    }
    
    private func emailTextFieldConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15),
            emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: -2),
            emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8)
        ])
    }
    
    private func passwordInfoLabelConstraints() {
        passwordInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordInfoLabel.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8),
            passwordInfoLabel.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            passwordInfoLabelCenterYConstraint
        ])
    }
    
    private func passwordTextFieldConstraints() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -2),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8)
        ])
        
    }
    
    private func passwordSecureButtonConstraints() {
        passwordSecureBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordSecureBtn.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15),
            passwordSecureBtn.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -15),
            passwordSecureBtn.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8)
        ])
        
    }
    
    private func stackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: textViewHeight*3 + 36)
        ])
    }
    
    private func passwordResetButtonConstraints() {
        passwordResetBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordResetBtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            passwordResetBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            passwordResetBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            passwordResetBtn.heightAnchor.constraint(equalToConstant: textViewHeight)
        ])
    }
    
    // MARK: - 이메일텍스트필드, 비밀번호 텍스트필드 두가지 다 채워져 있을때, 로그인 버튼 빨간색으로 변경
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            loginBtn.backgroundColor = .clear
            loginBtn.isEnabled = false
            return
        }
        loginBtn.backgroundColor = .red
        loginBtn.isEnabled = true
    }
    
    // MARK: - 비밀번호 가리기 모드 켜고 끄기
    @objc func passwordSecureModeSetting() {
        //print(#function)
        passwordTextField.isSecureTextEntry.toggle() // 개편한 함수,,
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.endEditing(true)
    }
    
}

// MARK: - 확장
extension LoginView: UITextFieldDelegate {
    
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
