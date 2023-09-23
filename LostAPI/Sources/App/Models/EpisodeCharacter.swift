
import Fluent
import Vapor

// EpisodeCharacter.swift (tabla intermedia)
final class EpisodeCharacter: Model {
    static let schema = "episode_character"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "episode_id")
    var episode: Episode

    @Parent(key: "character_id")
    var character: LostCharacter

    init() {}

    init(episodeID: UUID, characterID: UUID) {
        self.$episode.id = episodeID
        self.$character.id = characterID
    }
}
