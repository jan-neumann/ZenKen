//
//  InterstitialAdView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 04.12.23.
//

import SwiftUI
import GoogleMobileAds

struct InterstitialAdView: UIViewControllerRepresentable {
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        viewController.view.frame = UIScreen.main.bounds
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
