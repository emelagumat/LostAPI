import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    let url = URL(fileURLWithPath: "preload_data.json")
    do {
        let urll = URL(fileURLWithPath: "Resources/preload_data.json")
        print("💛 \(urll)")
        let data = try Data(contentsOf: url)
        let dataInfo = try JSONDecoder().decode(PreloadData.self, from: data)
        
        let create = CreateEpisode()
        try? await create.prepare(on: app.db).get()
        app.migrations.add(create)
        dataInfo.Episodes.forEach { episode in
            Episode.find(episode.id, on: app.db).map { dbEpisode in
                if let episode = dbEpisode {
                    episode.update(on: app.db)
                } else {
                    episode.save(on: app.db)
                }
            }
        }
    } catch {
        print(error)
        print(error.localizedDescription)
    }
    
    try routes(app)
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
