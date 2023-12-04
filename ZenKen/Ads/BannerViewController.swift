//
//  BannerViewController.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 04.12.23.
//

import SwiftUI

// TODO: Implement: https://developers.google.com/admob/ios/swiftui

// Delegate method for receiving width update messages
protocol BannerViewControllerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {
    
}
