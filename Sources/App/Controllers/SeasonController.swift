import Fluent
import Vapor

struct SeasonController: RouteCollection {
    let version: APIVersion

    func boot(routes: Vapor.RoutesBuilder) throws {
        let routes = routes.grouped(.seasons)

        routes.get(use: getAll)
        routes.get(.parameter(.id), use: findById)
    }

    func getAll(req: Request) throws -> EventLoopFuture<[Season]> {
        Season
            .query(on: req.db)
            .all()
    }

    func findById(req: Request) throws -> EventLoopFuture<Season> {
        Season
            .find(req.parameters.get(.id), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}
