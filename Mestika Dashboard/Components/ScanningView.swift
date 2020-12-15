//
//  ScanningView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 09/10/20.
//

import SwiftUI
import UIKit
import VisionKit
import Combine

struct ScanningView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var recognizedText: String
    @Binding var cameraFileName: String
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(recognizedText: $recognizedText, cameraFileName: $cameraFileName, parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScanningView>) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator
        return documentCameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScanningView>) {
        
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        
        var recognizedText: Binding<String>
        var cameraFileName: Binding<String>
        var parent: ScanningView
        private let textRecognizer: TextRecognizer
        
        init(recognizedText: Binding<String>, cameraFileName: Binding<String>, parent: ScanningView) {
            self.recognizedText = recognizedText
            textRecognizer = TextRecognizer(recognizedText: recognizedText)
            self.cameraFileName = cameraFileName
            self.parent = parent
        }
        
        private func store(imgStore: UIImage, forKey key: String) {
        
            print("FOR STORE IMAGE")
            if let pngRepresentation = imgStore.pngData() {
                print("STORRED")
                UserDefaults.standard.set(pngRepresentation, forKey: key)
            }
        }
                
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var images = [CGImage]()
            for pageIndex in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                print(scan.imageOfPage(at: 0))
                
                store(imgStore: scan.imageOfPage(at: 0), forKey: cameraFileName.wrappedValue)
                if let cgImage = image.cgImage {
                    images.append(cgImage)
                }
            }
            
            textRecognizer.recognizeText(from: images)
            controller.navigationController?.popViewController(animated: true)
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }

}
