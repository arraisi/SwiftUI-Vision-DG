//
//  JitsiView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 17/12/20.
//

import UIKit
import SwiftUI
import JitsiMeet

struct JitsiView: UIViewControllerRepresentable {
    
    @Binding var jitsi_room: String
    
    @State var jitsiMeetView: JitsiMeetView?
    @State var pipViewCoordinator: PiPViewCoordinator?
    
    class Coordinator: NSObject, JitsiMeetViewDelegate  {
        
        private let parent : JitsiView
        
        init(parent : JitsiView) {
            self.parent = parent
        }
        
        func conferenceTerminated(_ data: [AnyHashable : Any]!) {
            print("CLEAN UP")
            parent.cleanUp()
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> JitsiView.Coordinator {
        Coordinator(parent: self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    func makeUIViewController(context: Context) -> UIViewController {
        
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = context.coordinator
        self.jitsiMeetView = jitsiMeetView
        
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.room = self.jitsi_room
        }
        
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view = jitsiMeetView
        
        jitsiMeetView.join(options)
        
        pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        pipViewCoordinator?.show()
        
        //        vc.present(vc, animated: true, completion: nil)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func cleanUp() {
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
    }
}
