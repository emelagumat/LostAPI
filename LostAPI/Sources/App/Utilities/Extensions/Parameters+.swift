
import Vapor

extension Parameters {
    func get<T>(_ routeParameter: RouteParameter, as type: T.Type = T.self) -> T?
        where T: LosslessStringConvertible
    {
        self.get(routeParameter.rawValue).flatMap(T.init)
    }
}
