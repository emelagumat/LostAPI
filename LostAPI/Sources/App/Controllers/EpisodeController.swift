import Fluent
import Vapor

struct EpisodeController: RouteCollection {
    let version: APIVersion

    func boot(routes: RoutesBuilder) throws {
        let episodesRoute = routes.grouped(.episodes)

        episodesRoute.get(use: getAll)
        episodesRoute.get(.parameter(.id), use: findById)
    }

    func getAll(req: Request) throws -> EventLoopFuture<[Episode]> {
        Episode
            .query(on: req.db)
            .all()
    }

    func findById(req: Request) throws -> EventLoopFuture<Episode> {
        Episode
            .find(req.parameters.get(.id), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}
