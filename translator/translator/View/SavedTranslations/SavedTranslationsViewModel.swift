import Foundation

class SavedTranslationsViewModel {
    @Published var translations: [TranslationItem] = []
    private var showFavouritesOnly: Bool = false
    
    private let dataSource: TranslatorLocalDataSource = {
        do {
            return try TranslatorLocalDataSource()
        } catch {
            fatalError("Failed to initialize TranslatorLocalDataSource: \(error)")
        }
    }()

    func loadTranslations(showFavouritesOnly: Bool) {
        self.showFavouritesOnly = showFavouritesOnly
        do {
            if showFavouritesOnly {
                translations = try dataSource.fetchSavedTranslations()
            } else {
                translations = try dataSource.fetchTranslationHistory()
            }
        } catch {
            // Handle error gracefully
            print("Failed to load translations: \(error)")
            translations = []
        }
    }

    func toggleFavouriteStatus(for translation: TranslationItem) {
        do {
            try dataSource.updateSavedStatus(sourceText: translation.sourceText, targetText: translation.targetText, isSaved: !translation.isSaved)
            loadTranslations(showFavouritesOnly: showFavouritesOnly)  // Refresh all translations
        } catch {
            // Handle error gracefully
            print("Failed to update favourite status: \(error)")
        }
    }
}
