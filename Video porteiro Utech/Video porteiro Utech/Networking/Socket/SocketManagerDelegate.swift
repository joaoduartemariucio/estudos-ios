//
//  PresenterProtocol.swift
//  Video porteiro Utech
//
//  Created by João Vitor Duarte Mariucio on 10/06/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import Foundation

protocol SocketManagerDelegate: class {
    
    func statusConexaoStream(status: StatusConexaoStream)
    func novaMensagemStream(message: String)
    func dataBufferComplete(packet: [UInt8])
}

