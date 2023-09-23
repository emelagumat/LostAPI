
import Fluent
import Vapor

enum Route: String {
    case episodes
    
    var pathComponent: PathComponent { "\(rawValue)" }
}

struct EpisodeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let episodesRoute = routes.grouped(Route.episodes.pathComponent)
        
        episodesRoute.get(use: getAll)
    }
    
    func getAll(req: Request) throws -> EventLoopFuture<[Episode]> {
        return Episode.query(on: req.db).all()
    }
}
