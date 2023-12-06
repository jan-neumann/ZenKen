//
//  InterstitialAdCoordinator.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 04.12.23.
//

import GoogleMobileAds
import SwiftUI

final class InterstitialAdCoordinator: NSObject {
    private var ad: GADInterstitialAd?
    
    func loadAd() {
        
        let request = GADRequest()
        
        request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        GADInterstitialAd.load(
            withAdUnitID: Settings.adTestMode ? Settings.AdMobInfo.interstitialAdTestId : Settings.AdMobInfo.interstitialAdId,
            request: request) { ad, error in
                if let error = error {
                    print(">> Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                print(">> Interstitial ad load successful.")
      
                self.ad = ad
                self.ad?.fullScreenContentDelegate = self
            }
    }
    
    func presentAd(from viewController: UIViewController) {
        guard let fullscreenAd = ad else {
            print(">> Ad wasn't ready.")
            return
        }
        print(">> Present interstitial ad.")
        fullscreenAd.present(fromRootViewController: viewController)
    }
}

extension InterstitialAdCoordinator: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print(">> Ad did fail to present full screen content. \(error.localizedDescription)")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(">> Ad will present full screen content. \(ad.description)")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(">> Ad did dismiss full screen content.")
        // TODO: load another ad here
        self.ad = nil
    }
}
