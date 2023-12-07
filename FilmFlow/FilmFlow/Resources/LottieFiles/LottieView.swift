//
//  LottieView.swift
//  FilmFlow
//
//  Created by Jonathan Onrubia Solis on 7/12/23.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    let loopMode: LottieLoopMode
    let animation: String
    var completion: (Bool) -> Void

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animation)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.play { finished in
            completion(finished)
        }
        return animationView
    }
}
