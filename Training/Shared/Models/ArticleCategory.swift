struct Article: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let category: ArticleCategory
}

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