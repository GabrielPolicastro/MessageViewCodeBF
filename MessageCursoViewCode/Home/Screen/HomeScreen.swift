//
//  HomeScreen.swift
//  MessageCursoViewCode
//
//  Created by Gabriel Policastro on 27/10/22.
//

import UIKit

class HomeScreen: UIView {
    
    lazy var navView:NavView = {
        let view = NavView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delaysContentTouches = false
        cv.register(MessageLastCollectionViewCell.self, forCellWithReuseIdentifier: MessageLastCollectionViewCell.identifier)
        cv.register(MessageDetailCollectionViewCell.self, forCellWithReuseIdentifier: MessageDetailCollectionViewCell.identifier)
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        cv.setCollectionViewLayout(layout, animated: false)
        return cv
    }()
    
    public func delegateCollectionView(delegate:UICollectionViewDelegate,dataSource:UICollectionViewDataSource){
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = dataSource
    }
    
    public func reloadCollectionView(){
        self.collectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addElemented()
        self.setUpConstraints()
    }
    
    func addElemented(){
        self.addSubview(self.navView)
        self.addSubview(self.collectionView)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            self.navView.topAnchor.constraint(equalTo: self.topAnchor),
            self.navView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.navView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.navView.heightAnchor.constraint(equalToConstant: 140),

            self.collectionView.topAnchor.constraint(equalTo: self.navView.bottomAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
