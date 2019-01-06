import Foundation

class SharedData {
    var studentLocations = [StudentInformation]()

    static let sharedInstance = SharedData()
    static var objectID = ""
    static var mapString = ""
    private init() {}
}
