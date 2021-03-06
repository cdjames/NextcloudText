//
//  ViewController.swift
//  NextcloudText
//
//  Created by Collin James on 10/13/20.
//  Copyright © 2020 Collin James. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var serverField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        serverField.delegate = self
        userNameField.delegate = self
        passwordField.delegate = self
        // disable button until fields are populated
        loginButton.isEnabled = false
    }
    
    //MARK: Helpers
    // from https://github.com/Arrlindii/AAValidators/blob/master/Validators/Validators/ViewController.swift
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func attemptLogin(_ sender: Any) {
        showAlert(for: "logged in!")
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // check the textfields
        guard serverField.text!.validURL, userNameField.text!.isNotEmpty, passwordField.text!.isNotEmpty else {
            loginButton.isEnabled = false
            return
        }
        
        // all fields are valid; show "Login" button
        loginButton.isEnabled = true
    }
}
