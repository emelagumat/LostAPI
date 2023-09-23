import Fluent
import Vapor

final class Season: Model, Content {
    static let schema = "seasons"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "number")
    var number: Int

    @Field(key: "startDate")
    var startDate: String?

    @Field(key: "endDate")
    var endDate: String?

    @Field(key: "numberOfEpisodes")
    var numberOfEpisodes: Int?

    init() {}

    init(id: UUID? = nil, number: Int, startDate: String? = nil, endDate: String? = nil, numberOfEpisodes: Int? = nil) {
        self.id = id
        self.number = number
        self.startDate = startDate
        self.endDate = endDate
        self.numberOfEpisodes = numberOfEpisodes
    }
}
