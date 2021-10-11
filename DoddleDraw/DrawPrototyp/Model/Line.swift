//
//  File.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-06-02.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import Foundation
import UIKit

class Line : NSObject, Codable {
    
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    
    required init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
