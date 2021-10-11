//
//  ColorViewController.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-05-31.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, HSBColorPickerDelegate {
    static var currentWidthValue: CGFloat = CGFloat(5)
    static var currentOpacityValue: Float = Float(1)
    static var currentColor: UIColor = UIColor.black

    override func viewDidLoad() {
        super.viewDidLoad()
        widthSlider.value = Float(ColorViewController.currentWidthValue)
        widthValueLable.text = String(format: "%.0f", ColorViewController.currentWidthValue)
        opacitySlider.value = ColorViewController.currentOpacityValue
        opacityValueLable.text = String(format: "%.1f", ColorViewController.currentOpacityValue)
        pickedColor.backgroundColor = ColorViewController.currentColor

        self.colorPicker.delegate = self
     }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var pickedColor: UIView!

    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var widthValueLable: UILabel!
    @IBAction func widthSlider(_ sender: UISlider) {
        ColorViewController.currentWidthValue = CGFloat(sender.value)
        
        widthValueLable.text = String(format: "%.0f", ColorViewController.currentWidthValue)
    }
    
    @IBOutlet weak var opacitySlider: UISlider!
    @IBOutlet weak var opacityValueLable: UILabel!
    @IBAction func opacitySlider(_ sender: UISlider) {
        ColorViewController.currentOpacityValue = sender.value        
        opacityValueLable.text = String(format: "%.1f", ColorViewController.currentOpacityValue)
    }
    
    @IBOutlet weak var colorPicker: HSBColorPicker!
    
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizerState) {
        ColorViewController.currentColor = color
        pickedColor.backgroundColor = ColorViewController.currentColor
    }
}


