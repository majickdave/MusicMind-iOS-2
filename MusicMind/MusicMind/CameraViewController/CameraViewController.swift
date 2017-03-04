//
//  CameraViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 2/28/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

//
//  ViewController.swift
//  CameraView
//
//  Created by Angel Contreras on 2/28/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var switchCameraButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    var currentDirection: CameraDirection = .front
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCameraView()

    }
    
    @IBAction func takePictureButtonPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func switchCameraButtonPressed(_ sender: Any) {
        switch currentDirection {
        case .front:
            setupCameraView(with: .back)
            currentDirection = .back
            break
        case .back:
            setupCameraView(with: .front)
            currentDirection = .front
            break
        }
        
    }
    
    
}

extension CameraViewController {
    enum CameraDirection {
        case front
        case back
    }
    
    func setupCameraView(with position: AVCaptureDevicePosition = .back){
        let devicesession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified)
        for device in (devicesession?.devices)!{
            if device.position == .back {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        
                        if captureSession.canAddOutput(sessionOutput){
                            captureSession.addOutput(sessionOutput)
                            
                            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            
                            //TODO: - Chage orientation based on the phone's orientation
                            videoPreviewLayer.connection.videoOrientation = .portrait
                            
                            cameraView.layer.addSublayer(videoPreviewLayer)
                            cameraView.addSubview(switchCameraButton)
                            
                            videoPreviewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            videoPreviewLayer.bounds = cameraView.frame
                            
                            captureSession.startRunning()
                        }
                    }
                } catch let avError {
                    print (avError)
                }
            }
        }
        
    }
    
}
