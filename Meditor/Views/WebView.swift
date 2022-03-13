//
//  WebView.swift
//  Meditor
//
//  Created by Zed on 10/3/2022.
//

import Foundation
import WebKit
import SwiftUI

///
struct WebView: NSViewRepresentable {
    // https://developer.apple.com/forums/thread/126986
    
    var html: String
    var view: WKWebView
    
    
    
    init(html: String) {
        self.view = WKWebView()
        self.html = html
    }
    
    func makeCoordinator() -> WebView.Coordinator {
           Coordinator(self)
    }
    
    func makeNSView(context: Context) -> WKWebView {
        self.view.navigationDelegate = context.coordinator
        return self.view
    }

    func updateNSView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(self.html, baseURL: nil)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
           let parent: WebView

            init(_ parent: WebView) {
               self.parent = parent
            }

        
            func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                // force links to open in external web browser
                if navigationAction.navigationType == .linkActivated {
                   if let url = navigationAction.request.url {
                       NSWorkspace.shared.open(url)
                       decisionHandler(.cancel)
                   }
                } else {
                   decisionHandler(.allow)
                }
            }
       }
}

