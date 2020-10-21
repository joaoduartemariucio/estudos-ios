//
//  ViewController.swift
//  CoreAnimation
//
//  Created by João Vitor Duarte Mariucio on 21/04/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var viewAnimada: UIView = {
        var view = UIView(frame: CGRect(x: 50, y: 100, width: 100, height: 100))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    var btnStartAnimation: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Iniciar Animação", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        view.addSubview(viewAnimada)
       
        view.addSubview(btnStartAnimation)
        NSLayoutConstraint.activate([
            btnStartAnimation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            btnStartAnimation.heightAnchor.constraint(equalToConstant: 50),
            btnStartAnimation.widthAnchor.constraint(equalToConstant: 200),
            btnStartAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        btnStartAnimation.addTarget(self, action: #selector(iniciarAnimacao), for: .touchUpInside)
    }
    
    @objc func iniciarAnimacao(){
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse, .curveLinear] ,animations: {
            self.viewAnimada.frame = CGRect(
                x: 285,
                y: 400,
                width: 100,
                height: 100
            )
        }, completion: { void in
            self.view.layer.cornerRadius = 50
        })
    }
}

