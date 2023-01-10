//
//  MessageLastCollectionViewCell.swift
//  MessageCursoViewCode
//
//  Created by Gabriel Policastro on 01/11/22.
//

import UIKit

class MessageLastCollectionViewCell: UICollectionViewCell {
    
    static let identifier:String = "MessageLastCollectionViewCell"
    
    lazy var imageView:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.image = UIImage(systemName: "person.badge.plus")
        return img
    }()
        
    lazy var userName:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Adicionar novo Contato"
        label.font = UIFont(name: CustomFont.poppinsMedium, size: 16)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.addSubview(self.userName)
        self.setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 55),
            self.imageView.heightAnchor.constraint(equalToConstant: 55),
            
            self.userName.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor,constant: 15),
            self.userName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.userName.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),

        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
////
////  MessageDetailCollectionViewCell.swift
////  MessageCursoViewCode
////
////  Created by Gabriel Policastro on 01/11/22.
////
//
//import UIKit
//
//class MessageDetailCollectionViewCell: UICollectionViewCell {
//    
//    static let identifier:String = "MessageDetailCollectionViewCell"
//    
//    lazy var imageView:UIImageView = {
//        let img = UIImageView()
//        img.translatesAutoresizingMaskIntoConstraints = false
//        img.contentMode = .scaleAspectFit
//        img.clipsToBounds = true
//        img.layer.cornerRadius = 26
//        img.image = UIImage(named: "imagem-perfil")
//        return img
//    }()
//    
//    lazy var userName:UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 2
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addSubview(self.imageView)
//        self.addSubview(self.userName)
//        self.setUpConstraints()
//    }
//    
//    func setUpConstraints() {
//        NSLayoutConstraint.activate([
//            
//            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
//            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            self.imageView.widthAnchor.constraint(equalToConstant: 55),
//            self.imageView.heightAnchor.constraint(equalToConstant: 55),
//            
//            self.userName.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor,constant: 15),
//            self.userName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            self.userName.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -10),
//            
//        ])
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupViewContact(contact:Contact) {
//        self.setUserName(userName: contact.nome ?? "")
//        
//    }
//    
//    func setupViewConversation(conversation:Conversation) {
//        self.setUserNameAttributedText(conversation)
//    }
//    
//    
//    func setUserNameAttributedText(_ conversation:Conversation){
//        let attributedText = NSMutableAttributedString(string:"\(conversation.nome ?? "")" , attributes:[NSAttributedString.Key.font: UIFont(name:CustomFont.poppinsMedium, size: 16) ?? UIFont(),NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//        
//        attributedText.append(NSAttributedString(string: "\n\(conversation.ultimaMensagem ?? "")" , attributes:[NSAttributedString.Key.font: UIFont(name:CustomFont.poppinsMedium, size: 14) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
//         self.userName.attributedText = attributedText
//    }
//    
//    
//    func setUserName(userName:String) {
//        let attributText = NSMutableAttributedString(string: userName, attributes:[NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 16) ??  UIFont(), NSAttributedString.Key.foregroundColor:UIColor.darkGray])
//         self.userName.attributedText = attributText
//        
//        
////        self.userName.text = userName
//        
//    }
//}
//
