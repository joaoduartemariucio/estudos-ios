//
//  AudioController.swift
//  Video porteiro Utech
//
//  Created by João Vitor Duarte Mariucio on 15/07/20.
//  Copyright © 2020 Fulltime Gestora de Dados Ltda. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioControllerDelegate {
    func packetAudioFinal(_ packet: [UInt8])
}

enum RTPMode: UInt8 {
    
    case GSM = 3
    case PCMA = 8
    case PCMU = 0
    
    var value: UInt8 {
        get {
            return self.rawValue
        }
    }
}

class AudioController {
    
    //    MARK: - Atributos
    var remoteIOUnit: AudioComponentInstance?
    var delegate: AudioControllerDelegate?
    
    var mBitsChannel: UInt32 = 8
    var mChannels: UInt32 = 1
    
    var packetCount: UInt16 = 0
    var timestamp:UInt32 = 0
    var ssrc:UInt32 = 0
    
    var rtpMode: RTPMode = RTPMode.PCMA

    // Iniciando instancia compartilhada
    static var sharedInstance = AudioController()
    
    func removeCurrentInstance() {
        if let remote = AudioController.sharedInstance.remoteIOUnit {
            AudioComponentInstanceDispose(remote)
        }
    }
    
//    MARK: - Configuração de sessão de audio
    func prepare(specifiedSampleRate: Double, mode: RTPMode) -> OSStatus {
        
        removeCurrentInstance()
        
        rtpMode = mode
        var status = noErr
        
        let session = AVAudioSession.sharedInstance()
        
        session.requestRecordPermission {(granted) in
            if granted {
                print("Permissão de audio já foi concedida")
                do {
                    try session.setCategory(.playAndRecord)
                    try session.setPreferredIOBufferDuration(1)
                    try session.setActive(true, options: [])
                } catch {
                    print(error.localizedDescription)
                }
            }else {
                print("Permissão de audio não foi concedida")
            }
        }

        // Inicio randonico para payload RTP
        packetCount = UInt16.random(in: UInt16.min..<100)
        timestamp   = UInt32.random(in: UInt32.min..<100)
        ssrc        = UInt32.random(in: UInt32.min..<100)
        
        var sampleRate = session.sampleRate
        print("hardware sample rate = \(sampleRate), using specified rate = \(specifiedSampleRate)")
        sampleRate = Double(specifiedSampleRate)
        
        // Descrição do remote unit
        var audioComponentDescription = AudioComponentDescription()
        audioComponentDescription.componentType = kAudioUnitType_Output;
        audioComponentDescription.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
        audioComponentDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
        audioComponentDescription.componentFlags = 0;
        audioComponentDescription.componentFlagsMask = 0;
        
        // Buscando RemoteIO unit do hardware
        let remoteIOComponent = AudioComponentFindNext(nil, &audioComponentDescription)
        status = AudioComponentInstanceNew(remoteIOComponent!, &remoteIOUnit)
        if (status != noErr) {
            return status
        }
        
        let bus1 : AudioUnitElement = 1
        
        var turnON : UInt32 = 1
        var turnOFF: UInt32 = 0
        
        // Ativa a entrada de audio do hardware
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAudioOutputUnitProperty_EnableIO,
                                      kAudioUnitScope_Input,
                                      bus1,
                                      &turnON,
                                      UInt32(MemoryLayout.size(ofValue: turnON)))
        if (status != noErr) {
            return status
        }
        
        // Setando o formato da entrada de audio do bus(1)
        var asbd = AudioStreamBasicDescription()
        asbd.mSampleRate = sampleRate
        
        switch mode {
        case .GSM:
            asbd.mFormatID = kAudioFormatMicrosoftGSM
            break
        case .PCMA:
            asbd.mFormatID = kAudioFormatALaw
            break
        case .PCMU:
            asbd.mFormatID = kAudioFormatULaw
            break
        }
        
        asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
        asbd.mBitsPerChannel = mBitsChannel
        asbd.mChannelsPerFrame = mChannels
        asbd.mFramesPerPacket = 1
        
        let bytes = (mBitsChannel / 8) * mChannels;
        
        asbd.mBytesPerPacket = bytes
        asbd.mBytesPerFrame = bytes
        
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAudioUnitProperty_StreamFormat,
                                      kAudioUnitScope_Output,
                                      bus1,
                                      &asbd,
                                      UInt32(MemoryLayout<AudioStreamBasicDescription>.size))
        if (status != noErr) {
            return status
        }
        
        // Adicionando callback para gravação de audio
        var callbackStruct = AURenderCallbackStruct()
        callbackStruct.inputProc = recordingCallback
        callbackStruct.inputProcRefCon = nil
        
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAudioOutputUnitProperty_SetInputCallback,
                                      kAudioUnitScope_Global,
                                      bus1,
                                      &callbackStruct,
                                      UInt32(MemoryLayout<AURenderCallbackStruct>.size));
        
        // Desativando processamento do audio automatico e cancelamento de ruido
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAUVoiceIOProperty_BypassVoiceProcessing,
                                      kAudioUnitScope_Global,
                                      bus1,
                                      &turnOFF,
                                      UInt32(MemoryLayout.size(ofValue: turnOFF)))
        
        status = AudioUnitSetProperty(remoteIOUnit!,
                                      kAUVoiceIOProperty_VoiceProcessingEnableAGC,
                                      kAudioUnitScope_Global,
                                      bus1,
                                      &turnOFF,
                                      UInt32(MemoryLayout.size(ofValue: turnOFF)))
        
        if (status != noErr) {
            return status
        }
        
        // Inicializa a intancia de audio do RemoteIO unit
        guard let remote = AudioController.sharedInstance.remoteIOUnit else {
            print("RemoteIO unit não pode ser inicializado")
            return noErr
        }
        return AudioUnitInitialize(remote)
    }
    
//    MARK: - Funções de inicio da sessão de audio
    func start() -> OSStatus {
        guard let remote = AudioController.sharedInstance.remoteIOUnit else {
            print("RemoteIO não inicializado a comunição de audio nao vai ser iniciada")
            return noErr
        }
        
        return AudioOutputUnitStart(remote)
    }
    
    func stop() -> OSStatus {
        guard let remote = AudioController.sharedInstance.remoteIOUnit else {
            print("RemoteIO não finalizado por que não existe nenhuma instancia")
            return noErr
        }
        
        return AudioOutputUnitStop(remote)
    }
    
//    MARK: - Callback buffer audio
    let recordingCallback: AURenderCallback = { (
        inRefCon,
        ioActionFlags,
        inTimeStamp,
        inBusNumber,
        inNumberFrames,
        ioData) -> OSStatus in
        
        var status = noErr
        
        var bufferList = AudioBufferList()
        bufferList.mNumberBuffers = AudioController.sharedInstance.mChannels
        
        let buffers = UnsafeMutableBufferPointer<AudioBuffer>(start: &bufferList.mBuffers, count: Int(bufferList.mNumberBuffers))
        
        buffers[0].mNumberChannels = AudioController.sharedInstance.mChannels
        buffers[0].mDataByteSize = inNumberFrames * AudioController.sharedInstance.mChannels
        buffers[0].mData = nil
        
        status = AudioUnitRender(AudioController.sharedInstance.remoteIOUnit!,
                                 ioActionFlags,
                                 inTimeStamp,
                                 inBusNumber,
                                 inNumberFrames,
                                 UnsafeMutablePointer<AudioBufferList>(&bufferList))
        if (status != noErr) {
            return status;
        }
        
        guard let mData = buffers[0].mData else { return noErr }
        
        let data = Data(bytes: mData, count: Int(buffers[0].mDataByteSize))
        
        AudioController.sharedInstance.processAudioData(data: data)
        return noErr
    }
    
//    MARK: - Processamento buffer audio
    func processAudioData(data: Data){
        DispatchQueue.main.async {
            
            let dataStream = InputStream(data: data)
            dataStream.open()
            
            let numBytesPerObject = 160
            var buffer = [UInt8](repeating: 0, count: numBytesPerObject)
            
            while dataStream.read(&buffer, maxLength: numBytesPerObject) != 0 {
                                
                AudioController.sharedInstance.packetCount += 1
                AudioController.sharedInstance.timestamp   += 160
                
                // Criando cabeçalho interleaved header
                let interleavedHeader: [UInt8] = [36, 0, 0, 172]
                 
                // Criando pacote de audio rtp header
                let rtpHeader = RtpHeader.init(RtpVersion.VERSION_2,  false, false, AudioController.sharedInstance.packetCount, AudioController.sharedInstance.timestamp, AudioController.sharedInstance.ssrc, false, AudioController.sharedInstance.rtpMode.value, [])
               
                // Criando pacote de audio
                let pacoteAudio = Data(bytes: buffer, count: buffer.count);
    
                // Pacote final RTP
                var packetFinal: Array<UInt8> = []
    
                packetFinal.append(contentsOf: interleavedHeader)
                packetFinal.append(contentsOf: RtpHeader.pack(header: rtpHeader) )
                packetFinal.append(contentsOf: pacoteAudio)
                AudioController.sharedInstance.delegate?.packetAudioFinal(packetFinal)
            }
            
            dataStream.close();
        }
    }
}
//
//extension Data {
//    
//    init(buffer: AVAudioPCMBuffer, time: AVAudioTime) {
//        let audioBuffer = buffer.audioBufferList.pointee.mBuffers
//        self.init(bytes: audioBuffer.mData!, count: Int(audioBuffer.mDataByteSize))
//    }
//
//    func makePCMBuffer(format: AVAudioFormat) -> AVAudioPCMBuffer? {
//        let streamDesc = format.streamDescription.pointee
//        let frameCapacity = UInt32(count) / streamDesc.mBytesPerFrame
//        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity) else { return nil }
//
//        buffer.frameLength = buffer.frameCapacity
//        let audioBuffer = buffer.audioBufferList.pointee.mBuffers
//
//        withUnsafeBytes { (bufferPointer) in
//            guard let addr = bufferPointer.baseAddress else { return }
//            audioBuffer.mData?.copyMemory(from: addr, byteCount: Int(audioBuffer.mDataByteSize))
//        }
//
//        return buffer
//    }
//}
