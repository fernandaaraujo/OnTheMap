import Foundation

struct Constants {
    struct Auth {
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }

    struct Request {
        static let udacity = "udacity"
        static let parse = "parse"
    }
    
    struct URLKeys {
        static let cookieName = "XSRF-TOKEN"
    }

    struct ParameterKeys {
        static let apiKey = "X-Parse-REST-API-Key"
        static let applicationID = "X-Parse-Application-Id"
        static let applicationJson = "application/json"
        static let contentType = "Content-Type"
        static let httpCookie = "X-XSRF-TOKEN"
        static let accept = "Accept"
    }

    struct Methods {
        static let get = "GET"
        static let post = "POST"
        static let put = "PUT"
        static let delete = "DELETE"
    }

    struct JSON {
        struct BodyKeys {
            static let udacity = "udacity"
            static let username = "username"
            static let password = "password"
        }

        struct ResponseKeys {
            static let session = "session"
            static let sessionID = "id"
            static let account = "account"
            static let userID = "key"
        }
    }
}
