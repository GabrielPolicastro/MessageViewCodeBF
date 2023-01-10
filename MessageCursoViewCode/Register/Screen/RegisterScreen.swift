//
//  RegisterScreen.swift
//  LoginViewCode
//
//  Created by Gabriel Policastro on 05/10/22.
//

import UIKit

protocol RegisterScreenProtocol: AnyObject {
    
    func actionBackButton()
    func actionRegisterButton()
    
}

class RegisterScreen: UIView {
    
    private weak var delegate: RegisterScreenProtocol?
    
    func delegate(delegate:RegisterScreenProtocol?) {  // configuracao que usaremos na ViewController
        self.delegate = delegate
    }
    
    
    lazy var backButton:UIButton = { // 3a criacao do botao
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false // deixar ele desabilitado, é necessario para introduzir as constraints
        button.setImage(UIImage(named: "b2"), for: .normal)
        button.addTarget(self, action: #selector(self.tappedBackButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var imageAddUser:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "usuario2")
        image.contentMode = .scaleAspectFit
        // image.backgroundColor = .red
        return image
    }()
    
    lazy var nameTextField:UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.placeholder = "Digite seu nome"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textColor = .darkGray
        return tf
    }()
    
    
    lazy var emailTextField:UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.placeholder = "Digite seu e-mail"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textColor = .darkGray
        return tf
    }()
    
    lazy var passwordTextField:UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.placeholder = "Digite sua senha"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textColor = .darkGray
        return tf
    }()
    
    lazy var registerButton:UIButton = { // 3a criacao do botao
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("cadastrar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7.5
        button.backgroundColor = UIColor(red: 3/255, green: 58/255, blue: 51/255, alpha: 1.0)
        button.addTarget(self, action: #selector(self.tappedRegisterButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) { // primeiro passo na REG SCREEN
        super.init(frame: frame)
        self.configBackGround()  // 2a
        self.configSuperView()  // 4a
        self.setUpConstraints() // 6a
        self.configButtonEnable(false)
    }
    
    private func configSuperView(){   // 3a
        self.addSubview(self.backButton)
        self.addSubview(self.imageAddUser)
        self.addSubview(self.nameTextField)
        self.addSubview(self.emailTextField)
        self.addSubview(self.passwordTextField)
        self.addSubview(self.registerButton)
        
    }
    
    private func configBackGround(){  // 1a
        self.backgroundColor = UIColor(red: 24/255, green: 117/255, blue: 104/255, alpha: 1.0)
    }
    
    public func configTextFieldDelegate(delegate: UITextFieldDelegate){
        self.nameTextField.delegate = delegate
        self.emailTextField.delegate = delegate
        self.passwordTextField.delegate = delegate
    }
    
    @objc private func tappedBackButton(){
        self.delegate?.actionBackButton()
    }
    
    @objc private func tappedRegisterButton(){
        self.delegate?.actionRegisterButton()
    }
    
    public func validaTextFields(){
        let name:String = self.nameTextField.text ?? ""
        let email:String = self.emailTextField.text ?? ""
        let password:String = self.passwordTextField.text ?? ""
        
        if !name.isEmpty && !email.isEmpty && !password.isEmpty {
            self.configButtonEnable(true)
        } else {
            self.configButtonEnable(false)
        }
    }
    
    private func configButtonEnable(_ enable:Bool) {
        if enable {
            self.registerButton.setTitleColor(.white, for: .normal)
            self.registerButton.isEnabled = true
        } else {
            self.registerButton.setTitleColor(.lightGray, for: .normal)
            self.registerButton.isEnabled = false
        }
    }
    
    public func getName() -> String {
        return self.nameTextField.text ?? ""
    }
    
    public func getEmail() -> String {
        return self.emailTextField.text ?? ""
    }
    
    public func getPassword() -> String {
        return self.passwordTextField.text ?? ""
    }
    
    required init?(coder: NSCoder) {     // irrelevante
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints(){  // 5
        NSLayoutConstraint.activate([
            
            self.imageAddUser.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.imageAddUser.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageAddUser.widthAnchor.constraint(equalToConstant: 150),
            self.imageAddUser.heightAnchor.constraint(equalToConstant: 150),

            
            self.backButton.topAnchor.constraint(equalTo: self.imageAddUser.topAnchor),
            self.backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.backButton.widthAnchor.constraint(equalToConstant: 30),
            self.backButton.heightAnchor.constraint(equalToConstant: 30),
            
            
            self.nameTextField.topAnchor.constraint(equalTo: self.imageAddUser.bottomAnchor, constant: 10),
            self.nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            self.nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            
            self.emailTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 15),
            self.emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20),
            self.emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 45),

            
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 15),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor),
            self.passwordTextField.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor),
            
            
            self.registerButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 15),
            self.registerButton.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
            self.registerButton.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor),
            self.registerButton.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor),

                        
        ])
    }
    
}


