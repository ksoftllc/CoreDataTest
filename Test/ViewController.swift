//
//  ViewController.swift
//  Test
//
//  Created by Chuck Krutsinger on 8/14/18.
//  Copyright © 2018 Countermind, LLC. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let repository = ModelRepository()
        let metallicaFan = repository.createRole(name: "Metallica Fan", type: .Fan)
        let johnson = repository.createUserSession(username: "jim@johnson.com", roles: [metallicaFan])
        let zeppelinFan = repository.createRole(name: "Led Zeppelin Fan", type: .Fan)
        let smith = repository.createUserSession(username: "sam@smith.com", roles: [zeppelinFan])
        repository.save()
        let userSessions = repository.fetchAllUserSession()
        let aUser = userSessions.last
        let aUserSessionDB = aUser as! UserSessionDB
        print("\(aUserSessionDB)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

