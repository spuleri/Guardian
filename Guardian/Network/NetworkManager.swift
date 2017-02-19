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
        // Set up the URL
        let endpoint = base + "test"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        makeGETRequest(url: url)
    }
    
    func getEvents(user: User) {
        // Set up the URL
        let endpoint = base + "events"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        makeGETRequest(url: url)
    }
    
    func authWithGoogle(idToken: String, accessToken: String, refreshToken: String, serverAuthCode: String) {
        // Set up the URL
        let endpoint = base + "auth"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let parameters = ["id_token": idToken,
                          "access_token": accessToken,
                          "refresh_token": refreshToken,
                          "server_auth_code": serverAuthCode,
                          "secretMessage": "omg sergio is the coolest"]
        
        makePOSTRequest(url: url, parameters: parameters as JSONObj)
    }
    
    private func makePOSTRequest(url: URL, parameters: JSONObj) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert params to Data
        // On errors! http://stackoverflow.com/questions/32390611/try-try-try-what-s-the-difference-and-when-to-use-each
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            print("Error converting POST body to Data")
            return
        }
        
        urlRequest.httpBody = jsonData
        
        makeHTTPRequest(urlRequest: urlRequest) {
            (json, error) in
            // check for any errors
            guard error == nil else {
                print(url.absoluteString)
                print(error!)
                return
            }
            
            print("Response JSON of POST Request is: \(json)")
        }
        
    }
    
    
    private func makeGETRequest(url: URL) {
        
        let urlRequest = URLRequest(url: url)
        
        makeHTTPRequest(urlRequest: urlRequest) {
            (json, error) in
            // check for any errors
            guard error == nil else {
                print(url.absoluteString)
                print(error!)
                return
            }
            
            print("Response JSON of GET Request is: \(json)")
        }
    }
    
    private func makeHTTPRequest(urlRequest: URLRequest, completionHandler: @escaping (JSONObj?, Error? ) -> Void) {
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Mutable copy
        var request = urlRequest
        
        // Add our auth header to every request
        request.setValue((UserStore.instance.getCurrentUser()?.idToken)!, forHTTPHeaderField: "id_token")

        
        // make the request
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                // Pass up to closure
                completionHandler(nil, error)
                return
            }
            
            // Make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            // parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? JSONObj else {
                    print("error trying to convert data to JSON")
                    
                    let response = response as? HTTPURLResponse
                    print(response.debugDescription)
                    return
                }
                // now we have the json object, let's just print it to prove we can access it
//                print("The json object is: \(json) ")
                
                // Pass it up to the caller
                completionHandler(json, nil)
                
                
            } catch  {
                print("error trying to convert data to JSON")
                
                let response = response as? HTTPURLResponse
                print(response.debugDescription)
                return
            }
        }
        
        task.resume()
        
        print("\nMade HTTP request:\n\(request.debugDescription)\n\(request.allHTTPHeaderFields)\n)")
        
    }
}
