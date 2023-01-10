//
//  ChatViewController.swift
//  MessageCursoViewCode
//
//  Created by Gabriel Policastro on 16/11/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import AVFoundation

class ChatViewController: UIViewController {
    
    var listaMensagens:[Message] = []
    var idUsuarioLogado:String?
    var contato:Contact?
    var mensagensListener:ListenerRegistration?
    var auth:Auth?
    var db:Firestore?
    var nomeContato:String?
    var nomeUsuarioLogado:String?
    
    var screen:ChatViewScreen?
    
    override func loadView() {
        self.screen = ChatViewScreen()
        self.view = screen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configDataFirebase()
        self.configChatView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addListenerRecuperarMensagens()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mensagensListener?.remove()
    }
    
    func addListenerRecuperarMensagens(){
        
        if let idDestinatario = self.contato?.id{
            
            mensagensListener = db?.collection("mensagens").document(self.idUsuarioLogado ?? "").collection(idDestinatario).order(by: "data",descending: true).addSnapshotListener({ querySnapshot, error in
                
                //limpar lista
                self.listaMensagens.removeAll()
                
                //Recuperar dados
                if let snapshot = querySnapshot{
                    for document in snapshot.documents{
                        let dados = document.data()
                        self.listaMensagens.append(Message(dicionario: dados))
                    }
                    self.screen?.reloadTableView()
                }
            })
        }
        
        
        
    }

    
    private func configDataFirebase(){
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
        
        
        //Recuperar Id Usuario Logado
        if let id = self.auth?.currentUser?.uid{
            self.idUsuarioLogado = id
            self.recuperarDadosUsuarioLogado()
        }
        
        if let nome = self.contato?.nome{
            self.nomeContato = nome
        }
        
        
    }
    
    
    private func recuperarDadosUsuarioLogado(){
        let usuarios = self.db?.collection("usuarios").document(self.idUsuarioLogado ?? "")
        usuarios?.getDocument(completion: { documentSnapshot, error in
            if error == nil{
                let dados:Contact = Contact(dicionario: documentSnapshot?.data() ?? [:])
                self.nomeUsuarioLogado = dados.nome ?? ""
            }
        })
    }
    
    private func configChatView(){
        self.screen?.configNavView(controller: self)
        self.screen?.configTableView(delegate: self, dataSource: self)
        self.screen?.delegate(delegate: self)
    }
    
    
    @objc func tappedBackButton(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func salvarMensagem(idRemetente:String,idDestinatario:String,mensagem:[String:Any]){
        db?.collection("mensagens").document(idRemetente).collection(idDestinatario).addDocument(data: mensagem)
        //limpar caixa de texto
        screen?.inputMessageTextField.text = ""
    }
    
    private func salvarConversa(idRemetente:String,idDestinatario:String,conversa:[String:Any]){
        db?.collection("conversas").document(idRemetente).collection("ultimas_conversas").document(idDestinatario).setData(conversa)
        
    }
    
    
}

extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listaMensagens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indice = indexPath.row
        let dados = self.listaMensagens[indice]
        let idUsuario = dados.idUsuario ?? ""
        
        
        if self.idUsuarioLogado != idUsuario{
            //LADO ESQUERDO
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomingTextMessageTableViewCell.identifier, for: indexPath) as? IncomingTextMessageTableViewCell
            cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell?.setupCell(message: dados)
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }else{
            //LADO DIREITO
            let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingTextMessageTableViewCell.identifier, for: indexPath) as? OutgoingTextMessageTableViewCell
            cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell?.setupCell(message: dados)
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let desc:String = self.listaMensagens[indexPath.row].texto ?? ""
        let font = UIFont(name: CustomFont.poppinsSemiBold, size: 14) ?? UIFont()
        let estimateHeight = desc.heightWithConstrainedWidth(width: 220, font: font)
        return CGFloat(65 + estimateHeight)
    }
    

}


extension ChatViewController:ChatViewScreenProtocol{
    
    func actionPushMessage() {
        
        let message:String = self.screen?.inputMessageTextField.text ?? ""
        
        if let idUsuarioDestinatario = contato?.id{
            
            let mensagem:Dictionary<String,Any> = [
                "idUsuario" : self.idUsuarioLogado ?? "",
                "texto" : message,
                "data" : FieldValue.serverTimestamp()
            ]
            
            //mensagem para remetente
            self.salvarMensagem(idRemetente: self.idUsuarioLogado ?? "", idDestinatario: idUsuarioDestinatario, mensagem: mensagem)
            
            //salvar mensagem para destinario
            self.salvarMensagem(idRemetente: idUsuarioDestinatario, idDestinatario: self.idUsuarioLogado ?? "", mensagem: mensagem)
            
            var conversa:Dictionary<String,Any> = [
                "ultimaMensagem" : message
            ]
            
            //salvar conversa para remetente(dados de quem recebe)
            conversa["idRemetente"] = idUsuarioLogado ?? ""
            conversa["idDestinatario"] = idUsuarioDestinatario
            conversa["nomeUsuario"] = self.nomeContato ?? ""
            self.salvarConversa(idRemetente: idUsuarioLogado ?? "", idDestinatario: idUsuarioDestinatario, conversa: conversa)
            
            //salvar conversa para destinatario(dados de quem envia)
            conversa["idRemetente"] = idUsuarioDestinatario
            conversa["idDestinatario"] = idUsuarioLogado ?? ""
            conversa["nomeUsuario"] = self.nomeUsuarioLogado ?? ""
            self.salvarConversa(idRemetente: idUsuarioDestinatario, idDestinatario: idUsuarioLogado ?? "", conversa: conversa)
        }
        
    }
    
}

//
//
//class ChatViewController: UIViewController {
//
//    var listaMensagens:[Message] = []
//    var idUsuarioLogado:String?
//    var contato:Contact?
//    var mensagemListener:ListenerRegistration?
//    var auth:Auth? // criando referencia
//    var db:Firestore?  // criando referencia
//    var nomeContato:String?
//    var nomeUsuarioLogado:String?
//
//    var screen:ChatViewScreen?
//
//    override func loadView() {
//        self.screen = ChatViewScreen()
//        self.view = screen
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.confiDataFirebase()
//        self.configChatView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.addListenerRecuperarMensagens()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.mensagemListener?.remove()
//    }
//
//    private func confiDataFirebase(){
//        self.auth = Auth.auth()  // instanciando
//        self.db = Firestore.firestore() // instanciando
//
//        // Recuperar Id do usuario logado
//        if let id = self.auth?.currentUser?.uid {
//            self.idUsuarioLogado = id
//            self.recuperarDadosUsuarioLogado()
//        }
//
//        if let nome = self.contato?.nome {
//            self.nomeContato = nome
//        }
//    }
//
//    func addListenerRecuperarMensagens(){
//
//        if let idDestinatario = self.contato?.id{
//            self.mensagemListener = db?.collection("Mensagens").document(self.idUsuarioLogado ?? "").collection(idDestinatario).order(by:"data",descending: true).addSnapshotListener({ querySnapshot, error
//                in
//
//                //limpar lista
//                self.listaMensagens.removeAll()
//
//                //Recuperar dados
//                if let snapshot = querySnapshot{
//                    for document in snapshot.documents{
//                        let dados = document.data()
//                        self.listaMensagens.append(Message(dicionario: dados))
//                    }
//                    self.screen?.reloadTableView()
//                }
//            })
//        }
//    }
//
//
//    private func recuperarDadosUsuarioLogado(){
//        let usuarios = self.db?.collection("Usuarios").document(self.idUsuarioLogado ?? "")
//        usuarios?.getDocument(completion: { DocumentSnapshot, error in
//            if error == nil {
//                let dados: Contact = Contact(dicionario: DocumentSnapshot?.data() ?? [:]) // ja contenho todos os dados do usuario
//                self.nomeUsuarioLogado = dados.nome ?? ""
//            }
//        })
//    }
//
//    private func configChatView(){
//        self.screen?.configNavView(controller: self)
//        self.screen?.configTableView(delegate: self, dataSource: self)
//        self.screen?.delegate(delegate: self)
//    }
//
//
//    @objc func tappedBackButton(){
//        self.navigationController?.popToRootViewController(animated: true)
//    }
//
//    //MARK
//
//    private func salvarMensagem(idRemetente: String, idDestinatario:String, mensagem:[String:Any]){  // salvar para enviar para o back,que no nosso caso é o Firebase, p que ele possa armazenar essa msg através do banco de dados dele
//        // a partir do momento que ele salvar lá, o listener vai disparar e ele vai dar o Upload na tableView
//        self.db?.collection("Mensagens").document(idRemetente).collection(idDestinatario).addDocument(data: mensagem)
//        // limpar a caixa de texto após o envio da msg
//        self.screen?.inputMessageTextField.text = ""
//
//    }
//
//    private func salvarConversa(idRemetente:String,idDestinatario:String,conversa:[String:Any]){
//        self.db?.collection("conversas").document(idRemetente).collection("ultimas_conversas").document(idDestinatario).setData(conversa)
//
//    }
//}
//
//
//extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.listaMensagens.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let indice = indexPath.row
//        let dados = self.listaMensagens[indice]
//        let idUsuario = dados.idUsuario ?? ""
//
//        if self.idUsuarioLogado != idUsuario{
//            //LADO ESQUERDO
//            let cell = tableView.dequeueReusableCell(withIdentifier: IncomingTextMessageTableViewCell.identifier, for: indexPath) as? IncomingTextMessageTableViewCell
//            cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
//            cell?.setupCell(message: dados)
//            cell?.selectionStyle = .none
//            return cell ?? UITableViewCell()
//        }else{
//            //LADO DIREITO
//            let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingTextMessageTableViewCell.identifier, for: indexPath) as? OutgoingTextMessageTableViewCell
//            cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
//            cell?.setupCell(message: dados)
//            cell?.selectionStyle = .none
//            return cell ?? UITableViewCell()
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let desc: String = self.listaMensagens[indexPath.row].texto ?? ""
//        let font = UIFont(name: CustomFont.poppinsSemiBold, size: 14) ?? UIFont()
//        let estimateHeight = desc.heightWithConstrainedWidth(width: 220, font: font)
//        return CGFloat(65 + estimateHeight)
//    }
//}
//
//extension ChatViewController: ChatViewScreenProtocol {
//    func actionPushMessage() {
//        let message: String = self.screen?.inputMessageTextField.text ?? ""
//
//        if let idUsuarioDestinatario = self.contato?.id {
//
//            let mensagem: Dictionary<String,Any> = [
//                "idUsuario":self.idUsuarioLogado ?? "",
//                "texto": message,
//                "data": FieldValue.serverTimestamp()
//            ]
//
//            // mensagem para Remetente
//            self.salvarMensagem(idRemetente: self.idUsuarioLogado ?? "", idDestinatario: idUsuarioDestinatario, mensagem: mensagem)
//
//            // mensagem para Destinatário
//            self.salvarMensagem(idRemetente: idUsuarioDestinatario,idDestinatario: self.idUsuarioLogado ?? "", mensagem: mensagem)
//
////            var conversa: [String:Any] = ["ultimaMensagem": message]
////            // as conversas contem as mensagens
////
//            var conversa:Dictionary<String,Any> = [
//                "ultimaMensagem" : message
//            ]
//
//            ///[String:Any]
//
//            // salvar conversa para remetente(dados de quem recebe)
//            conversa["idRemetente"] = idUsuarioLogado ?? ""
//            conversa["idDestinatario"] = idUsuarioDestinatario
//            conversa["nomeUsuario"] = self.nomeContato ?? ""
//            self.salvarConversa(idRemetente: idUsuarioLogado ?? "", idDestinatario: idUsuarioDestinatario, conversa: conversa)
//
//
//            // salvar conversa para o destinatario(dados de quem envia)
//            conversa["idRemetente"] = idUsuarioDestinatario
//            conversa["idDestinatario"] = idUsuarioLogado ?? ""
//            conversa["nomeUsuario"] = idUsuarioLogado ?? ""
//            self.salvarConversa(idRemetente: idUsuarioDestinatario, idDestinatario: idUsuarioLogado ?? "", conversa: conversa)
//
//        }
//    }
//}
//

