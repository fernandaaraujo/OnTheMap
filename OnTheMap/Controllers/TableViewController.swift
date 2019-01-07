import Foundation
import UIKit

class TableViewController: UIViewController {

    @IBOutlet var locationsTableView: UITableView!
    var location = SharedData.sharedInstance.studentLocations

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        Client.sharedInstance().getStudentsLocation { (success, results, errorString) in
            if success {
                self.location = results!
                performUIUpdatesOnMain {
                    self.locationsTableView.reloadData()
                }
            } else {
                self.pushAlert(controller: self, message: AlertMessages.errorStudentData)
            }
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TableViewCell"
        let data = location[(indexPath as NSIndexPath).row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: identifier)
        cell.imageView!.image = UIImage(named: "icon_pin")
        cell.imageView!.contentMode = UIView.ContentMode.scaleAspectFit
        cell.textLabel?.text = "\(data.firstName) \(data.lastName)"
        cell.detailTextLabel?.text = "\(data.mediaURL)"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = location[(indexPath as NSIndexPath).row]

        if let url = URL(string: data.mediaURL){
            UIApplication.shared.open(url, options: [:])
        } else {
            self.pushAlert(controller: self, message: AlertMessages.errorURL)
        }
    }
}
