
import Fluent
import Vapor
import SQLiteNIO

enum Route: String {
    case episodes
    
    var pathComponent: PathComponent { rawValue.asPathComponent }
}

enum APIVersion: String {
    case v1
}

extension String {
    var asPathComponent: PathComponent {
        "\(self)"
    }
}

struct EpisodeController: RouteCollection {
    let version: APIVersion
    
    init(version: APIVersion = .v1) {
        self.version = version
    }
    
    func boot(routes: RoutesBuilder) throws {
        let episodesRoute = routes.grouped(
            Route.episodes.pathComponent
        )
        episodesRoute.get(use: getAll)
        episodesRoute.get(":id", use: findById)
    }
    
    func getAll(req: Request) throws -> EventLoopFuture<[Episode]> {
        Episode
            .query(on: req.db)
            .all()
    }
    
    func findById(req: Request) throws -> EventLoopFuture<Episode> {
        Episode
            .find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}
