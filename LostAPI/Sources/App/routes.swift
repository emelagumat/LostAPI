import Fluent
import Vapor

let version: APIVersion = .v1

func routes(_ app: Application) throws {
    try app.register(collection: APIController())
}
