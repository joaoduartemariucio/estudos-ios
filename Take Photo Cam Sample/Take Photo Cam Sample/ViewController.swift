//
//  ViewController.swift
//  Take Photo Cam Sample
//
//  Created by João Vitor Duarte Mariucio on 25/08/20.
//  Copyright © 2020 João Vitor Duarte Mariucio. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    let cameraController = CameraController()
    
    override var prefersStatusBarHidden: Bool { return true }
    
}

extension ViewController {
    override func viewDidLoad() {
        
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.view)
            }
        }
        
        configureCameraController()
        
    }
}

extension ViewController {
    @IBAction func toggleFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
//            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
//            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
//            toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            break
        case .some(.rear):
//            toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            break
        case .none:
            return
        }
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
        }
    }
    
}
