import Foundation
import UIKit
import MapKit

class AddLocationMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var placemark:CLPlacemark? = nil
    var location:CLLocation? = nil
    var studentLocation = SharedData.sharedInstance.studentLocations

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Add Location", style: .plain, target: nil, action: nil)

        if placemark != nil {
            location = placemark?.location
            centerMapOnLocation(location!)

            let annotation = MKPointAnnotation()
            annotation.coordinate = (location?.coordinate)!
            annotation.title = placemark?.name!

            self.mapView.addAnnotation(annotation)
        } else {
            self.pushAlert(controller: self, message: AlertMessages.emptyPlacemark)
        }
    }

    @IBAction func finishButtonPressed(_ sender: Any) {
        Client.sharedInstance().getPublicUserData() { (success, results, errorString) in
            if success {
                performUIUpdatesOnMain {
                    let data = self.createDataFor(results!)

                    if SharedData.objectID.isEmpty {
                        Client.sharedInstance().postStudentLocation(data, { (success, errorString) in
                            if success {
                                performUIUpdatesOnMain {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            } else {
                                self.pushAlert(controller: self, message: errorString!)
                            }
                        })
                    } else {
                        Client.sharedInstance().updateStudentLocation(data, { (success, errorString) in
                            if success {
                                performUIUpdatesOnMain {
                                    self.pushAlert(controller: self, message: AlertMessages.successfullyAdded)
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            } else {
                                self.pushAlert(controller: self, message: errorString!)
                            }
                        })
                    }
                }
            } else {
                self.pushAlert(controller: self, message: errorString!)
            }
        }
    }

    let regionRadius: CLLocationDistance = 500
    func centerMapOnLocation (_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }

    private func createDataFor(_ results: [String:AnyObject]) -> [String:AnyObject] {
        let data:[String:AnyObject] = [ParseConstants.JSONKeys.firstName: results[UdacityConstants.ResponseKeys.firstName] as AnyObject,
                                       ParseConstants.JSONKeys.lastName: results[UdacityConstants.ResponseKeys.lastName] as AnyObject,
                                       ParseConstants.JSONKeys.uniqueKey: results[UdacityConstants.ResponseKeys.uniqueKey] as AnyObject,
                                       ParseConstants.JSONKeys.mediaURL: SharedData.mapString as AnyObject,
                                       ParseConstants.JSONKeys.mapString: self.location as AnyObject,
                                       ParseConstants.JSONKeys.longitude: (self.placemark!.location?.coordinate.longitude)! as AnyObject,
                                       ParseConstants.JSONKeys.latitude: (self.placemark!.location?.coordinate.latitude)! as AnyObject]
        return data
    }
}

extension AddLocationMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }

        return pinView
    }
}
