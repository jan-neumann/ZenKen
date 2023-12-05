//
//  BannerAdView.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 05.12.23.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewControllerRepresentable {
    
    @State private var viewWidth: CGFloat = .zero
    private let bannerView = GADBannerView()
    
    
    func makeUIViewController(context: Context) -> BannerViewController {
        let bannerViewController = BannerViewController()
        
        bannerView.adUnitID = Settings.adTestMode ? Settings.AdMobId.bannerAdTestId : Settings.AdMobId.bannerAdId
        bannerView.rootViewController = bannerViewController
        
        bannerViewController.view.addSubview(bannerView)
        // Tell the bannerViewController to update our Coordinator when the ad width changes
        bannerViewController.delegate = context.coordinator
        
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: BannerViewController, context: Context) {
//        guard viewWidth != .zero else { return }
        DispatchQueue.main.async {
            viewWidth = uiViewController.view.window?.screen.bounds.width ?? 728
            // Request a banner ad width with the updated viewWidth.
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
            bannerView.load(request)
        }
     
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate {
        
        let parent: BannerAdView
        
        init(parent: BannerAdView) {
            self.parent = parent
        }
        
        // MARK: - BannerViewControllerWidthDelegate methods
        
        func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
            // Pass the viewWidth from Coordinator to BannerView.
            parent.viewWidth = width
        }
        
        // MARK: - GADBannerViewDelegate methods
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("\(#function) called, error: \(error.localizedDescription)")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
             print("\(#function) called")
           }
    }
}
