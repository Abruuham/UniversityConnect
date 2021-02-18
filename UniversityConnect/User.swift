//
//  User.swift
//  UniversityConnect
//
//  Created by Abraham Calvillo on 2/13/21.
//

import Foundation


open class User{
    var uid: String?
    var username: String?
    var email: String?
    
    
    
    init(uid: String = "",
         email: String = ""
         ) {
       
        self.uid = uid
        self.email = email
    }
    
    
    public init(representation: [String: Any]) {
        self.username = representation["username"] as? String
        self.email = representation["email"] as? String
        self.uid = representation["userID"] as? String
        }

    
    required public init(jsonDict: [String: Any]) {
        fatalError()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
    }

    public convenience required init?(coder aDecoder: NSCoder) {
        self.init(uid: aDecoder.decodeObject(forKey: "uid") as? String ?? "unknown",
                  email: aDecoder.decodeObject(forKey: "email") as? String ?? "")
    }

    var representation: [String : Any] {
        var rep: [String : Any] = [
            "userID": uid ?? "default",
            "username": username ?? "",
            "email": email ?? ""
            ]
        
        return rep
    }
    
    
    
}
