//
//  GifImage.swift
//  5GERS
//
//  Created by 이정동 on 8/12/24.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
  private let name: String
  
  init(_ name: String){
    self.name = name
  }
  
  func makeUIView(context: Context) -> some WKWebView {
    let webView = WKWebView()
    
    let url = Bundle.main.url(forResource: name, withExtension: "gif")!
    
    let data = try! Data(contentsOf: url)
    
    webView.load(
      data,
      mimeType: "image/gif",
      characterEncodingName: "UTF-8",
      baseURL: url.deletingLastPathComponent()
    )
    
    webView.scrollView.isScrollEnabled = false
    
    return webView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.reload()
  }
}
