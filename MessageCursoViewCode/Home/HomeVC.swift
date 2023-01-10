//
//  HomeVC.swift
//  MessageCursoViewCode
//
//  Created by Gabriel Policastro on 27/10/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore



class HomeVC: UIViewController  {

    
    var auth:Auth?
    var db:Firestore?
    var idUsuarioLogado:String?
    
    var screenContact:Bool?
    var emailUsuarioLogado:String?
    var alert:Alert?
    
    var screen:HomeScreen?
    
    var contato:ContatoController?
    var listaContact:[Contact] = []
    var listaConversas:[Conversation] = []
    var conversasListener:ListenerRegistration?
    
    
    override func loadView() {
        self.screen = HomeScreen()
        self.view = self.screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = CustomColor.appLight
        self.configHomeView()
        self.configCollectionView()
        self.configAlert()
        self.configIdentifierFirebase()
        self.configContato()
        self.addListenerRecuperarConversa()
        
    }
    
    private func configHomeView(){
        self.screen?.navView.delegate(delegate: self)
    }
    
    private func configCollectionView(){
        self.screen?.delegateCollectionView(delegate: self, dataSource: self)
    }
    
    private func configAlert(){
        self.alert = Alert(controller: self)
    }
    
    private func configIdentifierFirebase(){
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
        
        // recuperar id usuario logado
        
        if let currentUser = auth?.currentUser{
            self.idUsuarioLogado = currentUser.uid
            self.emailUsuarioLogado = currentUser.email
        }
    }
    
    private func configContato(){
        self.contato = ContatoController()
        self.contato?.delegate(delegate: self)
    }
    
func addListenerRecuperarConversa() {
        
    if let idUsuarioLogado = auth?.currentUser?.uid {
        self.conversasListener = db?.collection("conversas").document(idUsuarioLogado).collection("ultimas_conversas").addSnapshotListener({
            querSnapshot, error in
            
            if error == nil {
                
                self.listaConversas.removeAll()
                
                if let snapshot = querSnapshot {
                    for document in snapshot.documents{
                        let dados = document.data()
                        self.listaConversas.append(Conversation(dicionario: dados))
                    }
                    self.screen?.reloadCollectionView()
                }
            }
            
        })
    }
}
    
    func getContato() {
        self.listaContact.removeAll()  //
        self.db?.collection("Usuarios").document(self.idUsuarioLogado ?? "").collection("Contatos").getDocuments(completion: {
            snapShotResultado, error in
            
            if error != nil {
                print("error getContato")
                return
            }
            
            if let snapshot = snapShotResultado {
                
                for document in snapshot.documents{
                    let dadosContato = document.data()
                    self.listaContact.append(Contact(dicionario: dadosContato))
                }
                self.screen?.reloadCollectionView()
            }
        })
    }
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if self.screenContact ?? false{
            return self.listaContact.count + 1
        } else {
            return self.listaConversas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.screenContact ?? false{
            if indexPath.row == self.listaContact.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageLastCollectionViewCell.identifier, for: indexPath)
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as? MessageDetailCollectionViewCell
                cell?.setupViewContact(contact: self.listaContact[indexPath.row])
                return cell ?? UICollectionViewCell()
            }
        }else{
            //Celula de Conversas
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as? MessageDetailCollectionViewCell
            cell?.setUpViewConversation(conversation: self.listaConversas[indexPath.row])
            return cell ?? UICollectionViewCell()
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if self.screenContact ?? false{
//            if indexPath.row == self.listaContact.count{
//                self.alert?.addContact(completion: { value in
//                    self.contato?.addContact(email: value, emailUsuarioLogado: self.emailUsuarioLogado ?? "", idUsuario: self.idUsuarioLogado ?? "")
//                })
//
//            }else{
//               // let contato = self.listaContact[indexPath.row]
//                let VC:ChatViewController = ChatViewController()
//                //VC.contato = contato
//                self.navigationController?.pushViewController(VC, animated: true)
//            }
//
//        }else{
//            //to do
//
//        }
//    }
        
        if self.screenContact ?? false{
            if indexPath.row == self.listaContact.count{
                self.alert?.addContact(completion: { value in
                    self.contato?.addContact(email: value, emailUsuarioLogado: self.emailUsuarioLogado ?? "", idUsuario: self.idUsuarioLogado ?? "")
                })
                
            }else{
                let VC:ChatViewController = ChatViewController()
                VC.contato = self.listaContact[indexPath.row]
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else{
            
            let VC:ChatViewController = ChatViewController()
            let dados = self.listaConversas[indexPath.row]
            let contato:Contact = Contact(id: dados.idDestinatario ?? "", nome: dados.nome ?? "")
            VC.contato = contato
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension HomeVC:NavViewProtocol {
    
    func typeScreenMessage(type: TypeConversationOrContact) {
        switch type {
        case .contact:
            self.screenContact = true
            self.getContato()
            self.conversasListener?.remove()
        case .conversation:
            self.screenContact = false
            self.addListenerRecuperarConversa()
            self.screen?.reloadCollectionView()
        }
    }
}

extension HomeVC:ContatoProtocol {
    func alertStateError(titulo: String, message: String) {
        self.alert?.getAlert(titulo: titulo, mensagem: message)
    }
    
    func successContato() {
        self.alert?.getAlert(titulo: "Ebaaaaa", mensagem: "Usuario cadastrado com sucesso", completion: {
            self.getContato()
        })
    }
}
