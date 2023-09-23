import Fluent

struct CreateSeason: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(Season.schema)
            .id()
            .field("number", .int)
            .field("startDate", .string)
            .field("endDate", .string)
            .field("numberOfEpisodes", .int)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database
            .schema(Season.schema)
            .delete()
    }
}
