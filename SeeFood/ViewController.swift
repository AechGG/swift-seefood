//
//  ViewController.swift
//  SeeFood
//
//  Created by Harrison Gittos on 01/09/2020.
//  Copyright © 2020 Harrison Gittos. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self;
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage;
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage");
            };
            
            detect(image: ciImage);
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil);
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed");
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Failed to convert results to VNClassificationObservation");
            }
            
            print(results);
        }
        
        let handler = VNImageRequestHandler(ciImage: image);
        
        do {
            try handler.perform([request]);
        } catch {
            print("Error occured: \(error)");
        }
        
    }
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil);
        
    }
    
}

