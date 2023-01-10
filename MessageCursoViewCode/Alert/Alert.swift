//
//  Alert.swift
//  LoginViewCode
//
//  Created by Gabriel Policastro on 13/10/22.
//

import Foundation
import UIKit

class Alert:NSObject {
    
    var controller:UIViewController
    
    init(controller:UIViewController) {
        self.controller = controller
        
    }
    
    func getAlert(titulo:String,mensagem:String,completion:(() -> Void)? = nil) { // vou voltar um void ou um nil
        let alertController = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "Ok", style: .cancel) { acao in
            completion?()
        }
        
        alertController.addAction(cancelar)
        self.controller.present(alertController, animated: true, completion: nil)
        
    }
    
    func addContact(completion:((_ value:String) -> Void)? = nil){
        var _textField:UITextField?
        let alert = UIAlertController(title: "Adicionar Usuario", message: "Digite um email Valido", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Adicionar", style: .default) { (acao) in
            completion?(_textField?.text ?? "")
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            _textField = textField
            textField.placeholder = "Email:"
        })
        self.controller.present(alert, animated: true, completion: nil)
    }
    
}

