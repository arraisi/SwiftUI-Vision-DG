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

    /// String representation of the URL you want to open in the WebView.
    let urlString: String?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = urlString, let url = URL(string: safeString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

}
