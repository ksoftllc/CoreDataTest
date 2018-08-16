//
//  RoleModel.swift
//  Test
//
//  Created by Chuck Krutsinger on 8/14/18.
//  Copyright © 2018 Countermind, LLC. All rights reserved.
//

import Foundation

enum RoleType: String { //Type is a reserved word in swift
    //Note: Casing has to exactly match Android casing to correctly
    //store in back end database
    case Artist, Venue, BookingAgent, Promoter, VenueEmployee, Fan
}

protocol Role {
    
    var roleName: String? { get set }
    var roleType: RoleType? { get set }
}

extension RoleDB: Role {
    
    var roleType: RoleType? {
        get {
            guard roleTypeRaw != "", let roleTypeRaw = roleTypeRaw else {
                return nil
            }
            return RoleType.init(rawValue: roleTypeRaw)
        }
        set(roleType) {
            roleTypeRaw = roleType?.rawValue
        }
    }
  
}
