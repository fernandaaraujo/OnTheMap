import UIKit
import Foundation

class TabBarViewController: UITabBarController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!

    @IBAction func logoutButtonPressed(_ sender: Any) {
        Client.sharedInstance().logout(viewController: self)
    }

    @IBAction func refreshButtonPressed(_ sender: Any) {
        let mapViewController = self.viewControllers?[0] as! MapViewController
        let tableViewController = self.viewControllers?[1] as! TableViewController

        Client.sharedInstance().getStudentsLocation { (success, results, errorString) in
            if success {
                SharedData.sharedInstance.studentLocations = results!
                performUIUpdatesOnMain {
                    mapViewController.addAnnotations(results!)
                    tableViewController.loadView()
                }
            } else {
                Alert.pushAlert(controller: self, message: AlertMessages.errorStudentData)
            }
        }
    }

    @IBAction func addLocationButtonPressed(_ sender: Any) {
        if !SharedData.objectID.isEmpty {
            let alert = UIAlertController(title: AlertMessages.duplicateLocationTitle,
                                          message: AlertMessages.duplicateLocation, preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
                self.navigationController?.pushViewController(controller, animated: true)
            })

            alert.addAction(confirmAction)
            alert.addAction(cancelAction)

            performUIUpdatesOnMain {
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
