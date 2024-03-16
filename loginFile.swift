//
//  loginFile.swift
//  OnTheSpot
//
//  Created by Darian Lee on 3/9/24.
//

import UIKit
import ParseSwift
// application id: hBiCVMNLcJtqnJOIJssAvZ4Sua2kxFlK9YGYAZfU
// client id: QbLPQUERHNum7opg0lOjWr9rBnrvP7bQomOYzX7z

class loginFile: UIViewController {

    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var loginText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func didPressLogin(_ sender: UIButton){
        guard let username = loginText.text,
              let password = passwordText.text else{
            print("OHHHHHHH NOOOOO!")
            return
        }
        User.login(username: username, password: password) {  result in

            switch result {
            case .success(let user):
                print("✅ Successfully logged in as user: \(user)")

                // Post a notification that the user has successfully logged in.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                print(error)
            }
        }
    }

}
