//
//  signUp.swift
//  OnTheSpot
//
//  Created by Darian Lee on 3/9/24.
//

import UIKit
import ParseSwift

class signUp: UIViewController {

    @IBOutlet var emailText: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var passwordText: UITextField!

    @IBOutlet var loginText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func didPressRegister(_ sender: UIButton){
        guard let username = loginText.text,
              let email = emailText.text,
              let password = passwordText.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {

            print("uh oh! we made a poopsy!")
            return
        
        }
        var newUser = User()
        newUser.username = username
        print(username)
        newUser.email = email
        print(email)
        newUser.password = password
        print(password)
        print(newUser)
        newUser.anwsered = false

        newUser.signup { result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                // Post a notification that the user has successfully signed up.
                
                DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Success", message: "You have successfully signed up!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                                    // Perform segue to login view controller
                                    self.performSegue(withIdentifier: "login", sender: nil)
                                })
                    self.present(alert, animated: true, completion: nil)
                            }

            case .failure(let error):
                print("Error signing up user: \(error)")
            }
        }
    }
    

   

}
