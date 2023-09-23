import Vapor

extension PathComponent {
    static func parameter(_ parameter: RouteParameter) -> PathComponent {
        ":\(parameter.rawValue)"
    }
}
