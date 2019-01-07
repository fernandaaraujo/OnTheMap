import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.isSecureTextEntry = true
    }

    @IBAction func Login(_ sender: UIButton) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.pushAlert(controller: self, message: AlertMessages.emptyUserData)
        } else {
            Client.sharedInstance().getSessionID(username: emailTextField.text!,
                                                 password: passwordTextField.text!) { (success, errorString) in
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        if let error = errorString {
                            self.pushAlert(controller: self, message: error)
                        } else {
                            self.pushAlert(controller: self, message: AlertMessages.generalError)
                        }
                    }
                }
            }
        }
    }

    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }

    @IBAction func SignUp(_ sender: UIButton) {
        let app = UIApplication.shared
        app.open(URL(string: UdacityConstants.Signup.url)!, options: [:], completionHandler: nil)
    }
}
