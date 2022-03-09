//
//  PopUpViewController.swift
//  CombineDemo
//
//  Created by Purplle on 09/03/22.
//

import UIKit
import Combine

class PopUpViewController: UIViewController {

    @IBOutlet weak var presentSegmentControl: UISegmentedControl!
    @IBOutlet weak var presentSliderControl: UISlider!
    
    let passThroughSubject = PassthroughSubject<String,Never>()
    let currentValueSubject = CurrentValueSubject<Float,Never>(0.2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func btnSegmentAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
           
            passThroughSubject.send("First")
            currentValueSubject.value = 0.5
        case 1:
            passThroughSubject.send("Second")
            currentValueSubject.value = 0.7
        case 2:
            passThroughSubject.send("Third")
            currentValueSubject.value = 0.2
        default:
            break
        }
    }
    
    
    @IBAction func didChangeSlider(_ sender: UISlider) {
        
        let value = sender.value
        currentValueSubject.value = value
    
    }
    
    
    
}
