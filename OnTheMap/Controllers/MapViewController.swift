import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        getLocations()
    }

    func addAnnotations(_ studentLocations: [StudentInformation]) {
        for dictionary in studentLocations {
            let latitude = CLLocationDegrees(dictionary.latitude)
            let longitude = CLLocationDegrees(dictionary.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            let firstName = dictionary.firstName
            let lastName = dictionary.lastName
            let mediaURL = dictionary.mediaURL

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL

            annotations.append(annotation)
        }

        mapView.addAnnotations(annotations)
    }

    private func getLocations() {
        Client.sharedInstance().getStudentsLocation { (success, results, errorString) in
            if success {
                SharedData.sharedInstance.studentLocations = results!
                performUIUpdatesOnMain {
                    self.addAnnotations(results!)
                }
            } else {
                self.pushAlert(controller: self, message: AlertMessages.errorStudentData)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.calloutOffset = CGPoint(x: -5, y: 5)
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = URL(string: (view.annotation?.subtitle!)!), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            } else {
                self.pushAlert(controller: self, message: AlertMessages.errorURL)
            }
        }
    }
}
