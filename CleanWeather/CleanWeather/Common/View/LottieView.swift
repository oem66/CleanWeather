//
//  LottieView.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 27. 2. 2024..
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    let lottieFile: String
    let animationView = LottieAnimationView()
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        animationView.loopMode = .loop
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
