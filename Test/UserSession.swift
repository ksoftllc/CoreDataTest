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
    
    func addToRoles(_ role:Role)
    
    func removeFromRoles(_ role: Role)
    
    func addToRoles(all rolesInSet: Set<Role>)
    
    func removeFromRoles(all rolesInSet: Set<Role>)
    
    var hashValue: Int { get }

}

extension UserSessionDB: UserSession {
    func removeFromRoles(_ role: Role) {
        self.removeFromRolesSet(role)
    }
    
    func removeFromRoles(all rolesInSet: Set<Role>) {
        self.removeFromRolesSet(rolesInSet as NSSet)
    }
    
    
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
