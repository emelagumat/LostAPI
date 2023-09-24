import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

public struct LostAPIEntry {
    public static func configure(_ app: Application) async throws {
        app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "manu",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "postgres",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)

        try await preloadData(in: app)
        try routes(app)
    }
}

private func preloadData(in app: Application) async throws {
    do {
        let url = Bundle.module.url(forResource: "preload_data", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let dataInfo = try JSONDecoder().decode(PreloadData.self, from: data)
        
        let migrations: [Migration] = [
            CreateEpisode(),
            CreateCharacter(),
            CreateSeason()
        ]
        
        for table in migrations {
            try? await table.prepare(on: app.db).get()
            app.migrations.add(table)
        }

        try await preloadEpisodes(with: dataInfo, in: app.db)
        try await preloadCharacters(with: dataInfo, in: app.db)
        try await preloadSeasons(with: dataInfo, in: app.db)

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

private func preloadSeasons(with info: PreloadData, in db: Database) async throws {
    try await preload(
        CreateSeason(),
        in: db,
        data: info.Seasons
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
