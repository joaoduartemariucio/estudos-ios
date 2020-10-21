//
//  String+Extension.swift
//  Video porteiro Utech
//
//  Created by João Vitor Duarte Mariucio on 10/08/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import Foundation

extension String {
    
    func asCFString() -> CFString {
        return self as CFString
    }
}
