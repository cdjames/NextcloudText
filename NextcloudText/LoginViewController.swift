//
//  ViewController.swift
//  NextcloudText
//
//  Created by Collin James on 10/13/20.
//  Copyright © 2020 Collin James. All rights reserved.
//
import UIKit
import os.log

class LoginViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    //MARK: Properties
    @IBOutlet weak var serverField: UITextField!
    @IBOutlet weak var pathField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    //MARK: Initializers    
    //if adding your own init method, must conform to super init protocol also
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: View Controller Functions
    override func viewDidLoad()
    {
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
    /**
     Raise an alert to the user
     - Parameters:
        - alert: a message to the user
     */
    func showAlert(for alert: String)
    {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: ALRT_BTN_TXT, style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    /**
     Activates the login button
     - Parameters:
        - activate: true to enable, false to disable. True by default
     */
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
    
    /**
     Checks all the text fields for appropriate values
     - Returns:
     - true or false
     */
    func checkFields() -> Bool
    {
        pathField.text!.trimRight(all: FWD_SLASH)
        
        guard serverField.text!.isValidURL, userNameField.text!.isNotEmpty, passwordField.text!.isNotEmpty else {
            // problem with fields
            return false
        }
        
        return true
    }
    
    /**
     Checks all the text fields for appropriate values
     - Returns:
     - true or false
     */
    func getLoginEndpoint(startingAt url: URL) -> Bool
    {
        return true
    }
    
//    func endpointLoadCompletion (_ data: Data?, _ rsp: URLResponse?, _ err: Error?) {
//        os_log(.debug, "%s", URLResponse.debugDescription())
//    }
    
    func endpointLoadCompletion (_ endpoint: PollLogin?) {
        os_log(.debug, "printing from callback: \n%s", endpoint!.poll!.token)
    }

    func endpointFailure() {
        os_log(.debug, "load failed")
    }
    //MARK: Actions
    /**
    Checks all the text fields for appropriate values
     - Returns:
        - true or false
     */
    @IBAction func attemptLogin(_ sender: Any) // loginButton action
    {
        // check the textfields and activate or deactivate
        activateButton(checkFields())
        guard (loginButton.isEnabled == true) else { return }
        guard let server = serverField.text else { return }
        let path = (pathField.text ?? EMPTY) + LOGIN_PREDICATE
        #if DEBUG
        guard let url = UrlBuilder(with: HTTP, at: server, opt: path).getUrl() else { return } // testing
        #else
        guard let url = UrlBuilder(with: HTTPS, at: server, opt: path).getUrl() else { return } // production
        #endif

        //TODO: get the login url for the user and the polling endpoint
        //1. send post message to login v2
        let session = SessionHandler()
        session.startLoad(with: url, completionHandler: endpointLoadCompletion, onFailure: endpointFailure)
        //2. get URL returned or error
        //3. send user to that
//        showAlert(for: url.absoluteString) // testing only
//        let wv = WebViewController(with: url)
//        self.present(wv, animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Hide the keyboard.
        textField.resignFirstResponder()
        // Move focus to next field
        switch textField {
        case serverField:
            pathField.becomeFirstResponder()
        case pathField:
            userNameField.becomeFirstResponder()
        case userNameField:
            passwordField.becomeFirstResponder()
        case passwordField:
            loginButton.becomeFirstResponder()
        default:
            return true
        }
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
        // don't allow user to begin path with forward slash
        case pathField:
            guard string.isValidFolderChar else { return false }
            if range.location == 0 {
                guard string != FWD_SLASH else { return false }
            }

            return true
        default:
            return true
        }
    }
    

    //MARK: Delegate methods
}
