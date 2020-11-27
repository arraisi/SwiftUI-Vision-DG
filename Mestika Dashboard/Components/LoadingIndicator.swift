//
//  LoadingIndicator.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 08/10/20.
//

import SwiftUI

struct LoadingIndicator: UIViewRepresentable {

    let style: UIActivityIndicatorView.Style
       @Binding var animate: Bool

       private let spinner: UIActivityIndicatorView = {
           $0.hidesWhenStopped = true
           return $0
       }(UIActivityIndicatorView(style: .medium))

       func makeUIView(context: UIViewRepresentableContext<LoadingIndicator>) -> UIActivityIndicatorView {
           spinner.style = style
           return spinner
       }

       func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingIndicator>) {
           animate ? uiView.startAnimating() : uiView.stopAnimating()
       }

       func configure(_ indicator: (UIActivityIndicatorView) -> Void) -> some View {
           indicator(spinner)
           return self
       }
    
}
