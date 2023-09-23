
import Fluent
import Vapor

final class Season: Model, Content {
    static let schema = "seasons"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "number")
    var number: Int

    init() {}

    init(id: UUID? = nil, number: Int) {
        self.id = id
        self.number = number
    }
}
