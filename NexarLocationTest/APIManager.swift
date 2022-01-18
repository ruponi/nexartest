//
//  APIManager.swift
//  NexarLocationTest
//
//  Created by Ruslan Ponomarenko on 1/18/22.
//

import Foundation
import Combine

class APIManager: NSObject {
    private var baseURL: URL
    private
    
    init?(baseURL: URL?) {
       
        if let url = baseURL {
            self.baseURL = url
          
        } else {
            return nil
        }
        
    }
    
    func uploadFileList(url:URL){
        
        let request = URLRequest(url: baseURL.appendingPathComponent("test"))
        let config = URLSessionConfiguration.background(withIdentifier: url.absoluteString)
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.uploadTask(with: request, fromFile: url)
    
        task.resume()

    }
          
    }


extension APIManager: URLSessionDelegate, URLSessionDataDelegate {
   
     func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error {
                print (error.localizedDescription)
            } else {
                //delete file which was uploaded
                
                if let path = session.configuration.identifier, let fileURL = URL.init(string: path) {
                           INFileManager.deleteFile(atUrl: fileURL)
                       }
            }
        }
}
