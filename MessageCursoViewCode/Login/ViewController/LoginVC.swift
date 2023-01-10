//
//  ViewController.swift
//  LoginViewCode
//
//  Created by Gabriel Policastro on 29/09/22.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    var loginScreen: LoginScreen?
    var auth:Auth?
    var alert:Alert?
    
    override func loadView() { // responsavel pela criacao de uma view, ou uma referencia de uma view com a outra
        self.loginScreen = LoginScreen()
        self.view = self.loginScreen // estou dizendo que a view da ViewController eh igual a view q eu criei a loginScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginScreen?.delegate(delegate: self)
        self.loginScreen?.configTextFieldDelegate(delegate: self)
        self.auth = Auth.auth()
        self.alert = Alert(controller: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension LoginVC: LoginScreenProtocol {
    func actionLoginButton() {
        
        guard let login = self.loginScreen else {return}
        
        self.auth?.signIn(withEmail: login.getEmail(), password: login.getPassword(), completion: { (usuario, error) in
            if error != nil {
                self.alert?.getAlert(titulo: "Atenção", mensagem: "Dados Incorretos, verifique e tente novamente")
            } else {
                if usuario == nil {
                    self.alert?.getAlert(titulo: "Atenção", mensagem: "Tivemos um problema inesperado, tente novamente mais tarde")
                } else {
//                    self.alert?.getAlert(titulo: "Parabéns", mensagem: "Usuário logado com sucesso!!!!!")
                    let VC = HomeVC()
                    let navVC = UINavigationController(rootViewController: VC)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true, completion: nil)
                }
            }
        })
    }
    
    func actionRegisterButton() {
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.loginScreen?.validaTextFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
