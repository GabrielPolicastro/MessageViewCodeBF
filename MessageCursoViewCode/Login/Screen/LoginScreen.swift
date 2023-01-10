//
//  LoginScreen.swift
//  LoginViewCode
//
//  Created by Gabriel Policastro on 03/10/22.
//

import UIKit

protocol LoginScreenProtocol: AnyObject {
    func actionLoginButton()
    func actionRegisterButton()
}

class LoginScreen: UIView {  // A LoginScreen sera responsavel por conter todos os elementos da nossa View
    
    private weak var delegate: LoginScreenProtocol?
    
    func delegate(delegate:LoginScreenProtocol?) {
        self.delegate = delegate
    }
    
    lazy var loginLabel: UILabel = {    ///CRIACAO DO ELEMENTO
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // deixar ele desabilitado,é necessario para introduzir as constraints
        label.textColor = .white // setar a cor da label
        label.font = UIFont.boldSystemFont(ofSize: 40) // setar a font q eu quero
        label.text = "Login"
        return label
    }()
    
    lazy var logoAppImageView: UIImageView = {   // Criacao de elemento
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Logo2")
        image.tintColor = .green
        image.contentMode = .scaleAspectFit
        return image
    } ()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no // autocorrecao do teclado desabilitado
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect // para ficar no estilo default
        tf.keyboardType = .emailAddress // tipo parecido com de email
        tf.placeholder = "Digite seu Email:"
        tf.text = "Djananas@outlook.com"
        tf.textColor = .darkGray
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let ps = UITextField()
        ps.translatesAutoresizingMaskIntoConstraints = false
        ps.autocorrectionType = .no // autocorrecao do teclado desabilitado
        ps.backgroundColor = .white
        ps.borderStyle = .roundedRect // para ficar no estilo default
        ps.keyboardType = .emailAddress // tipo parecido com de email
        ps.isSecureTextEntry = true // esconde os caracteres
        ps.placeholder = "Digite sua senha:"
        ps.text = "sapato"
        ps.textColor = .darkGray
        return ps
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true // ficar redondo
        button.layer.cornerRadius = 7.5
        button.backgroundColor = UIColor(red: 3/255, green: 58/255, blue: 51/255, alpha: 1.0)
        button.addTarget(self, action: #selector(self.tappedLoginButton), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Não tem conta? Cadastre-se", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.tappedRegisterButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {  // precisamos de um metodo construtor para adicionar os elementos
        super.init(frame: frame)
        self.configBackGround() // configurar cor de fundo
        self.configSuperView()//  configurar elementos que estao sendo adicionados a nossa view
        self.setUpConstraints() //  configurar as constraints
        self.configButtonEnable(false)
    }
    
    private func configBackGround(){
        self.backgroundColor = UIColor(red: 24/255, green: 117/255, blue: 104/255, alpha: 1.0)
    }
    
    private func configSuperView(){
        self.addSubview(self.loginLabel) // como estou dentro de uma classe subview, n preciso acessar a propriedade view, já vou direto pra addSubview
        self.addSubview(self.logoAppImageView)
        self.addSubview(self.emailTextField)
        self.addSubview(self.passwordTextField)
        self.addSubview(self.loginButton)
        self.addSubview(self.registerButton)
    }
    
    public func configTextFieldDelegate(delegate: UITextFieldDelegate) { // metodo criado pra conseguir acessar o delegate dos nossos textFields
        self.emailTextField.delegate = delegate
        self.passwordTextField.delegate = delegate
    }
    
    @objc private func tappedLoginButton(){
        self.delegate?.actionLoginButton()
    }
    
    @objc private func tappedRegisterButton(){
        self.delegate?.actionRegisterButton()
    }
    
    public func validaTextFields(){
        
        let email:String = self.emailTextField.text ?? ""
        let password:String = self.passwordTextField.text ?? ""
        
        if !email.isEmpty && !password.isEmpty {
            self.configButtonEnable(true)
        } else {
            self.configButtonEnable(false)
        }
    }
    
    private func configButtonEnable(_ enable:Bool) {
        if enable {
            self.loginButton.setTitleColor(.white, for: .normal)
            self.loginButton.isEnabled = true
        } else {
            self.loginButton.setTitleColor(.lightGray, for: .normal)
            self.loginButton.isEnabled = false
        }
    }
    
    public func getEmail() -> String {
        return self.emailTextField.text ?? ""
    }
    
    public func getPassword() -> String {
        return self.passwordTextField.text ?? ""
    }
    
    
    required init?(coder: NSCoder) {   // se caso algo der errado, ele mostrará o porque
        fatalError("init(coder:) has not been implemented")
    }
    
    // equalTo: basear em um determinado elemento
    
    // constant: me afastar/ aproximar do elemento referente(equalTo)
    
    // equalToConstant: setando um valor fixo para um determinado elemento.
    
    private func setUpConstraints() {  // Configuracao de constraints MANEIRA NATIVA COM NSLAYOUT
        
        NSLayoutConstraint.activate([
            
            self.loginLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.loginLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
            self.logoAppImageView.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: 20),
            self.logoAppImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60),
            self.logoAppImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            self.logoAppImageView.heightAnchor.constraint(equalToConstant: 200),
            
            
            self.emailTextField.topAnchor.constraint(equalTo: self.logoAppImageView.bottomAnchor, constant: 20),
            self.emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 45),

            
            self.passwordTextField.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor, constant: 15),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor),
            self.passwordTextField.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor),
            
            self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 15),
            self.loginButton.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
            self.loginButton.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor),
            self.loginButton.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor),


            self.registerButton.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: 15),
            self.registerButton.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
            self.registerButton.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor),
            self.registerButton.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor),
                                                        
                                                           
        
        ])
    }
    
}
