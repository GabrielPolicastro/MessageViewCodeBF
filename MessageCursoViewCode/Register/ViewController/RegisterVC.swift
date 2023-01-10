//
//  RegisterVC.swift
//  LoginViewCode
//
//  Created by Gabriel Policastro on 05/10/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    var registerScreen:RegisterScreen? //criacao do var register, que herda de RegisterScreen
    var auth:Auth?
    var firestore:Firestore?
    var alert:Alert?
    
    
    override func loadView() { // usado para const elementos de UI
        self.registerScreen = RegisterScreen() //  instancia
        self.view = self.registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerScreen?.configTextFieldDelegate(delegate: self)
        self.registerScreen?.delegate(delegate: self)
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.alert = Alert(controller: self)
        
    }
}

extension RegisterVC:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.registerScreen?.validaTextFields()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterVC:RegisterScreenProtocol {
    func actionBackButton() {
        print("Back button !!")
        self.navigationController?.popViewController(animated: true)
    }
    
    func actionRegisterButton() {
        
        guard let register = self.registerScreen else {return}
        
        self.auth?.createUser(withEmail: register.getEmail(), password: register.getPassword(), completion: { (result, error) in
            
            if error != nil {
                self.alert?.getAlert(titulo: "Atenção", mensagem: "Erro ao cadastrar, verifique os dados e tente novamente")
            } else {
                
                // salvar dados no firebase
                if let idUsuario = result?.user.uid {
                    self.firestore?.collection("Usuarios").document(idUsuario).setData([
                        "nome": self.registerScreen?.getName() ?? "",
                        "email": self.registerScreen?.getEmail() ?? "",
                        "id": idUsuario
                    ])
                    
                    
                }
                
                self.alert?.getAlert(titulo: "Parabéns", mensagem: "Usuário cadastrado com Sucesso", completion: {
                   //self.navigationController?.popViewController(animated: true)
                    let VC = HomeVC()
                    let navVC = UINavigationController(rootViewController: VC)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true, completion: nil)
                })
            }
        })
    }
}

// usuario Aramy, Aramy @gmail.com senha: saudades
