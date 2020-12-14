//
//  PhotoCropping.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 14/12/20.
//

import SwiftUI
import Mantis

struct ImageEditor: UIViewControllerRepresentable {
    typealias Coodinator = ImageEditorCoordinator
    
    @Binding var image: Image?
    @Binding var isShowing: Bool
    
    func makeCoordinator() -> ImageEditorCoordinator {
        return ImageEditorCoordinator(image: $image, isShowing: $isShowing)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageEditor>) -> Mantis.CropViewController {
        
        let Editor = Mantis.cropViewController(image: (self.image?.asUIImage())!)
        
        Editor.delegate = context.coordinator
        
        return Editor
    }
}

class ImageEditorCoordinator: NSObject, CropViewControllerDelegate {
    
    @Binding var image: Image?
    @Binding var isShowing: Bool
    
    init(image: Binding<Image?>, isShowing: Binding<Bool>) {
        _image = image
        _isShowing = isShowing
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        image = Image(uiImage: cropped)
        isShowing = false
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
        isShowing = false
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
        
    }
    
    func cropViewControllerWillDismiss(_ cropViewController: CropViewController) {
        
    }
    
}
