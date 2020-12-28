//
//  WebView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 27/11/20.
//

import WebKit
import SwiftUI


/// View created as a workaround implementation of UIWebView for SwiftUI
struct WebView: UIViewRepresentable {
    
    @Binding var readFinished: Bool
    
    /// String representation of the URL you want to open in the WebView.
    let urlString: String?
    private let  webview = WKWebView()
    
    func makeUIView(context: Context) -> WKWebView {
        webview.scrollView.delegate = context.coordinator
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: Context) {
        if let safeString = urlString, let url = URL(string: safeString) {
            let request = URLRequest(url)
            webview.load(request)
        }
        
    }
    
    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(webView: self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        private let parent : WebView
        
        init(webView : WebView) {
            self.parent = webView
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if self.parent.readFinished {
                let scrollPoint = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.size.height)
                scrollView.setContentOffset(scrollPoint, animated: false)
            }
            
            if (scrollView.contentOffset.y) > (scrollView.contentSize.height - scrollView.frame.size.height) {
                //bottom reached
                self.parent.readFinished = true
            }
        }
    }
    
}
