extension AppConfig {
    enum Domain {
        enum ArticleCategory: String, CaseIterable {
            case news = "ニュース"
            case sports = "スポーツ"

            var iconName: String {
                switch self {
                case .news:   return "newspaper"
                case .sports: return "figure.run"
                }
            }
        }

        static let categories = ArticleCategory.allCases
    }
}