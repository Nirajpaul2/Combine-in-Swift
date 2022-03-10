//
//  LoginDemoByLatestCombine.swift
//  CombineDemo
//
//  Created by Purplle on 10/03/22.
//

import UIKit
import Combine

class LoginDemoByLatestCombine: UIViewController {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var switchPrivacyPolicy: UISwitch!
    @IBOutlet weak var btnLoginOulet: UIButton!
    
    // Define publisher
    @Published private var acceptPolicy: Bool = false
    @Published private var firstName: String = ""
    @Published private var lastName: String = ""
    
    
    //Combine Publisher into singal stream
    private var validToSubmit: AnyPublisher<Bool,Never> {
        return Publishers.CombineLatest3($acceptPolicy, $firstName, $lastName).map { (policy,firstN,lastN) in
            return policy && !firstN.isEmpty && !lastN.isEmpty
        }.eraseToAnyPublisher()
    }
    
    var buttonSubscriber = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // Hook subscriber up to publisher
        validToSubmit.receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: btnLoginOulet)
            .store(in: &buttonSubscriber)
        
    }
    
    @IBAction func swicthAction(_ sender: UISwitch) {
        self.acceptPolicy = sender.isOn
        
    }
    
    @IBAction func firstNameAction(_ sender: UITextField) {
        self.firstName = sender.text ?? ""
    }
    
    @IBAction func lastNameAction(_ sender: UITextField) {
        self.lastName = sender.text ?? ""
    }
    
    
    @IBAction func btnLoginAction(_ sender: Any) {
   
    
    }
    
}

