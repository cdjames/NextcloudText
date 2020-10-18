////
////  SessionHandler.swift
////  NextcloudText
////
////  Created by Collin James on 10/18/20.
////  Copyright © 2020 Collin James. All rights reserved.
////
//
//import Foundation
//import os.log
//
//class SessionHandler {
//
//    var receivedData: Data?
//    var url: URL?
//    private lazy var session: URLSession = {
//        let configuration = URLSessionConfiguration.default
//        configuration.waitsForConnectivity = true
//        return URLSession(configuration: configuration,
//                          delegate: self, delegateQueue: nil)
//    }()
//
//    // convenient way to initiailize with nil object
//    convenience init() {
//        self.init(with: nil)
//    }
//
//    init(with url: URL?) {
//        self.url = url
//    }
//
//    func startLoad(with url: URL) {
//        self.url = url
//        var request = URLRequest(url: self.url!)
//        request.httpMethod = "POST"
//        receivedData = Data()
////        let task = session.dataTask(with: request)
//        let url2 = URL(string: "https://google.com/")!
//        let task = session.dataTask(with: url2)
////        let task = session.dataTask(with: self.url!)
//        task.resume()
//    }
//
//
//    //MARK: Delegate methods
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
//                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//        guard let response = response as? HTTPURLResponse,
//            (200...299).contains(response.statusCode),
//            let mimeType = response.mimeType,
//            mimeType == "text/html" else {
//            completionHandler(.cancel)
//            return
//        }
//        completionHandler(.allow)
//    }
//
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        self.receivedData?.append(data)
//    }
//
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        DispatchQueue.main.async {
//            if let error = error {
//                //handleClientError(error)
//                os_log("Error", log: OSLog.default, type: .debug)
//            } else if let receivedData = self.receivedData,
//                let string = String(data: receivedData, encoding: .utf8) {
////                self.webView.loadHTMLString(string, baseURL: task.currentRequest?.url)
//                os_log("received valid response", log: OSLog.default, type: .debug)
//            }
//        }
//    }
//
//}
//
////extension SessionHandler: URLSessionDelegate {
//    func isEqual(_ object: Any?) -> Bool {
//        <#code#>
//    }
//
//    var hash: Int {
//        <#code#>
//    }
//
//    var superclass: AnyClass? {
//        <#code#>
//    }
//
//    func `self`() -> Self {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//
//    func isProxy() -> Bool {
//        <#code#>
//    }
//
//    func isKind(of aClass: AnyClass) -> Bool {
//        <#code#>
//    }
//
//    func isMember(of aClass: AnyClass) -> Bool {
//        <#code#>
//    }
//
//    func conforms(to aProtocol: Protocol) -> Bool {
//        <#code#>
//    }
//
//    func responds(to aSelector: Selector!) -> Bool {
//        <#code#>
//    }
//
//    var description: String {
//        <#code#>
//    }
//
//
//}
