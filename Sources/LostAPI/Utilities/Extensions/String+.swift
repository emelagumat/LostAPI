import Vapor

extension String {
    var asPathComponent: PathComponent {
        "\(self)"
    }
}
