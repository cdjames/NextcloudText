//
//  WebViewController.swift
//  NextcloudText
//
//  Created by Collin James on 10/17/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import WebKit
import UIKit

class WebViewController: UIViewController, WKUIDelegate {
   
    //MARK: Properties
    @IBOutlet var loginWebView: WKWebView!
    var url: URL?
    
    //MARK: Initializers
    // convenient way to initiailize with nil object
    convenience init() {
        self.init(with: nil)
    }
    
    /**
     custom init method
     - Parameters:
         - url:object containing the necessary url
    */
    init(with url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    //if adding your own init method, must conform to super init protocol also
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: View Controller Functions
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        loginWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        loginWebView.uiDelegate = self
        view = loginWebView
    }
    //MARK: View Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        loginWebView.load(myRequest)
    }
}
