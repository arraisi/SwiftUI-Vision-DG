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
    
    @State var jitsiMeetView: JitsiMeetView?
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let defaultOptions = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.serverURL = URL(string: "https://meet.jit.si")
            builder.welcomePageEnabled = false
        }
        
        JitsiMeet.sharedInstance().defaultConferenceOptions = defaultOptions
        
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let jitsiMeetView = JitsiMeetView()
        self.jitsiMeetView = jitsiMeetView
        
        let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
            builder.room = "123"
        }
        
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view = jitsiMeetView
        
        jitsiMeetView.join(options)
        vc.present(vc, animated: true, completion: nil)
    }
}
