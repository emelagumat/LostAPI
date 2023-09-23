import Vapor

enum Route {
    case api
    case version(APIVersion)
    case episodes
    case characters
    case seasons
}

extension Route {
    var pathComponent: PathComponent {
        switch self {
        case .api:
            "lost/api"
        case .version(let aPIVersion):
            aPIVersion.rawValue.asPathComponent
        case .episodes:
            "episodes"
        case .characters:
            "characters"
        case .seasons:
            "seasons"
        }
    }
}
