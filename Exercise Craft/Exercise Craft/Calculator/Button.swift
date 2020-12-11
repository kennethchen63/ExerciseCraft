//
//  Button.swift
//  Exercise Craft
//
//  Created by Kenneth Chen on 12/6/20.
//  Copyright © 2020 Kenneth Chen. All rights reserved.
//  Reference: https://www.youtube.com/watch?v=jWobdUlUWQ0&list=WL&index=7
//

import UIKit

class BounceButton: UIButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: { self.transform = CGAffineTransform.identity }, completion: nil)
        
        super.touchesBegan(touches, with: event)
    }
}
