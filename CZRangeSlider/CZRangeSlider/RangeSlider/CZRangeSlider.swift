//
//  CZRangeSlider.swift
//  CZRangeSlider
//
//  Created by Diego Contreras on 1/2/19.
//  Copyright © 2019 Diego Contreras. All rights reserved.
//

import Foundation
import UIKit

class CZRangeSlider : UIControl{
    
    var minimumValue : CGFloat! = 0.0 {
        didSet{
            updateLayerFrames()
        }
    }
    
    var maximumValue : CGFloat! = 1.0 {
        didSet{
            updateLayerFrames()
        }
    }
    
    var lowerValue : CGFloat! = 0.3 {
        didSet{
            updateLayerFrames()
        }
    }
    
    var upperValue : CGFloat! = 0.7 {
        didSet{
            updateLayerFrames()
        }
    }
    
    var trackHeight : CGFloat! = 2{
        didSet{
            updateLayerFrames()
        }
    }
    
    var trackTintColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1){
        didSet{
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1)
    {
        didSet{
            trackLayer.setNeedsDisplay()
        }
    }
    
    var thumbImage : UIImage! = UIImage(named: "CZRangeSliderThumb"){
        didSet{
            lowerThumbImageView.image = thumbImage
            upperThumbImageView.image = thumbImage
            updateLayerFrames()
        }
    }
    
    var highlightedThumbImage : UIImage! = UIImage(named: "CZRangeSliderThumb") {
        didSet {
            upperThumbImageView.highlightedImage = highlightedThumbImage
            lowerThumbImageView.highlightedImage = highlightedThumbImage
            updateLayerFrames()
        }
    }
    
    
    private let trackLayer = CZRangeSliderTrackLayer()
    private let lowerThumbImageView = UIImageView()
    private let upperThumbImageView = UIImageView()
    
    private var previousLocation = CGPoint()
    
    override var frame : CGRect{
        didSet{
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbImageView.image = thumbImage
        lowerThumbImageView.highlightedImage = highlightedThumbImage
        addSubview(lowerThumbImageView)
        
        upperThumbImageView.image = thumbImage
        upperThumbImageView.highlightedImage = highlightedThumbImage
        addSubview(upperThumbImageView)
        
        updateLayerFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLayerFrames(){
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = CGRect(x: 0, y: (self.frame.height / 2.0 - trackHeight / 2.0), width: bounds.width, height: trackHeight)
        trackLayer.cornerRadius = trackLayer.frame.height / 2.0
        trackLayer.setNeedsDisplay()
        
        lowerThumbImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue), size: thumbImage.size)
        upperThumbImageView.frame = CGRect(origin: thumbOriginForValue(upperValue), size: thumbImage.size)
        
        CATransaction.commit()
        
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
    
    private func thumbOriginForValue (_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - thumbImage.size.width / 2.0
        return CGPoint(x: x, y: (bounds.height - thumbImage.size.height) / 2.0)
    }
}


extension CZRangeSlider{
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        
        previousLocation = touch.location(in: self)
        
        if lowerThumbImageView.frame.contains(previousLocation){
            lowerThumbImageView.isHighlighted = true
        }else if upperThumbImageView.frame.contains(previousLocation){
            upperThumbImageView.isHighlighted = true
        }
        
        
        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = deltaLocation / bounds.width
        
        previousLocation = location
        
        if lowerThumbImageView.isHighlighted{
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        }else if upperThumbImageView.isHighlighted{
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbImageView.isHighlighted = false
        upperThumbImageView.isHighlighted = false
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
}
