import Fluent

struct CreateEpisode: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Episode.schema)
            .id()
            .field("title", .string, .required)
            .field("season", .int, .required)
            .field("summary", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("episodes").delete()
    }
}

