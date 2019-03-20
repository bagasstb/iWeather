//
//  ChangeCityViewController.swift
//  iWheater
//
//  Created by bagasstb on 06/03/19.
//  Copyright © 2019 xProject. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnterCityName(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func getWheaterPressed(_ sender: iButton) {
        let cityName = changeCityTextField.text!
        
        delegate?.userEnterCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
