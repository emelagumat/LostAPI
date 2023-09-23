
import Fluent
import Vapor

struct APIController: RouteCollection {
    let version: APIVersion
    
    init(version: APIVersion = .v1) {
        self.version = version
    }
    
    func boot(routes: RoutesBuilder) throws {
        let apiRoute = routes.grouped(
            "api",
            version.rawValue.asPathComponent
        )
        
        try apiRoute.register(collection: EpisodeController(version: version))
    }
}
