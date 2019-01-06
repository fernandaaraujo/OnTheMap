import Foundation

extension Client {
    func getSessionID(username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let jsonBody = createJsonUdacityBody(username: username, password: password)
        let url = "\(UdacityConstants.Base.authURL)\(UdacityConstants.Methods.authURL)"
        let urlRequest = createURL(Constants.Request.udacity, url, jsonBody, Constants.Methods.post)

        let _ = taskForPOSTMethod(request: urlRequest, origin: Constants.Request.udacity){ (results, error) in
            if error != nil {
                completionHandlerForSession(false, error?.localizedDescription)
                return
            }

            guard let parsedData = results?[Constants.JSON.ResponseKeys.session] as? [String:AnyObject],
                let sessionID = parsedData[Constants.JSON.ResponseKeys.sessionID] as? String
                else {
                    completionHandlerForSession(false, UdacityConstants.Messages.errorLogin)
                    return
            }

            guard let account = results?[Constants.JSON.ResponseKeys.account] as? [String:AnyObject],
                let userID = account[Constants.JSON.ResponseKeys.userID] as? String
                else {
                    completionHandlerForSession(false, UdacityConstants.Messages.errorLogin)
                    return
            }

            self.sessionID = sessionID
            self.userID = userID
            completionHandlerForSession(true, nil)
        }
    }

    func getPublicUserData(_ completionHandlerForUserData: @escaping (_ success: Bool, _ results: [String:AnyObject]?, _ errorString: String?) -> Void) {
        let query = "\(UdacityConstants.Methods.userDataURL)\(Client.sharedInstance().userID!)"
        let urlRequest = createURL(Constants.Request.udacity, UdacityConstants.Base.authURL, query, Constants.Methods.get)

        let _ = taskForGETMethod(request: urlRequest, origin: Constants.Request.udacity) { (results, error) in
            if error != nil {
                completionHandlerForUserData(false, nil, UdacityConstants.Messages.errorLogin)
                return
            }

            completionHandlerForUserData(true, (results as! [String:AnyObject]), nil)
        }
    }

    func logoutSession(_ completionHandlerForLogout: @escaping (_ success: Bool,_ errorString: String?) -> Void) {
        let url = "\(UdacityConstants.Base.authURL)\(UdacityConstants.Methods.authURL)"
        let urlRequest = createURL(Constants.Request.udacity, url, "", Constants.Methods.delete)

        let _ = taskForDeleteMethod(urlRequest: urlRequest, origin: Constants.Request.udacity) { (results, error) in
            if error != nil {
                completionHandlerForLogout(false, UdacityConstants.Messages.errorLogin)
                return
            }

            completionHandlerForLogout(true, nil)
        }
    }
}
