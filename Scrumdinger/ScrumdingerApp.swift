import SwiftUI

@main
struct ScrumdingerApp: App {
    @StateObject private var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            ScrumsView(scrums: $store.scrums, saveAction: {
                Task {
                    do {
                        try await store.save(scrums: store.scrums)
                        
                    } catch {
                        fatalError(error.localizedDescription)
                        errorWrapper = ErrorWrapper(error: error, 
                                                    guidance: "Try again later")
                        
                    }
                }
            })
            .task {
                do {
                    try await store.load()
                } catch {
                    fatalError(error.localizedDescription)
                    errorWrapper = ErrorWrapper(error: error,
                                                guidance: "Scrumdinger will load sample data and continue.")
                }
            }
            .sheet(item: $errorWrapper) {
                store.scrums = DailyScrum.sampleData
                
            } content: { wrapper in
                ErrorView(errorWrapper: wrapper)
                
            }
        }
    }
}
