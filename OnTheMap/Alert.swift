import Foundation
import UIKit

extension UIViewController {
    func pushAlert(title: String? = AlertMessages.errorTitle, controller: UIViewController, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        performUIUpdatesOnMain {
            controller.present(alert, animated: true, completion: nil)
        }
    }
}

struct AlertMessages {
    static let errorTitle = "Something is wrong"
    static let successfullyAdded = "Location added successfully!"
    static let emptyUserData = "Please enter email address and password."
    static let errorStudentData = "Unable to get student data."
    static let errorLocation = "Please enter a valid location."
    static let emptyPlacemark = "Placemark not found."
    static let errorURL = "Please enter a valid URL."
    static let generalError = "We got an error. Please try again."
    static let duplicateLocationTitle = "Replace location?"
    static let duplicateLocation = "Student location already posted."
}
