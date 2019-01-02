//
//  CZRangeSliderTrackLayer.swift
//  CZRangeSlider
//
//  Created by Diego Contreras on 1/2/19.
//  Copyright © 2019 Diego Contreras. All rights reserved.
//

import Foundation
import UIKit

class CZRangeSliderTrackLayer: CALayer{
    
    weak var rangeSlider: CZRangeSlider?
    
    override func draw(in ctx: CGContext) {
        
        guard let slider = rangeSlider else{
            return
        }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.fillPath()
        
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let lowerValuePosition = slider.xPositionForValue(slider.lowerValue)
        let upperValuePosition = slider.xPositionForValue(slider.upperValue)
        let rect = CGRect(x: lowerValuePosition, y: 0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
        
        ctx.fill(rect)
    }
    
    
    
}
