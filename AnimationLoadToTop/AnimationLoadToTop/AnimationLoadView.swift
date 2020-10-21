//
//  AnimationLoadView.swift
//  AnimationLoadToTop
//
//  Created by João Vitor Duarte Mariucio on 23/04/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import UIKit

class AnimationLoadView: UIView {
    
    let width = UIScreen.main.bounds.width

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: -width, y: 0, width: width, height: 5.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//     MARK: - Atribui cor e gradiente para a animação
    var color: UIColor = UIColor.white
    var colorAnimation: UIColor {
        set(value) {
            color = value
            self.backgroundColor = color
        }
        get {
            return color
        }
    }
    
    func startLoad(){
        isHidden = false
        UIView.animate(withDuration: 0.75, delay: 0.0, options: [.repeat, .curveLinear], animations: {
            self.frame = CGRect(
                x: UIScreen.main.bounds.width,
                y: 0,
                width: self.width,
                height: 5)
        }, completion: nil)
    }
    
    func stopLoad(){
        isHidden = true
    }
}
