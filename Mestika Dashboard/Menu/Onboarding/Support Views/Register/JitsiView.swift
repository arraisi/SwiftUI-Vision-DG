//
//  JitsiView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 17/12/20.
//

import UIKit
import SwiftUI
import JitsiMeetSDK

struct JitsiView: UIViewControllerRepresentable {
    
    @EnvironmentObject var appState: AppState
    
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
            
            NotificationCenter.default.post(name: NSNotification.Name("JitsiEnd"), object: nil)
            parent.presentationMode.wrappedValue.dismiss()
            parent.appState.moveToWelcomeView = true
        }
    }
    
    func makeCoordinator() -> JitsiView.Coordinator {
        Coordinator(parent: self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    func makeUIViewController(context: Context) -> UIViewController {
        
        let jitsiMeetView = JitsiMeetView()
        jitsiMeetView.delegate = context.coordinator
        DispatchQueue.main.async {
            self.jitsiMeetView = jitsiMeetView
        }
        
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL(string: AppConstants().JITSI_URL)
            builder.welcomePageEnabled = false
            builder.room = self.jitsi_room
            
            builder.setFeatureFlag("invite.enabled", withBoolean: false)
            builder.setFeatureFlag("live-streaming.enabled", withBoolean: false)
            builder.setFeatureFlag("overflow-menu.enabled", withBoolean: false)
            builder.setFeatureFlag("video-share.enabled", withBoolean: false)
            
        }
        
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view = jitsiMeetView
        
        jitsiMeetView.join(options)
        
        DispatchQueue.main.async {
            pipViewCoordinator = PiPViewCoordinator(withView: jitsiMeetView)
        }
        pipViewCoordinator?.show()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        uiViewController.
    }
    
    func cleanUp() {
        jitsiMeetView?.leave()
        jitsiMeetView?.hangUp()
        jitsiMeetView?.removeFromSuperview()
        jitsiMeetView = nil
    }
}
