import Foundation

class Client: NSObject{

    var session = URLSession.shared
    var sessionID : String? = nil
    var userID : String? = nil
    var userName: String? = nil
    let studentLocation = SharedData.sharedInstance.studentLocations

    override init() {
        super.init()
    }

    func taskForGETMethod(request: URLRequest, origin: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }

            guard error == nil else {
                sendError("There was an error with the request: \(String(describing: error))")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("The request returned a error.")
                return
            }

            guard let data = data else {
                sendError("The request returned no data")
                return
            }

            if origin == Constants.Request.parse {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
                return
            }

            let newData = self.getNewDataFrom(data)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForGET)
        }

        task.resume()
        return task
    }

    func taskForPOSTMethod(request: URLRequest, origin: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }

            guard error == nil else {
                sendError("There was an error with the request: \(String(describing: error))")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("The request returned a error.")
                return
            }

            guard let data = data else {
                sendError("The request returned no data")
                return
            }

            if origin == Constants.Request.parse {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
                return
            }

            let newData = self.getNewDataFrom(data)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPOST)
        }

        task.resume()
        return task
    }

    func taskForPUTMethod(request: URLRequest, origin: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
            }

            guard error == nil else {
                sendError("There was an error with the request: \(String(describing: error))")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("The request returned a error.")
                return
            }

            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }

            if origin == Constants.Request.parse {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
                return
            }

            let newData = self.getNewDataFrom(data)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPUT)
        }

        task.resume()
        return task
    }

    func taskForDeleteMethod(urlRequest: URLRequest, origin: String, completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var request = urlRequest

        var httpCookie: HTTPCookie? = nil
        let storageCookie = HTTPCookieStorage.shared

        for cookie in storageCookie.cookies! {
            if cookie.name == Constants.URLKeys.cookieName { httpCookie = cookie }
        }
        
        if let httpCookie = httpCookie {
            request.setValue(httpCookie.value, forHTTPHeaderField: Constants.ParameterKeys.httpCookie)
        }

        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDelete(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }

            guard error == nil else {
                sendError("There was an error with the request: \(String(describing: error))")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("The request returned a error.")
                return
            }

            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }

            if origin == Constants.Request.parse {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDelete)
                return
            }

            let newData = self.getNewDataFrom(data)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForDelete)
        }

        task.resume()
        return task
    }
}
