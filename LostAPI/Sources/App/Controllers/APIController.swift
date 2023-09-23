import Fluent
import Vapor

struct APIController: RouteCollection {
    let version: APIVersion

    init(version: APIVersion = .v1) {
        self.version = version
    }

    func boot(routes: RoutesBuilder) throws {
        let apiRoute = routes.grouped(
            .api,
            .version(version)
        )

        let allRoutes: [RouteCollection] = [
            EpisodeController(version: version),
            CharacterController(version: version)
        ]

        //   new test

        try allRoutes.forEach {
            try apiRoute.register(collection: $0)
        }
    }
}
