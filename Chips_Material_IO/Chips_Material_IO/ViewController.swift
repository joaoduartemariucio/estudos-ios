//
//  ViewController.swift
//  Chips_Material_IO
//
//  Created by João Vitor Duarte Mariucio on 24/03/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialChips

class ViewController: UIViewController {
    
    var stackView: UIStackView = {
       var stack = UIStackView()
       stack.translatesAutoresizingMaskIntoConstraints = false
       stack.distribution = .fillEqually
       stack.axis = .horizontal
       stack.spacing = 5
       return stack
    }()

    let armeSelecionado = MDCChipView()
    let armeStaySelecionado = MDCChipView()
    let desarmeSelecionado = MDCChipView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        armeSelecionado.titleLabel.text = "Arme"
        armeSelecionado.setTitleColor(UIColor(red:0.50, green:0.00, blue:0.00, alpha:1.00), for: .selected)
        armeSelecionado.setBackgroundColor(UIColor(red:1.00, green:0.37, blue:0.32, alpha: 0.50), for: .selected)
        armeSelecionado.tag = 1
        armeSelecionado.addTarget(self, action: #selector(tipoLembreteSelecionado(sender:)), for: .touchUpInside)
        stackView.addArrangedSubview(armeSelecionado)
        
        armeStaySelecionado.titleLabel.text = "Arme Stay"
        armeStaySelecionado.setTitleColor(UIColor(red:0.50, green:0.00, blue:0.00, alpha:1.00), for: .selected)
        armeStaySelecionado.setBackgroundColor(UIColor(red:1.00, green:0.37, blue:0.32, alpha: 0.50), for: .selected)
        armeStaySelecionado.tag = 2
        armeStaySelecionado.addTarget(self, action: #selector(tipoLembreteSelecionado(sender:)), for: .touchUpInside)
        stackView.addArrangedSubview(armeStaySelecionado)
        
        desarmeSelecionado.titleLabel.text = "Desarme"
        desarmeSelecionado.setTitleColor(UIColor(red:0.50, green:0.00, blue:0.00, alpha:1.00), for: .selected)
        desarmeSelecionado.setBackgroundColor(UIColor(red:1.00, green:0.37, blue:0.32, alpha: 0.50), for: .selected)
        desarmeSelecionado.tag = 3
        desarmeSelecionado.addTarget(self, action: #selector(tipoLembreteSelecionado(sender:)), for: .touchUpInside)
        stackView.addArrangedSubview(desarmeSelecionado)
        
    }
    
    @objc func tipoLembreteSelecionado(sender: MDCChipView){
        
        if sender.tag == 1 {
            sender.isSelected = true
            armeStaySelecionado.isSelected = false
            desarmeSelecionado.isSelected = false
        }
        
        if sender.tag == 2 {
            sender.isSelected = true
            armeSelecionado.isSelected = false
            desarmeSelecionado.isSelected = false
        }
        
        if sender.tag == 3 {
            sender.isSelected = true
            armeSelecionado.isSelected = false
            armeStaySelecionado.isSelected = false
        }
    }
}

