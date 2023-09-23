import Fluent

struct CreateCharacter: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(LostCharacter.schema)
            .id()
            .field("name", .string)
            .field("surname", .string)
            .field("actorName", .string)
            .field("age", .int)
            .field("description", .int)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(LostCharacter.schema)
            .delete()
    }
}
