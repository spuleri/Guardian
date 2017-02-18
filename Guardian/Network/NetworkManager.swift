//
//  NetworkManager.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

typealias JSONObj = [String: AnyObject]

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    let base = "https://guardian-api.herokuapp.com/"
    
    func sampleGet() {
        // Set up the URL request
        let endpoint = base + "test"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        makeGETRequest(url: url)
    }
    
    
    private func makeGETRequest(url: URL) {
        
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(url.absoluteString)
                print(error!)
                return
            }
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? JSONObj else {
                    print("error trying to convert data to JSON")
                    return
                }
                // now we have the json object, let's just print it to prove we can access it
                print("The json object is: \(json) ")
                

            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }
}
