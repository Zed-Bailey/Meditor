//
//  WebView.swift
//  Meditor
//
//  Created by Zed on 10/3/2022.
//

import Foundation
import WebKit
import SwiftUI

//TODO: Force links to open in external browser
struct WebView: NSViewRepresentable {
    var html: String
    var view: WKWebView
    
    init(html: String) {
        self.view = WKWebView()
//        self.view.navigationDelegate = s
        self.html = html
    }

    func makeNSView(context: Context) -> WKWebView {
        return self.view
    }

    func updateNSView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}
 
//class NavigationDelegate: WKNavigationDelegate {}

//class NavigationDelegate: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//    }
//}
