import Foundation
import SQLite

class TranslatorLocalDataSource {
    private let db: Connection
    private let translationsTable = Table("translations")
    private let id = Expression<Int64>("id")
    private let sourceText = Expression<String>("source_text")
    private let targetText = Expression<String>("target_text")
    private let isSaved = Expression<Bool>("is_saved")
    
    init(databasePath: String = "translations.sqlite3") throws {
        let dbURL = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databasePath)
        db = try Connection(dbURL.path)
        createTableIfNeeded()
    }
    
    private func createTableIfNeeded(){
        do {
            try db.run(translationsTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(sourceText)
                table.column(targetText)
                table.column(isSaved)
            })
        } catch {
            print("Error creating table")
        }
    }
    
    func saveTranslation(_ item: TranslationResponse){
        do {
            try db.run(translationsTable.insert(
                sourceText <- item.sourceText,
                targetText <- item.targetText,
                isSaved <- false
            ))
        } catch{
            print("Error insserting")
        }
    }
    
    func fetchTranslationHistory() throws -> [TranslationItem] {
        do{
            let rows = try db.prepare(translationsTable)
            return rows.map { row in
                TranslationItem(
                    sourceText: row[sourceText],
                    targetText: row[targetText],
                    isSaved: row[isSaved]
                )
            }
        } catch{
            print("Error getting")
            return []
        }
    }
    
    func fetchSavedTranslations() throws -> [TranslationItem] {
        return try db.prepare(translationsTable.filter(isSaved == true)).map { row in
            TranslationItem(
                sourceText: row[sourceText],
                targetText: row[targetText],
                isSaved: row[isSaved]
            )
        }
    }
    
    func updateSavedStatus(sourceText: String, targetText: String, isSaved: Bool) throws{
        let translation = translationsTable.filter(self.sourceText == sourceText && self.targetText == targetText)
        try db.run(translation.update(self.isSaved <- isSaved))
    }
}
