//
//  ViewController.swift
//  Video porteiro Utech
//
//  Created by João Vitor Duarte Mariucio on 05/06/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudio

class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate {
    
//    MARK: - Atributos
    var clientSocket = SocketManager()
    var videoPorteiroAuth: VideoPorteiroAuth = VideoPorteiroAuth()
    
    var vlcMediaPlayer: VLCMediaPlayer = VLCMediaPlayer.shared
    var audioInstance = AudioController.sharedInstance

    var connectedSocket: Bool = false {
        didSet(value) {
            if value {
                lblStatusConexao.text = "Porteiro está conectado"
            }else {
                lblStatusConexao.text = "Porteiro está desconectado"
            }
        }
    }
    
    var registerSceqs = [CSeqRegister]()
    
//    MARK: - Componentes
    var viewVideoCamera: UIView = {
        var view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lblStatusConexao: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Porteiro desconectado"
        return lbl
    }()
    
    var btnSetup: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("SETUP", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var btnEnviarAudio: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("INICIAR ENVIO AUDIO", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var btnPararComunicacao: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("TEARDOWN", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //    MARK: - Ciclo de vida
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clientSocket.delegate = self
        audioInstance.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        settingLayout()
        settingActionButtons()
        conectarVideoPorteiro()
    }
    
    //    MARK: - Setting layout
    func settingLayout(){
        
        view.addSubview(viewVideoCamera)
        NSLayoutConstraint.activate([
            viewVideoCamera.topAnchor.constraint(equalTo: view.topAnchor),
            viewVideoCamera.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewVideoCamera.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewVideoCamera.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.40)
        ])
        
        view.addSubview(lblStatusConexao)
        NSLayoutConstraint.activate([
            lblStatusConexao.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lblStatusConexao.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(btnSetup)
        NSLayoutConstraint.activate([
            btnSetup.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            btnSetup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btnSetup.widthAnchor.constraint(equalToConstant: 200),
            btnSetup.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(btnEnviarAudio)
        NSLayoutConstraint.activate([
            btnEnviarAudio.bottomAnchor.constraint(equalTo: btnSetup.topAnchor, constant: -20),
            btnEnviarAudio.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btnEnviarAudio.widthAnchor.constraint(equalToConstant: 200),
            btnEnviarAudio.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(btnPararComunicacao)
        NSLayoutConstraint.activate([
            btnPararComunicacao.bottomAnchor.constraint(equalTo: btnEnviarAudio.topAnchor, constant: -20),
            btnPararComunicacao.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btnPararComunicacao.widthAnchor.constraint(equalToConstant: 200),
            btnPararComunicacao.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func settingActionButtons(){
        btnSetup.addTarget(self, action: #selector(iniciarNegociacaoRtsp), for: .touchUpInside)
//        btnEnviarAudio.addTarget(self, action: #selector(iniciarEnvioAudio(sender:)), for: .touchUpInside)
        btnPararComunicacao.addTarget(self, action: #selector(pararProcesso(sender:)), for: .touchUpInside)
    }
    
//    MARK: - Funções
    func conectarVideoPorteiro(){
        
        guard let url = URL(string: "rtsp://admin:admin@177.129.4.51:6754/Streaming") else {
            return
        }
        
        let host = url.host ?? ""
        let port = UInt32(url.port ?? 0)
        
        let user = url.user ?? ""
        let password = url.password ?? ""
        
        let scheme = url.scheme ?? ""
        let path = url.path
        
        videoPorteiroAuth.user = user
        videoPorteiroAuth.password = password
        videoPorteiroAuth.scheme = RTSP.scheme.options.rawValue
        videoPorteiroAuth.uri = "\(scheme)://\(host):\(port)\(path)"
        videoPorteiroAuth.host = host
        videoPorteiroAuth.port = port
        videoPorteiroAuth.path = path
        videoPorteiroAuth.videoUrl = url
            
        clientSocket.connectWith(ip: host.asCFString(), port: port)
        reproduzirVideoCameraPorteiro(url: url)
        _ = audioInstance.prepare(specifiedSampleRate: 8000, mode: .PCMA)

    }
    
    func reproduzirVideoCameraPorteiro(url: URL){
        
//        vlcMediaPlayer.drawable = viewVideoCamera
        vlcMediaPlayer.media = VLCMedia(url: url)
        vlcMediaPlayer.play()
    }
    
    @objc func iniciarEnvioAudio() {
        _ = audioInstance.start()
    }
    
    @objc func iniciarNegociacaoRtsp(){
        enviarOptionsDefault()
    }
    
    func enviarOptionsDefault(){
        let options = videoPorteiroAuth.options
        registerSceqs.append(CSeqRegister(sceq: videoPorteiroAuth.seq, scheme: .options))
        clientSocket.send(message: options)
    }
    
    func enviarOptionsAuthenticate(message: String){
        let regexValoresEntreAspas = NSRegularExpression("\"(.*?)\"")
        
        let resultados = regexValoresEntreAspas.matches(message)
        
        if resultados.count == 3 {
            videoPorteiroAuth.realm = resultados[0]
            videoPorteiroAuth.nonce = resultados[1]
            
            videoPorteiroAuth.createDigestAuth()
            
            let options = videoPorteiroAuth.options
            registerSceqs.append(CSeqRegister(sceq: videoPorteiroAuth.seq, scheme: .options))
            clientSocket.send(message: options)
        }else {
            print("Resultado insuficientes para authenticar o porteiro")
        }
    }
    
    func enviarDescribe(){
        let describe = videoPorteiroAuth.describe
        registerSceqs.append(CSeqRegister(sceq: videoPorteiroAuth.seq, scheme: .describe))
        clientSocket.send(message: describe)
    }
    
    func enviarSetup(){
        let setup = videoPorteiroAuth.setup
        registerSceqs.append(CSeqRegister(sceq: videoPorteiroAuth.seq, scheme: .setup))
        clientSocket.send(message: setup)
    }
    
    func enviarPlay(){
        let play = videoPorteiroAuth.play
        registerSceqs.append(CSeqRegister(sceq: videoPorteiroAuth.seq, scheme: .play))
        clientSocket.send(message: play)
    }
    
    @objc func pararProcesso(sender: UIButton){
        clientSocket.hasPlayInitialized = false
        _ = audioInstance.stop()
        videoPorteiroAuth.seq += 1
        clientSocket.send(message: videoPorteiroAuth.teardown)
        videoPorteiroAuth.resetComunication()
        clientSocket.disconnect()
    }
    
    func tratarMessage(message: String){
        
        if let lastedSubmission = registerSceqs.last {
        
            if ((lastedSubmission.scheme == .options) && (message.contains("401 Unauthorized")) && (message.contains("Digest"))) {
                enviarOptionsAuthenticate(message: message)
            }
            
            if ((lastedSubmission.scheme == .options) && (message.contains("200 OK"))) {
                print("PORTEIRO ACEITOU O OPTIONS")
                if (message.contains("DESCRIBE, SETUP, TEARDOWN, PLAY, PAUSE")) {
                    enviarDescribe()
                }
            }
            
            if ((lastedSubmission.scheme == .describe) && (message.contains("200 OK"))) {
                print("PORTEIRO ACEITOU O DESCRIBE")
                if (message.contains("PCMA")) {
                    print("PORTEIRO ESTA USANDO PCMA")
                    _ = audioInstance.prepare(specifiedSampleRate: 8000, mode: .PCMA)
                }
                
                if (message.contains("PCMU")) {
                    print("PORTEIRO ESTA USANDO PCMU")
                    _ = audioInstance.prepare(specifiedSampleRate: 8000, mode: .PCMU)
                }
                
                if (message.contains("GSM")) {
                    print("PORTEIRO ESTA USANDO GSM")
                    _ = audioInstance.prepare(specifiedSampleRate: 8000, mode: .GSM)
                }
                enviarSetup()
            }
            
            if ((lastedSubmission.scheme == .setup) && (message.contains("200 OK"))){
                print("PORTEIRO ACEITOU O SETUP")
                let regexValoresEntreAspas = NSRegularExpression("Session: (.*?);")
                
                let resultados = regexValoresEntreAspas.matches(message)
                
                if resultados.count == 1 {
                    videoPorteiroAuth.session = resultados[0].replacingOccurrences(of: ";", with: "")
                    enviarPlay()
                }
            }
            
            if ((lastedSubmission.scheme == .play)){
                if (message.contains("200 OK")) {
                    print("PORTEIRO ACEITOU O PLAY")
                    clientSocket.hasPlayInitialized = true
                    iniciarEnvioAudio()
                }
            }
            return
        }
    }
    
    func audioData(dataAudio: Data){
        print("Porteiro buffer recebido =====>", dataAudio)
    }
}

extension ViewController: SocketManagerDelegate {
    
    func statusConexaoStream(status: StatusConexaoStream) {
        switch status {
        case .connected:
            connectedSocket = true
            break
        case .disconected:
            connectedSocket = false
            break
        }
    }
    
    func novaMensagemStream(message: String) {
        self.tratarMessage(message: message)
    }
    
    func dataBufferComplete(packet: [UInt8]) {
        var newPacket = packet
        for _ in 0..<16 {
            newPacket.removeFirst()
        }
        
        self.audioData(dataAudio: Data(bytes: newPacket, count: newPacket.count))
    }
}

extension VLCMediaPlayer {
    public static let shared: VLCMediaPlayer = {
        
        let options: [String] = [
            "--rtsp-tcp",
            "--swscale-mode=0",
            ":fullscreen",
            "--no-auto-preparse"
        ]
        
        let player: VLCMediaPlayer = VLCMediaPlayer(options: options)
        
        return player
    }()
}

extension ViewController: AudioControllerDelegate {
    
    func packetAudioFinal(_ packet: [UInt8]) {
        self.clientSocket.sendPacketAudio(packet: packet)
    }
}
