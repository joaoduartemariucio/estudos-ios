//
//  RTPScheme.swift
//  Video porteiro Utech
//
//  Created by João Vitor Duarte Mariucio on 11/08/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import Foundation

enum RTSPcheme: String {

    case options  = "OPTIONS"
    case describe = "DESCRIBE"
    case setup    = "SETUP"
    case play     = "PLAY"
    case pause    = "PAUSE"
    case teardown = "TEARDOWN"
}
