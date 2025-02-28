import Foundation

struct QuizQuestion: Codable {
    let question: String
    let questionInfo: String
    let answers: [String]
    let correctAnswerIndex: Int
}

struct QuizCategory: Codable {
    let category: String
    let questions: [QuizQuestion]
    var isCompleted: Bool?
}


class SportsDB {
    static let shared = SportsDB()
    private let categoriesKey = "categoriesKey"
    
    var categories: [QuizCategory] = []
    
    func loadSports() {
        if let savedData = UserDefaults.standard.data(forKey: categoriesKey) {
            let decoder = JSONDecoder()
            if let savedSports = try? decoder.decode([QuizCategory].self, from: savedData) {
                self.categories = savedSports
                return
            }
        }
        readLocalJSONFile()
    }
    
    func readLocalJSONFile() {
        do {
            if let filePath = Bundle.main.path(forResource: "sports_quiz", ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                do {
                    let decodedData = try JSONDecoder().decode([QuizCategory].self, from: data)
                    self.categories = decodedData
                    saveSports()
                } catch {
                    print("error: \(error)")
                }
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    func saveSports() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }

    func updateFavourite(for categoryName: String, isCompleted: Bool) {
        if let index = categories.firstIndex(where: { $0.category == categoryName }) {
            categories[index].isCompleted = isCompleted
            saveSports()
        }
    }
}
