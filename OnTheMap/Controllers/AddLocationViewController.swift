import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!

    lazy var geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.isHidden = true
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        locationTextField.text = ""
        urlTextField.text = ""
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func findLocationButtonPressed(_ sender: Any) {
        if locationTextField.text?.isEmpty == false && urlTextField.text?.isEmpty == false {
            self.activityIndicator.isHidden = false
            self.activityIndicator.stopAnimating()

            geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
                if let error = error {
                    Alert.pushAlert(controller: self, message: error.localizedDescription)
                } else {
                    if let placemark = placemarks?.first {
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationMapViewController") as! AddLocationMapViewController

                        controller.placemark = placemark

                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        SharedData.mapString = self.urlTextField.text!
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
        } else if urlTextField.text?.isEmpty == true {
            Alert.pushAlert(controller: self, message: AlertMessages.errorURL)
            self.navigationController?.popViewController(animated: true)
        } else {
            Alert.pushAlert(controller: self, message: AlertMessages.errorLocation)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
