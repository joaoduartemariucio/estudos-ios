//
//  ViewController.swift
//  CapturePhoto
//
//  Created by Quang Tran on 2/20/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {
  
  @IBOutlet private weak var previewView: PreviewView!
  
  private let session = AVCaptureSession()
  private let sessionQueue = DispatchQueue(label: "session queue") // Communicate with the session and other session objects on this queue.
  private let photoOutput = AVCapturePhotoOutput()
  private var photoData: Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up the video preview view.
    previewView.session = session
    
    sessionQueue.async {
      self.configureSession()
      self.session.startRunning()
    }
  }
  
  private func configureSession() {
    session.beginConfiguration()
    
    // Add video input.
    do {
      let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
      let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
      session.addInput(videoDeviceInput)
    }
    catch {
      print("Couldn't create video device input: \(error)")
      session.commitConfiguration()
      return
    }
    
    // Add photo output.
    session.addOutput(photoOutput)
    
    session.commitConfiguration()
  }
  
  @IBAction private func capturePhoto(_ photoButton: UIButton) {
    sessionQueue.async {
      self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
  }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
  
  func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    // Flash the screen to signal that the camera took a photo.
    self.previewView.videoPreviewLayer.opacity = 0
    UIView.animate(withDuration: 0.25) {
      self.previewView.videoPreviewLayer.opacity = 1
    }
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
      print("Error capturing photo: \(error)")
    } else {
      photoData = photo.fileDataRepresentation()
    }
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
    if let error = error {
      print("Error capturing photo: \(error)")
      return
    }
    
    guard let photoData = photoData else {
      print("No photo data resource")
      return
    }
    
    PHPhotoLibrary.requestAuthorization { status in
      if status == .authorized {
        PHPhotoLibrary.shared().performChanges({
          let options = PHAssetResourceCreationOptions()
          let creationRequest = PHAssetCreationRequest.forAsset()
          creationRequest.addResource(with: .photo, data: photoData, options: options)
          
        }, completionHandler: { _, error in
          if let error = error {
            print("Error occurred while saving photo to photo library: \(error)")
          }
        })
      }
    }
  }
  
}
