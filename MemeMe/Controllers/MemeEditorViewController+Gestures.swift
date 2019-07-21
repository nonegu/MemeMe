//
//  MemeEditorViewController+Gestures.swift
//  MemeMe
//
//  Created by Ender Güzel on 21.07.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import UIKit

extension MemeEditorViewController {
    
    // MARK: Gesture method to zoom in & out image
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
    
    // MARK: Gesture method to move image
    @objc func panGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view)
        if let view = sender.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        sender.setTranslation(CGPoint.zero, in: sender.view)
    }
}
