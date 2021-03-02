//
//  Coordinates.swift
//  UniversityConnect
//
//  Created by Abraham Calvillo on 3/1/21.
//

import Foundation
import UIKit

open class Coordinates{
    var latitude: String?
    var longitude: String?
    
    init(latitude: String? = nil, longitude: String? = nil){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(representation: [String: Any]) {
        self.latitude = representation["latitude"] as? String
        self.longitude = representation["longitude"] as? String
    }
    
    required public init(jsonDict: [String: Any]){
        fatalError()
    }
    
    public var description: String {
        return "coordinates"
    }
    
}
