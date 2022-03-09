//
//  SubjectViewController.swift
//  CombineDemo
//
//  Created by Purplle on 09/03/22.
//

import UIKit
import Combine
class SubjectViewController: UIViewController {

    @IBOutlet weak var lblSegmentValue: UILabel!
    @IBOutlet weak var lblSliderValue: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnAction(_ sender: Any) {
        
        guard let popUpVc: PopUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpViewController") as? PopUpViewController else {
            return
        }
        
        if let sheet = popUpVc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }
        
        popUpVc.passThroughSubject.sink { value in
            self.lblSegmentValue.text = value
        }.store(in: &cancellables)
        
        popUpVc.currentValueSubject.sink { floatValue in
            self.lblSliderValue.text = "\(floatValue)"
        }.store(in: &cancellables)
        
        self.present(popUpVc, animated: true, completion: nil)
    }
    
    
}
