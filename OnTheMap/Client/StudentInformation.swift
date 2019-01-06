import Foundation

struct StudentInformation {
    private(set) var dictionary: [String: AnyObject]
    private(set) var objectID: String = ""
    private(set) var uniqueKey: String = ""
    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    private(set) var mapString: String = ""
    private(set) var latitude: Double = 0.0
    private(set) var longitude: Double = 0.0
    var mediaURL: String = ""

    init(dictionary: [String:AnyObject]) {
        self.dictionary = dictionary

        self.objectID = getStringFromDictionaryWith(key: ParseConstants.JSONKeys.objectID)
        self.uniqueKey = getStringFromDictionaryWith(key: ParseConstants.JSONKeys.uniqueKey)
        self.firstName = getStringFromDictionaryWith(key: ParseConstants.JSONKeys.firstName)
        self.lastName = getStringFromDictionaryWith(key: ParseConstants.JSONKeys.lastName)
        self.mediaURL = getStringFromDictionaryWith(key: ParseConstants.JSONKeys.mediaURL)
        self.mapString = getStringFromDictionaryWith(key: ParseConstants.JSONKeys.mapString)
        self.latitude = getDoubleFromDictionaryWith(key: ParseConstants.JSONKeys.latitude)
        self.longitude = getDoubleFromDictionaryWith(key: ParseConstants.JSONKeys.longitude)
    }

    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        var location = [StudentInformation]()

        for result in results {
            location.append(StudentInformation(dictionary: result))
        }

        return location
    }

    private func getStringFromDictionaryWith(key: String) -> String {
        if let value = dictionary[key] as? String, !value.isEmpty {
            return value
        }

        return ""
    }

    private func getDoubleFromDictionaryWith(key: String) -> Double {
        if let value = dictionary[key]  as? Double, !value.isNaN {
            return value
        }

        return 0.0
    }
}
