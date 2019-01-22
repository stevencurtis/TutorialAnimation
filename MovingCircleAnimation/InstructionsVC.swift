//
//  InstructionsVC.swift
//  MovingCircleAnimation
//
//  Created by Steven Curtis on 21/01/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class InstructionsVC: UIViewController {
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var image : UIImage?
    var index : Int = 0
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = image {
            
            // instructionsLabel.text = index.description
            // imageView.image = image
            
//            switch (index) {
//            case 0 :  bgView.backgroundColor = UIColor.red
//            case 1: bgView.backgroundColor = UIColor.blue
//            case 2: bgView.backgroundColor = UIColor.orange
//            default :  bgView.backgroundColor = UIColor.clear
//            }
            
        }
    }
    
}
