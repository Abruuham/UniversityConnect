//
//  SocialManagerProtocol.swift
//  UniversityConnect
//
//  Created by Abraham Calvillo on 3/1/21.
//

import Foundation
import UIKit


protocol SocialManagerProtocol: class {
    func fetchUser(userID: String, completion: @escaping (_ user: User?) -> Void)
}
