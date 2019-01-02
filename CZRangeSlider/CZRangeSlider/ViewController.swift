//
//  ViewController.swift
//  CZRangeSlider
//
//  Created by Diego Contreras on 1/2/19.
//  Copyright © 2019 Diego Contreras. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rangeSlider = CZRangeSlider(frame: CGRect(x: 20, y: 100, width: 200, height: 32))
        self.view.addSubview(rangeSlider)
        
        let slider = UISlider(frame: CGRect(x: 20, y: 130, width: 200, height: 40))
        self.view.addSubview(slider)
    }


}

