import Foundation

struct UdacityConstants {
    struct Base {
        static let authURL = "https://onthemap-api.udacity.com/v1"
    }

    struct Signup {
        static let url = "https://www.udacity.com/account/auth#!/signup"
    }

    struct Methods {
        static let authURL = "/session"
        static let userDataURL = "/users/"
    }

    struct ResponseKeys {
        static let firstName = "first_name"
        static let lastName  = "last_name"
        static let uniqueKey = "key"
    }

    struct Messages {
        static let errorLogin = "Login failed. Please, try again."
    }
}
