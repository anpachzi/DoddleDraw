//
//  MainImageView.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-02-19.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import UIKit

class MainImageView: UIImageView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        print(location.x)
        print(location.y)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
