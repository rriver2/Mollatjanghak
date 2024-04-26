//
//  WebView.swift
//  janghakhere
//
//  Created by Gaeun Lee on 4/27/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    enum WorkState: String {
        case initial
        case done
        case working
        case errorOccurred
        case tryagain
    }
    
    @Binding var workState: WorkState
    var url: URL
    
    init(workState: Binding<WorkState>, url: URL) {
        self._workState = workState
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        switch self.workState {
        case .initial:
            uiView.load(URLRequest(url: url))
        case .tryagain:
            uiView.reload()
        default:
            break
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.parent.workState = .working
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.parent.workState = .errorOccurred
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.workState = .done
        }
       
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
                self.parent.workState = .errorOccurred
        }
        
        init(_ parent: WebView) {
            self.parent = parent
        }
    }
}
