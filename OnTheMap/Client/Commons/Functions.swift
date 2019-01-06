import Foundation
import UIKit

extension Client {
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }

    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }

        completionHandlerForConvertData(parsedResult, nil)
    }


    func createURL(_ origin: String, _ url: String, _ params: String, _ method: String) -> URLRequest {
        var request: URLRequest

        if method == Constants.Methods.get {
            let concatenatedUrl = url + params
            request = URLRequest(url: URL(string: concatenatedUrl)!)
        } else {
            request = URLRequest(url: URL(string: url)!)
            request.httpBody = params.data(using: .utf8)
            request.addValue(Constants.ParameterKeys.applicationJson,
                             forHTTPHeaderField: Constants.ParameterKeys.contentType)
        }

        if origin == Constants.Request.parse {
            request.addValue(Constants.Auth.applicationID,
                             forHTTPHeaderField: Constants.ParameterKeys.applicationID)
            request.addValue(Constants.Auth.apiKey,
                             forHTTPHeaderField: Constants.ParameterKeys.apiKey)
        }

        if origin == Constants.Request.udacity && method == Constants.Methods.post {
            request.addValue(Constants.ParameterKeys.applicationJson, forHTTPHeaderField: Constants.ParameterKeys.accept)
        }

        request.httpMethod = method

        return request
    }

    func createJsonBodyFor(_ studentInformation: [String:AnyObject]) -> String {
        let uniqueKey = "\"\(ParseConstants.JSONKeys.uniqueKey)\": \"\(studentInformation[ParseConstants.JSONKeys.uniqueKey]!)\""
        let firstName = "\"\(ParseConstants.JSONKeys.firstName)\": \"\(studentInformation[ParseConstants.JSONKeys.firstName]!)\""
        let lastName = "\"\(ParseConstants.JSONKeys.lastName)\": \"\(studentInformation[ParseConstants.JSONKeys.lastName]!)\""
        let mapString = "\"\(ParseConstants.JSONKeys.mapString)\": \"\(studentInformation[ParseConstants.JSONKeys.mapString]!)\""
        let mediaURL = "\"\(ParseConstants.JSONKeys.mediaURL)\": \"\(studentInformation[ParseConstants.JSONKeys.mediaURL]!)\""
        let longitude = "\"\(ParseConstants.JSONKeys.longitude)\": \(studentInformation[ParseConstants.JSONKeys.longitude]!)"
        let latitude = "\"\(ParseConstants.JSONKeys.latitude)\": \(studentInformation[ParseConstants.JSONKeys.latitude]!)"

        return "{\(uniqueKey), \(firstName), \(lastName), \(mapString), \(mediaURL), \(latitude), \(longitude)}"
    }

    func createJsonUdacityBody(username: String, password: String) -> String {
        let udacityBody = "\"\(Constants.JSON.BodyKeys.udacity)\""
        let usernameQuery = "\"\(Constants.JSON.BodyKeys.username)\": \"\(username)\""
        let passwordQuery = "\"\(Constants.JSON.BodyKeys.password)\": \"\(password)\""

        return "{\(udacityBody): {\(usernameQuery), \(passwordQuery)}}"
    }

    func getNewDataFrom(_ data: Data) -> Data {
        let range = (5..<data.count)
        return data.subdata(in: range)
    }

    func logout(viewController: UIViewController) {
        Client.sharedInstance().logoutSession { (success, error) in
            if success {
                performUIUpdatesOnMain {
                    viewController.dismiss(animated: true, completion: nil)
                }
            } else {
                if let error = error {
                    Alert.pushAlert(controller: viewController, message: error)
                } else {
                    Alert.pushAlert(controller: viewController,
                                    message: AlertMessages.generalError)
                }
            }
        }
    }
}
