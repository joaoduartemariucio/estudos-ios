//
//  CustomAnnotationView.swift
//  Mapbox Samples
//
//  Created by João Vitor Duarte Mariucio on 29/07/20.
//  Copyright © 2020 João Vitor Duarte Mariucio. All rights reserved.
//

import Foundation
import Mapbox

// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    
    var image: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "image_redonda")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
        addSubview(image)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}
