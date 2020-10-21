//
//  ViewController.swift
//  AnimationLoadToTop
//
//  Created by João Vitor Duarte Mariucio on 23/04/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//  MARK: - Componentes da View
    var animationLoadView: AnimationLoadView = {
        var animationLoadView = AnimationLoadView()
        animationLoadView.colorAnimation = .gray
        return animationLoadView
    }()
    
    var btnStart: UIButton = {
        var teste = UIButton()
        teste.translatesAutoresizingMaskIntoConstraints = false
        teste.setTitle("Iniciar Animação", for: .normal)
        teste.setTitleColor(.blue, for: .normal)
        return teste
    }()
    
    var btnStop: UIButton = {
        var teste = UIButton()
        teste.translatesAutoresizingMaskIntoConstraints = false
        teste.setTitle("Parar Animação", for: .normal)
        teste.setTitleColor(.blue, for: .normal)
        return teste
    }()

//    MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(animationLoadView)
        
        view.backgroundColor = .white
        
        title = "Sample Animation Load"
        
        view.addSubview(btnStart)
        NSLayoutConstraint.activate([
            btnStart.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnStart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnStart.heightAnchor.constraint(equalToConstant: 50),
            btnStart.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        view.addSubview(btnStop)
        NSLayoutConstraint.activate([
            btnStop.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            btnStop.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnStop.heightAnchor.constraint(equalToConstant: 50),
            btnStop.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        btnStart.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        btnStop.addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)
    }
    
    
//    MARK: - Ação dos botões da view
    @objc func startAnimation(){
        animationLoadView.startLoad()
    }
    
    @objc func stopAnimation(){
        animationLoadView.stopLoad()
    }
}

