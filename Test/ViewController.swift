//
//  ViewController.swift
//  Test
//
//  Created by Chuck Krutsinger on 8/14/18.
//  Copyright © 2018 Countermind, LLC. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //start with no database
        var manager = CoreDataManager(modelName: "Model", storeType: NSSQLiteStoreType)
        manager.destroyPersistentStore()
        
        let repository = ModelRepository()
        let metallicaFan = repository.createRole(name: "Metallica Fan", type: .Fan)
        let johnson = repository.createUserSession(username: "jim@johnson.com", roles: [metallicaFan])
        let zeppelinFan = repository.createRole(name: "Led Zeppelin Fan", type: .Fan)
        let smith = repository.createUserSession(username: "sam@smith.com", roles: [zeppelinFan])
        repository.save()
        let userSessions = repository.fetchAllUserSession()
        let aUser = userSessions.last
        let aUserSessionDB = aUser as! UserSessionDB
        
        repository.save()
        
        let sessions = repository.fetchAllUserSession()
        print(sessions)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

