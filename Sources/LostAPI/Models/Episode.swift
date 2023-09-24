import Fluent
import Vapor

final class Episode: Model, Content {
    static let schema = "episodes"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "season")
    var season: Int

    @Field(key: "summary")
    var summary: String

    @Siblings(through: EpisodeCharacter.self, from: \.$episode, to: \.$character)
    var characters: [LostCharacter]

    init() {}

    init(id: UUID? = nil, title: String, season: Int, summary: String) {
        self.id = id
        self.title = title
        self.season = season
        self.summary = summary
    }
}

struct PreloadData: Codable {
    let Characters: [LostCharacter]
    let Episodes: [Episode]
    let Seasons: [Season]
//    let EpisodeCharacter: [EpisodeCharacter]
}
