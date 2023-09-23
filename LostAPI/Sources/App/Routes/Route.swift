import Vapor

enum Route {
    case api
    case version(APIVersion)
    case episodes
    case characters
}

extension Route {
    var pathComponent: PathComponent {
        switch self {
        case .api:
            "api"
        case .version(let aPIVersion):
            aPIVersion.rawValue.asPathComponent
        case .episodes:
            "episodes"
        case .characters:
            "characters"
        }
    }
}
