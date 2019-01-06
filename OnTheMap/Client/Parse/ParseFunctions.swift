import Foundation

extension Client {
    func getStudentsLocation(_ completionHandlerForStudentsLocation: @escaping (_ success: Bool, _ results: [StudentInformation]?, _ errorString: String?) -> Void) {
        let query = "?\(ParseConstants.QueryKeys.limit)&\(ParseConstants.QueryKeys.sortedByDate)"
        let urlRequest = createURL(Constants.Request.parse, ParseConstants.StudentLocation.url, query, Constants.Methods.get)

        let _ = taskForGETMethod(request: urlRequest, origin: Constants.Request.parse) { (results, error) in
            if error != nil {
                completionHandlerForStudentsLocation(false, nil, ParseConstants.Messages.errorGetStudentsLocation)
                return
            } else {
                guard let data = results?[ParseConstants.JSONKeys.results] as? [[String: AnyObject]] else {
                    completionHandlerForStudentsLocation(false, nil, ParseConstants.Messages.errorParseStudentesLocation)
                    return
                }

                let studentsInformation = StudentInformation.locationsFromResults(data)
                completionHandlerForStudentsLocation(true, studentsInformation, nil)
            }
        }
    }

    func postStudentLocation(_ studentInformation: [String:AnyObject], _ completionHandlerForPostStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let jsonBody = createJsonBodyFor(studentInformation)
        let urlRequest = createURL(Constants.Request.parse, ParseConstants.StudentLocation.url, jsonBody, Constants.Methods.post)

        let _ = taskForPOSTMethod(request: urlRequest, origin: Constants.Request.parse) { (results, error) in
            if error != nil {
                completionHandlerForPostStudentLocation(false, ParseConstants.Messages.errorPostStudentLocation)
                return
            }

            if let result = results?[ParseConstants.JSONKeys.objectID] as? String {
                SharedData.objectID = result
            }

            completionHandlerForPostStudentLocation(true, nil)
        }
    }

    func updateStudentLocation(_ studentInformation: [String:AnyObject], _ completionHandlerForPostStudentLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let jsonBody = createJsonBodyFor(studentInformation)
        let urlRequest = createURL(Constants.Request.parse, ParseConstants.StudentLocation.url, jsonBody, Constants.Methods.post)

        let _ = taskForPUTMethod(request: urlRequest, origin: Constants.Request.parse) { (results, error) in
            if error != nil {
                completionHandlerForPostStudentLocation(false, ParseConstants.Messages.errorUpdateStudentLocation)
                return
            }

            completionHandlerForPostStudentLocation(true, nil)
        }
    }
}
