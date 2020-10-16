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
    @IBOutlet weak var pathField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let HTTPS = "https"
    let LOGIN_PREDICATE = "/index.php/login/v2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        serverField.delegate = self
        pathField.delegate = self
        userNameField.delegate = self
        passwordField.delegate = self
        // check the textfields and activate or deactivate
        activateButton(checkFields()) // try for rounded button: https://nshipster.com/ibinspectable-ibdesignable/
    }
    
    //MARK: Helpers
    // from https://github.com/Arrlindii/AAValidators/blob/master/Validators/Validators/ViewController.swift
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func activateButton(_ activate: Bool = true)
    {
        if activate {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.systemBlue
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.lightGray
        }
    }
    
    func checkFields() -> Bool{
        guard serverField.text!.isValidURL, userNameField.text!.isNotEmpty, passwordField.text!.isNotEmpty else {
            // problem with fields
            return false
        }
        
        pathField.text!.trimRight(all: "/")
//        let first = pathField.text!.first
//        let second = pathField.text!.substring(to: <#T##String.Index#>)
//        while pathField.text!.first == "/" && pathField.text![] {
//            <#code#>
//        }
        
        return true
    }
    
    //MARK: Actions
    @IBAction func attemptLogin(_ sender: Any) { // loginButton action
        guard let server = serverField.text else { return }
        guard let usr = userNameField.text else { return }
        guard let psswd = passwordField.text else { return }
//        path += LOGIN_PREDICATE
        
        var components = URLComponents()
        components.scheme = HTTPS
        components.host = server
        components.path = "/" + (pathField.text ?? "") + LOGIN_PREDICATE
//        components.path = (pathField.text ?? "") + LOGIN_PREDICATE
//        guard let url = UrlBuilder.create(withScheme: HTTPS, hostedBy: server, atPath: LOGIN_PREDICATE).url else { return }
        guard let url = components.url else { return }

        showAlert(for: url.absoluteString) // testing only

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
        // check the textfields and activate or deactivate
        activateButton(checkFields())
    }
    
    func textField(_ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
          replacementString string: String) -> Bool
    {
        switch textField {
        case pathField:
            guard string.isValidFolderChar else { return false }
            if range.location == 0 {
                guard string != "/" else { return false }
            }

            return true
        default:
            return true
        }
    }
}
