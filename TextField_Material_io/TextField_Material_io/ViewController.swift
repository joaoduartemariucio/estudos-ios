//
//  ViewController.swift
//  TextField_Material_io
//
//  Created by João Vitor Duarte Mariucio on 22/03/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import UIKit
import MaterialComponents.MDCFilledTextField

class ViewController: UIViewController {
    
    let textFieldFloat: MDCFilledTextField = {
        let text = MDCFilledTextField()
        text.label.text = "DDD + Número"
        text.placeholder = "DDD + Número"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let mostrarErro: UIButton = {
        var btn = UIButton()
        btn.setTitle("Testando", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.view.addSubview(textFieldFloat)
        NSLayoutConstraint.activate([
            self.textFieldFloat.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            self.textFieldFloat.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.textFieldFloat.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            self.textFieldFloat.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.view.addSubview(mostrarErro)
        NSLayoutConstraint.activate([
            self.mostrarErro.topAnchor.constraint(equalTo: self.textFieldFloat.bottomAnchor, constant: 50),
            self.mostrarErro.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            self.mostrarErro.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            self.mostrarErro.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        mostrarErro.addTarget(self, action: #selector(mostrarErroBtn), for: .touchUpInside)
    }
    
    @objc func mostrarErroBtn(){
        self.textFieldFloat.leadingAssistiveLabel.text = "Teste"
        self.textFieldFloat.leadingAssistiveLabel.textColor = .red
        self.textFieldFloat.leadingAssistiveLabel.isHidden = false
    }
}

