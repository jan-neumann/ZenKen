//
//  BannerViewController.swift
//  ZenKen
//
//  Created by Jan Alexander Neumann on 04.12.23.
//

import SwiftUI

// Delegate method for receiving width update messages
protocol BannerViewControllerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {
    weak var delegate: BannerViewControllerWidthDelegate?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Tell the delegate the initial ad width
        delegate?.bannerViewController(
            self,
            didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width
        )
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
            coordinator.animate { _ in
                // Do nothing
            } completion: { _ in
                // Notify the delegate of ad width changes.
                self.delegate?.bannerViewController(
                    self,
                    didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
            }
    }
    
    
}
