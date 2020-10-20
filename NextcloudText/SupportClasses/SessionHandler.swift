//
//  SessionHandler.swift
//  NextcloudText
//
//  Created by Collin James on 10/18/20.
//  Copyright © 2020 Collin James. All rights reserved.
//

import Foundation
import os.log

class SessionHandler: URLSession, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    var successCbk: PollCbk?
    var receivedData: Data?
    var url: URL?
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration,
                          delegate: self, delegateQueue: nil)
    }()

    // convenient way to initiailize with nil object
    override convenience init() {
        self.init(with: nil)
    }

    init(with url: URL?) {
        self.successCbk = nil
        self.url = url
    }
    
    func startLoad(with url: URL, completionHandler: @escaping PollCbk, onFailure: VoidVoidCbk) {
        self.successCbk = completionHandler
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        receivedData = Data()
        let task = session.dataTask(with: request)
        task.resume()
    }

    //MARK: Delegate methods

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse,
        (200...299).contains(response.statusCode)
        else {
            completionHandler(.cancel)
            return
        }
        completionHandler(.allow)
    }


    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.receivedData?.append(data)
        guard let endpoint = PollLogin(from: receivedData!) else { return }
        self.successCbk!(endpoint)
        // if you get the endpoint and token, send it back to caller (in callback?)
//        DispatchQueue.main.async {
//            // must be run on the main queue
//            self.showAlert(for: (endpoint.poll!.token))
//        }
    }


    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                //handleClientError(error)
                os_log("Error %s", log: OSLog.default, type: .debug, error.localizedDescription)
            } else if let receivedData = self.receivedData,
                let string = String(data: receivedData, encoding: .utf8) {
//                self.webView.loadHTMLString(string, baseURL: task.currentRequest?.url)
                os_log("received valid response: %s", log: OSLog.default, type: .debug, string)
            }
        }
    }

}

