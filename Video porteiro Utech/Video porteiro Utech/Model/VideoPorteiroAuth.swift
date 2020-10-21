//
//  DigestAuthData.swift
//  Video porteiro Utech
//
//  Created by João Vitor Duarte Mariucio on 15/06/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import Foundation
import CommonCrypto

struct VideoPorteiroAuth {
    
    var scheme: String
    var user: String
    var password: String
    var realm: String
    var nonce: String
    var host: String
    var port: UInt32
    var path: String
    var uri: String
    var response: String
    var session: String
    var videoUrl: URL?
    var seq: Int
    
    init(_ auth: String? = nil){
        self.scheme = ""
        self.user = ""
        self.password = ""
        self.realm = ""
        self.nonce = ""
        self.host = ""
        self.port = 0
        self.path = ""
        self.uri = ""
        self.response = ""
        self.session = ""
        self.seq = 0
    }
}

extension VideoPorteiroAuth {
    
    mutating func resetComunication(){
        seq = 0
        response = ""
        session = ""
        realm = ""
        nonce = ""
    }
    
    mutating func createDigestAuth() {
        
        let hash1 = md5Hash(str: "\(user):\(realm):\(password)")
        
        let hash2 = md5Hash(str: "\(scheme):\(uri)")
        
        response = md5Hash(str: "\(hash1):\(nonce):\(hash2)").lowercased()
    }
    
    mutating func createBasicAuth() {
        
        let str = "\(user):\(password)"
        let utf8str = str.data(using: .utf8)
        if let resp =  utf8str?.base64EncodedString() {
            response = resp
        }
    }
    
    private func md5Hash (str: String) -> String {
        if let strData = str.data(using: String.Encoding.utf8) {
            
            var digest = [UInt8](repeating: 0, count:Int(CC_MD5_DIGEST_LENGTH))
            
            _ = strData.withUnsafeBytes {
                CC_MD5($0.baseAddress, UInt32(strData.count), &digest)
            }
            
            var md5String = ""
            
            for byte in digest {
                md5String += String(format:"%02x", UInt8(byte))
            }
            
            return md5String
        }
        return ""
    }
    
    var options: String {
        mutating get {
            
            var options = ""
            
            seq += 1
            
            if response.isEmpty {
                options = "\(scheme) rtsp://\(host)/Streaming RTSP/1.0\r\nCSeq: \(seq)\r\n\r\n"
            }else {
                options = "\(scheme) rtsp://\(host)/Streaming RTSP/1.0\r\nCSeq: \(seq)\r\nAuthorization: Digest username=\"\(user)\", realm=\"\(realm)\", nonce=\"\(nonce)\", uri=\"\(uri)\", response=\"\(response)\"\r\n\r\n"
            }
            
            return options
        }
    }
    
    var describe: String {
        mutating get {
            
            seq += 1
            
            scheme = "DESCRIBE"
            createDigestAuth()
            
            let describe = "\(scheme) rtsp://\(host)/Streaming RTSP/1.0\r\nCSeq: \(seq)\r\nAuthorization: Digest username=\"\(user)\", realm=\"\(realm)\", nonce=\"\(nonce)\", uri=\"\(uri)\", response=\"\(response)\"\r\n\r\n"
            
            return describe
        }
    }
    
    var setup: String {
        mutating get {
            
            seq += 1
            
            scheme = "SETUP"
            createDigestAuth()
            
            let setup = "\(scheme) rtsp://172.19.211.59:6754/Streaming/Audio RTSP/1.0\r\nCSeq: \(seq)\r\nAuthorization: Digest username=\"\(user)\", realm=\"\(realm)\", nonce=\"\(nonce)\", uri=\"\(uri)\", response=\"\(response)\"\r\nTransport: RTP/AVP/TCP;unicast;interleaved=0-1\r\n\r\n"
            
            return setup
        }
    }
    
    var play: String {
        mutating get {
            
            seq += 1
            
            scheme = "PLAY"
            createDigestAuth()
            
            let play = "\(scheme) rtsp://\(host)/Streaming RTSP/1.0\r\nCSeq: \(seq)\r\nAuthorization: Digest username=\"\(user)\", realm=\"\(realm)\", nonce=\"\(nonce)\", uri=\"\(uri)\", response=\"\(response)\"\r\nTransport: RTP/AVP/TCP;unicast;interleaved=0-1\r\n\(session)\r\n\r\n"
            
            return play
        }
    }
    
    var teardown: String {
        mutating get {
                        
            scheme = "TEARDOWN"
            createDigestAuth()
            
            let teardown = "\(scheme) rtsp://\(host)/Streaming RTSP/1.0\r\nCSeq: \(seq)\r\nAuthorization: Digest username=\"\(user)\", realm=\"\(realm)\", nonce=\"\(nonce)\", uri=\"\(uri)\", response=\"\(response)\"\r\n\(session)\r\n\r\n"
            
            return teardown
        }
    }
}
