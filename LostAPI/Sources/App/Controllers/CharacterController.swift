
import Fluent
import Vapor

struct CharacterController: RouteCollection {
    let version: APIVersion
    
    init(version: APIVersion) {
        self.version = version
    }
    
    func boot(routes: RoutesBuilder) throws {
        let charactersRoute = routes.grouped(.characters)
        
        charactersRoute.get(use: getAll)
        charactersRoute.get(.parameter(.id), use: findById)
    }
    
    func getAll(req: Request) throws -> EventLoopFuture<[LostCharacter]> {
        LostCharacter
            .query(on: req.db)
            .all()
    }
    
    func findById(req: Request) throws -> EventLoopFuture<LostCharacter> {
        LostCharacter
            .find(req.parameters.get(.id), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}
