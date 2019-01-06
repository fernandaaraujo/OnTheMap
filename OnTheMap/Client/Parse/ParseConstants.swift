import Foundation

struct ParseConstants {
    struct StudentLocation {
        static let url = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
    
    struct QueryKeys {
        static let limit = "limit=100"
        static let sortedByDate = "order=-updatedAt"
        static let withUniqueKey = "?where={\"uniqueKey\":"
    }
    
    struct JSONKeys {
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mediaURL = "mediaURL"
        static let mapString = "mapString"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let results = "results"
    }

    struct Messages {
        static let errorGetStudentsLocation = "Error getting students location"
        static let errorParseStudentesLocation = "Could not parse getStudentsLocation"
        static let errorPostStudentLocation = "Error posting student location"
        static let errorUpdateStudentLocation = "Error updating student location"
    }
}
