import Vapor
import Fluent

final class LostCharacter: Model, Content {
    static let schema = "characters"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "surname")
    var surname: String

    @Field(key: "actorName")
    var actorName: String

    @Field(key: "age")
    var age: Int

    @Field(key: "description")
    var description: String

    init() { }

    init(
        id: UUID? = nil,
        name: String,
        surname: String,
        actorName: String,
        age: Int,
        description: String
    ) {
        self.id = id
        self.name = name
        self.surname = surname
        self.actorName = actorName
        self.age = age
        self.description = description
    }
}
