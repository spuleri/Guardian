//
//  User.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation


// Good stuff: http://swiftandpainless.com/nscoding-and-swift-structs/
struct User {
    let name: String

    // Should probably save this in keychain lol
    let googleServerAuthCode: String
    let idToken: String
    

    // MARK: Encoding and Decoding through Helper Class
    static func encode(user: User) {
        let userClassObject = HelperClass(user: user)
        
        NSKeyedArchiver.archiveRootObject(userClassObject, toFile: HelperClass.path())
    }
    
    static func decode() -> User? {
        let userClassObject = NSKeyedUnarchiver.unarchiveObject(withFile: HelperClass.path()) as? HelperClass
        
        return userClassObject?.user
    }
    
    static func clear() {
        do {
            try FileManager.default.removeItem(atPath: HelperClass.path())
            print("Removal successful")
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    

}

extension User {
    
    class HelperClass: NSObject, NSCoding  {
        
        // MARK: User struct as "var" property so its mutable as well as being optional in case it doesnt exisit
        var user: User?
        
        
        init(user: User) {
            self.user = user
            super.init()
        }

        
        class func path() -> String {
            let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let path = documentsPath?.appending("/User")
            return path!
        }
        
        
        // MARK: NSCoding
        public required init?(coder aDecoder: NSCoder) {
            
            // Get strings
            guard let name = aDecoder.decodeObject(forKey: "name") as? String else { user = nil; super.init(); return nil }
            guard let googleServerAuthCode = aDecoder.decodeObject(forKey: "googleServerAuthCode") as? String else { user = nil; super.init(); return nil }
            guard let idToken = aDecoder.decodeObject(forKey: "idToken") as? String else { user = nil; super.init(); return nil }
            
            // We dont need to write a constructor for structs
            user = User(name: name, googleServerAuthCode: googleServerAuthCode, idToken: idToken)

            super.init()
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(user?.name, forKey: "name")
            aCoder.encode(user?.googleServerAuthCode, forKey: "googleServerAuthCode")
            aCoder.encode(user?.idToken, forKey: "idToken")
        }
    }
    
    
}
