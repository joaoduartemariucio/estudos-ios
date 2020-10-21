//
//  ViewController.swift
//  AudioKitSample
//
//  Created by João Vitor Duarte Mariucio on 20/08/20.
//  Copyright © 2020 João Vitor Duarte Mariucio. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    let mic = AKMicrophone()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Teste"
        view.backgroundColor = .white

        // Configure AudioKit for low latency
        AKSettings.bufferLength = .medium
        AKSettings.sampleRate = 8000
        AKSettings.audioInputEnabled = true
        AKSettings.channelCount = 1
        AKSettings.ioBufferDuration = 1

        AudioKit.output = mic

        let format = [
            AVLinearPCMBitDepthKey: 8,
            AVLinearPCMIsBigEndianKey: 0,
            AVNumberOfChannelsKey: 1,
            AVFormatIDKey: kAudioFormatALaw,
            AVSampleRateKey: 8000,
            AVLinearPCMIsNonInterleaved: 1,
            AVLinearPCMIsFloatKey: 1
        ]


        // Install input tap
        
        mic!.avAudioNode.installTap(onBus: 0,
             bufferSize: 160,
             format: mic!.avAudioNode.outputFormat(forBus: 0),
             block: { (buffer: AVAudioPCMBuffer!, _) -> Void in
                print(buffer)

        })

        do {
             try AudioKit.start()
        } catch {
             AKLog("AudioKit did not start")
        }
        
    }
}

