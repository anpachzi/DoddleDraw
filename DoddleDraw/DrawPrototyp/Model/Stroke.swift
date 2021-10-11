//
//  Stroke.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-06-27.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import Foundation
import UIKit

class Stroke : NSObject, Codable {
    
    var lines = [Line]()
    var color = UIColor()
    var width = CGFloat()
    var opacity = Float()

    enum CodingKeys: String, CodingKey {
        case lines
        case color
        case width
        case opacity
    }
    
    func addLinePoint(point:CGPoint) {
        
        let lastLine = lines.last
        let line = Line(startPoint: lastLine!.endPoint, endPoint: point)
        lines.append(line)
    }
    
    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        if(lines.count>0) {
            path.move(to: lines.first!.startPoint)
        }
        for line in lines {
            path.move(to: line.startPoint)
            path.addLine(to: line.endPoint)
        }
        return path;
    }
    
    required init(startPoint: CGPoint, endPoint: CGPoint) {
        lines.append(Line(startPoint: startPoint, endPoint: endPoint))
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lines = try container.decode([Line].self, forKey: .lines)

        let colorData = try container.decode(Data.self, forKey: .color)
        color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor ?? UIColor.black
        
        width = try container.decode(CGFloat.self, forKey: .width)
        opacity = try container.decode(Float.self, forKey: .opacity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(lines, forKey: .lines)

        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        try container.encode(colorData, forKey: .color)
        
        try container.encode(width, forKey: .width)
        try container.encode(opacity, forKey: .opacity)
    }
}
