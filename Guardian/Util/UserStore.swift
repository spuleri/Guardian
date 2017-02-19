//
//  UserStore.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import Foundation

class UserStore {
    static let instance = UserStore()
    
    private var currentUser: User?
    
    func getCurrentUser() -> User? {
        
        if nil == self.currentUser {
            // Attempt to load if currently nil
            loadUser()
        }
        return self.currentUser
    }
    
    func addContactToUser(contact: Contact) {
        currentUser?.addContact(contact: contact)
    }
    
    func setCurrentUser(user: User) {
        self.currentUser = user
    
    }
    
    func loadUser() {
        self.currentUser = User.decode()
    }
    
    
    
    func deleteCurrentUser() -> String {
        let currentSignedInUserName = currentUser?.name
        
        User.clear()
        
        return currentSignedInUserName!
    }
    
}
