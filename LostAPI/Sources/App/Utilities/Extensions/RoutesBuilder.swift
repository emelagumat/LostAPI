import Vapor

extension RoutesBuilder {
    func grouped(_ routes: Route...) -> RoutesBuilder {
        grouped(routes.map(\.pathComponent))
    }
}
