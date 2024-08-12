//
//  BlurView.swift
//  5GERS
//
//  Created by 이정동 on 8/12/24.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
  var style: UIBlurEffect.Style
  
  func makeUIView(context: Context) -> some UIView {
    let view = UIView(frame: .zero)
    view.backgroundColor = .clear
    
    let blurEffect = UIBlurEffect(style: style)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(blurView)
    
    NSLayoutConstraint.activate([
      blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
      blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
    ])
    
    return view
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {}
}
