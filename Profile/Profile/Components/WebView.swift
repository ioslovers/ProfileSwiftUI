//
//  WebView.swift
//  Profile
//
//  Created by Ashish Tripathi on 14/9/21.
//

import SwiftUI
import WebKit

public struct WebView : UIViewRepresentable {
    let request: URLRequest
    public func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}
