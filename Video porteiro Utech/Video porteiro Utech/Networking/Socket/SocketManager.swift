//
//  SocketDataManager.swift
//  Video porteiro Utech
//
//  Created by João Vitor Duarte Mariucio on 10/06/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import Foundation

class SocketManager: NSObject, StreamDelegate {
    
    var readStream: Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    var messages = [AnyHashable]()
    var hasPlayInitialized: Bool = false
    
    weak var delegate: SocketManagerDelegate?
    
    func connectWith(ip: CFString, port: UInt32) {
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, ip, port, &readStream, &writeStream)
        messages = [AnyHashable]()
        open()
    }
    
    func disconnect(){
        close()
    }
    
    func open() {
        
        outputStream = writeStream?.takeRetainedValue()
        inputStream = readStream?.takeRetainedValue()
        
        outputStream?.delegate = self
        inputStream?.delegate = self
        
        outputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        inputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        
        outputStream?.open()
        inputStream?.open()
    }
    
    func close() {
        
        delegate?.statusConexaoStream(status: .disconected)
        
        inputStream?.close()
        outputStream?.close()
        
        inputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
        outputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
        
        inputStream?.delegate = nil
        outputStream?.delegate = nil
        
        inputStream = nil
        outputStream = nil
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            delegate?.statusConexaoStream(status: .connected)
            break
        case .hasBytesAvailable:
            if ((aStream == inputStream) && (!hasPlayInitialized)) {
                var dataBuffer = Array<UInt8>(repeating: 0, count: 1024)
                var len: Int
                while (inputStream?.hasBytesAvailable)! {
                    len = (inputStream?.read(&dataBuffer, maxLength: 1024))!
                    if len > 0 {
                        let output = String(bytes: dataBuffer, encoding: .ascii)
                        if let message = output {
                            delegate?.novaMensagemStream(message: message)
                        }
                    }
                }
            }else {
                var dataBuffer = Array<UInt8>(repeating: 0, count: 176)
                var len: Int
                while (inputStream?.hasBytesAvailable)! {
                    len = (inputStream?.read(&dataBuffer, maxLength: 176))!
                    if len > 0 {
                        delegate?.dataBufferComplete(packet: dataBuffer)
                    }
                }
            }
            break
        case .hasSpaceAvailable:
            if outputStream == aStream {
                print("output stream hasSpaceAvailable")
            }else {
                print("input stream hasSpaceAvailable")
            }
            break
        case .errorOccurred:
            print("\(aStream.streamError?.localizedDescription ?? "")")
            delegate?.statusConexaoStream(status: .disconected)
            break
        case .endEncountered:
            aStream.close()
            aStream.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
            delegate?.statusConexaoStream(status: .disconected)
            break
        default:
            print("Evento não tratado")
            break
        }
    }
    
    func sendPacketAudio(packet: [UInt8]){
        if outputStream?.hasSpaceAvailable == true {
            outputStream?.write(packet, maxLength: packet.count)
        }
    }
    
    func send(message: String){
        
        let buff = [UInt8](message.utf8)
        outputStream?.write(buff, maxLength: buff.count)
    }
}

extension Data {
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> [String] {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }
    }
}
