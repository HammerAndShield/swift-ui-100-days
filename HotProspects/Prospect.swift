import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool

    init(name: String, emailAddress: String, isContacted: Bool = false) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
    }
}
