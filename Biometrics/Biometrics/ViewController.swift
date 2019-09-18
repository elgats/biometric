//
//  ViewController.swift
//  Biometrics
//
//  Created by Elga Theresia  on 17/09/19.
//  Copyright © 2019 Elga Theresia . All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var myView: UIView!
    
    var context = LAContext()
    var state = AuthenticationState.loggedout {
        didSet{
            button.isHighlighted = state == .loggedin
            myView.backgroundColor = state == .loggedin ? .green : .red
            label.isHidden = (state == .loggedin) || (context.biometryType != .faceID)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // The biometryType, which affects this app's UI when state changes, is only meaningful
        //  after running canEvaluatePolicy. But make sure not to run this test from inside a
        //  policy evaluation callback (for example, don't put next line in the state's didSet
        //  method, which is triggered as a result of the state change made in the callback),
        //  because that might result in deadlock.
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
        
    }

    @IBAction func buttonTap(_ sender: Any) {
        if state == .loggedin{
        state = .loggedout
            
        } else {
            context = LAContext ()
            context.localizedCancelTitle = "Enter Username/Password"
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Log in to your account"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                    if success {
                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async { [unowned self] in
                            self.state = .loggedin
                        }
                    } else {
                        print(error?.localizedDescription ?? "Can't evaluate policy")
                        // Fall back to a asking for username and password.
                    }
                }
            }
        }
    }
}

