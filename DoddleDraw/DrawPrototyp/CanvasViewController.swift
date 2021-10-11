//
//  ViewController.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-02-19.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController
{
    @IBOutlet var CanvasView: UIView!
    @IBOutlet weak var pageNumLable: UILabel!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var brushEditButton: UIButton!
    @IBOutlet weak var lastPage: UIButton!
    @IBOutlet weak var prePage: UIButton!
    @IBOutlet weak var firstPage: UIButton!
    
    var book: Book!
    var canvas = Page()
    var pageNumber = Int(0)
    var path = UIBezierPath()
    var currentStroke : Stroke?
    var prevDragPoint = CGPoint()
    var removedContainer = Page()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CanvasView.clipsToBounds = true
        CanvasView.isMultipleTouchEnabled = false
        pageNumLable.text = String(pageNumber+1)
        removedContainer.strokes.removeAll()
        
        brushEditButton.layer.cornerRadius = 10
        removeButton.layer.cornerRadius = 10
        undoButton.layer.cornerRadius = 10
        // If previous pages found then create inital page
        if(book.pages.count==0) {
            book.pages.append(canvas)
        } else {
            canvas = book.pages[0]
            reDrawCanvas()
        }
        toggleUndoButton()
        toggleRemoveButton()
        toggleRemoveButton()
        togglePreAndFirstPage()
        toggleLastPage()
    }
    
    func toggleUndoButton() {
        if (removedContainer.strokes.isEmpty) {
            undoButton.isEnabled = false
            undoButton.alpha = 0.5
        } else {
            undoButton.isEnabled = true
            undoButton.alpha = 1
        }
    }
    
    func toggleRemoveButton() {
        if (canvas.strokes.isEmpty) {
            removeButton.isEnabled = false
            removeButton.alpha = 0.5
        } else {
            removeButton.isEnabled = true
            removeButton.alpha = 1
        }
    }
    
    func toggleLastPage() {
        if (pageNumber == book.pages.count - 1 ) {
            lastPage.isEnabled = false
            lastPage.alpha = 0.5
        } else {
            lastPage.isEnabled = true
            lastPage.alpha = 1
        }
    }
    
    func togglePreAndFirstPage() {
        if (pageNumber == 0) {
            prePage.isEnabled = false
            prePage.alpha = 0.5
            firstPage.isEnabled = false
            firstPage.alpha = 0.5
        } else {
            prePage.isEnabled = true
            prePage.alpha = 1
            firstPage.isEnabled = true
            firstPage.alpha = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removedContainer.strokes.removeAll()
        toggleUndoButton()
        
        let touch = touches.first
        if let point = touch?.location(in: CanvasView) {
            self.prevDragPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: CanvasView) {
            // Update bezier path, the view model
            path.move(to: self.prevDragPoint)
            path.addLine(to: point)
            draw()
            
            // Update the model
            if(currentStroke == nil) {
                self.currentStroke = Stroke(startPoint: self.prevDragPoint, endPoint: point)
                self.currentStroke!.color = ColorViewController.currentColor
                self.currentStroke!.width = ColorViewController.currentWidthValue
                self.currentStroke!.opacity = ColorViewController.currentOpacityValue
                canvas.strokes.append(currentStroke!)
            } else {
                self.currentStroke?.addLinePoint(point: point)
            }
            
            // Remeber latest drag point
            self.prevDragPoint = point
        }
        
        // If brush stroke is too long, start a new brush stroke
        if((CanvasView.layer.sublayers!.capacity) > 100) {
            self.currentStroke = nil
            self.path = UIBezierPath()
            
            reDrawCanvas()
            toggleRemoveButton()
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentStroke = nil
        self.path = UIBezierPath()
        
        reDrawCanvas()
        toggleRemoveButton()
    }
    
    // Main draw function
    func draw() {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = CGFloat(ColorViewController.currentWidthValue)
        strokeLayer.lineCap = kCALineCapRound;
        strokeLayer.strokeColor = ColorViewController.currentColor.cgColor
        strokeLayer.opacity = ColorViewController.currentOpacityValue
        strokeLayer.path = path.cgPath
        CanvasView.layer.addSublayer(strokeLayer)
    }

    func reDrawCanvas() {
        CanvasView.layer.sublayers = nil
        for stroke in canvas.strokes {
            let strokeLayer = CAShapeLayer()
            strokeLayer.fillColor = nil
            strokeLayer.lineWidth = stroke.width
            strokeLayer.lineCap = kCALineCapRound;
            strokeLayer.strokeColor = stroke.color.cgColor
            strokeLayer.opacity = stroke.opacity
            strokeLayer.path = stroke.createBezierPath().cgPath
            CanvasView.layer.addSublayer(strokeLayer)
        }
        CanvasView.setNeedsDisplay()
    }
    
    @IBAction func savedBooks(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func brushEdit(_ sender: UIButton) {}
    
    @IBAction func removeButton(_ sender: UIButton) {
        removedContainer.strokes.append(canvas.strokes.last!)
        canvas.strokes.removeLast()
        reDrawCanvas()
        toggleUndoButton()
        print("***********")
        print("Line erased")
        print("***********")
        toggleRemoveButton()
    }
    
    @IBAction func undoButton(_ sender: UIButton) {
        canvas.strokes.append(removedContainer.strokes.last!)
        removedContainer.strokes.removeLast()
        reDrawCanvas()
        toggleRemoveButton()
        toggleUndoButton()
    }
    
    @IBAction func nextPage(_ sender: UIButton) {
        removedContainer.strokes.removeAll()
        
        pageNumber = pageNumber + 1
        if (book.pages.count > pageNumber) {
            canvas = book.pages[pageNumber]
            print("*********")
            print("Next page")
            print("*********")
        } else {
            canvas = Page()
            book.pages.append(canvas)
            print("********")
            print("New page")
            print("********")
        }
        toggleUndoButton()
        toggleRemoveButton()
        toggleRemoveButton()
        togglePreAndFirstPage()
        toggleLastPage()
        pageNumLable.text = String(pageNumber+1)
        reDrawCanvas()
    }
    
    @IBAction func lastPage(_ sender: UIButton) {
        removedContainer.strokes.removeAll()
        pageNumber = book.pages.count - 1
        canvas = book.pages.last!
        pageNumLable.text = String(pageNumber + 1)
        reDrawCanvas()
        toggleUndoButton()
        toggleRemoveButton()
        toggleRemoveButton()
        togglePreAndFirstPage()
        toggleLastPage()
    }
    
    @IBAction func prePage(_ sender: UIButton) {
        if (pageNumber != 0) {
            removedContainer.strokes.removeAll()
            
            pageNumber = pageNumber - 1
            canvas = book.pages[pageNumber]
            print("************")
            print("Previus page")
            print("************")
        } else {
            print("***************")
            print("No Previus page")
            print("***************")
        }
        toggleUndoButton()
        toggleRemoveButton()
        toggleRemoveButton()
        togglePreAndFirstPage()
        toggleLastPage()
        pageNumLable.text = String(pageNumber+1)
        reDrawCanvas()
    }
    
    @IBAction func firstPage(_ sender: UIButton) {
        if (pageNumber != 0) {
            removedContainer.strokes.removeAll()
            pageNumber = 0
            canvas = book.pages.first!
            pageNumLable.text = String(pageNumber + 1)
            reDrawCanvas()
        } else {
            print("***************")
            print("No Previus page")
            print("***************")
        }
        toggleUndoButton()
        toggleRemoveButton()
        togglePreAndFirstPage()
        toggleLastPage()
    }
}
