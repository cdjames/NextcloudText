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
    var failureCbk: VoidVoidCbk?
    var pollingCbk: AppLoginCbk?
    var pollingRequest: URLRequest?
    var receivedData: Data?
    var url: URL?
    private lazy var initialSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration,
                          delegate: self, delegateQueue: nil)
    }()
    private lazy var pollingSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration,
                          delegate: self, delegateQueue: nil)
    }()
    var stopPoll: Bool

    // convenient way to initiailize with nil object
    override convenience init() {
        self.init(with: nil)
    }

    init(with url: URL?) {
        self.pollingRequest = nil
        self.successCbk = nil
        self.failureCbk = nil
        self.pollingCbk = nil
        self.url = url
        self.stopPoll = false
    }
    
    func startLoad(with url: URL, completionHandler: @escaping PollCbk, pollingCompletion: @escaping AppLoginCbk, onFailure: @escaping VoidVoidCbk) {
        self.successCbk = completionHandler
        self.pollingCbk = pollingCompletion
        self.failureCbk = onFailure
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        receivedData = Data()
        let task = initialSession.dataTask(with: request)
        task.resume()
        self.stopPoll = false
    }
    
    func startPollingRequest() {
        self.receivedData = Data()
        let task = self.pollingSession.dataTask(with: self.pollingRequest!)
        task.resume()
    }
    
    func assemblePollingRequest(with info: PollLogin) -> URLRequest {
        let headers: [String:String] = ["Content-Type" : "application/x-www-form-urlencoded"]
        var body = URLComponents()
        body.queryItems = [URLQueryItem(name: "token", value: info.poll!.token)]
        var request = URLRequest(url: info.poll!.endpoint)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = body.query?.data(using: .utf8)
        
        return request
    }

    //MARK: Delegate methods

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse else { return }
        
        if (200...299).contains(response.statusCode) {
            // done, grab the data in the next callback
            completionHandler(.allow)
        } else {
            completionHandler(.cancel)
            guard self.stopPoll == false else { return }
            switch session {
            case self.pollingSession:
                // keep trying until you get 200 (keep track of how many times?)
                //https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(POLL_SEC), qos: .utility)
                {
                    self.startPollingRequest()
                }
                break
            default: break
            }
        }
    }


    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard self.stopPoll == false else { return }
        switch session {
        case self.initialSession:
            self.receivedData?.append(data)
            guard let endpoint = PollLogin(from: receivedData!) else {
                self.failureCbk!()
                return
            }
            // if you get the endpoint and token, send it back to caller in callback
            self.successCbk!(endpoint)

            // now start polling
            self.pollingRequest = assemblePollingRequest(with: endpoint)
            startPollingRequest()
        case self.pollingSession:
            /* data in this form
            {
                "server":"https:\/\/cloud.example.com",
                "loginName":"username",
                "appPassword":"yKTVA4zgxjfivy52WqD8kW3M2pKGQr6srmUXMipRdunxjPFripJn0GMfmtNOqOolYSuJ6sCN"
            } */
            self.receivedData?.append(data)
            guard let creds = AppLoginCreds(from: self.receivedData!) else {
                self.failureCbk!()
                return
            }
                // if you get the credentials, send it back to caller in callback
            self.pollingCbk!(creds)
        default:
            return
        }
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

