import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) async throws {
    app.http.server.configuration.port = 1337
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    try await preloadData(in: app)
    try routes(app)
}

private func preloadData(in app: Application) async throws {
    do {
        let url = URL(fileURLWithPath: "preload_data.json")
        let data = try Data(contentsOf: url)
        let dataInfo = try JSONDecoder().decode(PreloadData.self, from: data)

        let migrations: [Migration] = [
            CreateEpisode(),
            CreateCharacter()
        ]

        for table in migrations {
            try? await table.prepare(on: app.db).get()
            app.migrations.add(table)
        }

        try await preloadEpisodes(with: dataInfo, in: app.db)
        try await preloadCharacters(with: dataInfo, in: app.db)

    } catch {
        print(error)
        print(error.localizedDescription)
    }
}

private func preloadCharacters(with info: PreloadData, in db: Database) async throws {
    try await preload(
        CreateCharacter(),
        in: db,
        data: info.Characters
    )
}

private func preloadEpisodes(with info: PreloadData, in db: Database) async throws {
    try await preload(
        CreateEpisode(),
        in: db,
        data: info.Episodes
    )
}

private func preload<T: Migration, U: Model>(
    _ model: T,
    in db: Database,
    data: [U]
) async throws {
    try? await model.prepare(on: db).get()

    for item in data {
        try await U
            .find(item.id, on: db)
            .flatMap {
                if let item = $0 {
                    item.update(on: db)
                } else {
                    item.save(on: db)
                }
            }
            .get()
    }
}

func loadInitialData(on database: Database) -> EventLoopFuture<Void> {
    let fileURL = URL(fileURLWithPath: "path/to/initialData.json")

    do {
        let data = try Data(contentsOf: fileURL)
        let episodes = try JSONDecoder().decode([Episode].self, from: data)

        let saveFutures = episodes.map { episode in
            return episode.save(on: database)
        }

        return EventLoopFuture<Void>.andAllSucceed(saveFutures, on: database.eventLoop)
    } catch {
        return database.eventLoop.makeFailedFuture(error)
    }
}
