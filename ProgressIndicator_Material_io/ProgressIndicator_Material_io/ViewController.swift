//
//  ViewController.swift
//  ProgressIndicator_Material_io
//
//  Created by João Vitor Duarte Mariucio on 22/03/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialProgressView

class ViewController: UIViewController {
    
    let progressView: MDCProgressView = {
        let progressView = MDCProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(progressView)
        NSLayoutConstraint.activate([
            self.progressView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            self.progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.progressView.heightAnchor.constraint(equalToConstant: 4)
        ])
        self.progressView.setProgress(200, animated: true, completion: { (finished) in
            self.progressView.setProgress(0, animated: true, completion: nil)
        })
    }
}

