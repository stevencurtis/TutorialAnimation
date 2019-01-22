//
//  UIView.swift
//  CleanTableViews
//
//  Created by Steven Curtis on 16/01/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

extension UIView {
    
    func autoTranslateAnimationWithDistance(_ distance: Float, duration: Float? = 5.0) {
        
        //make sure the uiview is still visible otherwise stop animations, prevents CPU leaks.
        if(self.window == nil){
            return;
        }
        
        //self.transform gives the translation from last animation so we remove to the new target translation to stay within the distance limits
        //that way we always stay within distance
        let tx : CGFloat = CGFloat(Float.random(-distance , upper: distance) ) - self.transform.tx
        let ty : CGFloat = CGFloat(Float.random(-distance, upper: distance)) - self.transform.ty
        
        
        UIView.animate(withDuration: 5.0, delay: 0.0,
                       options: UIView.AnimationOptions(),
                       animations: {
                        self.transform = self.transform.translatedBy(x: tx, y: ty)
        }, completion: {
            (value: Bool) in
            self.autoTranslateAnimationWithDistance(distance)
        })
}

    
}
