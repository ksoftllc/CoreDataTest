//
//  UserSessionModel.swift
//  Test
//
//  Created by Chuck Krutsinger on 8/14/18.
//  Copyright © 2018 Countermind, LLC. All rights reserved.
//

import Foundation

protocol UserSession {
    
    var username: String? { get set }
    
    var roles: Set<Role>? { get }
    
}

extension UserSessionDB: UserSession {
    
    var roles: Set<Role>? {
        get {
            return rolesSet as? Set<RoleModel>
        }
        set {
            rolesSet = newValue as NSSet?
        }
    }
    
    func addToRoles(_ role: Role) {
        self.addToRoles(role)
    }
    
    func addToRoles(all rolesInSet: Set<Role>) {
        self.addToRoles(all: rolesInSet)
    }

}
