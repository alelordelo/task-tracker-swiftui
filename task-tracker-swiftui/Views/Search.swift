//
//  Search.swift
//  task-tracker-swiftui
//
//  Created by Alexandre Lordelo on 2021-01-12.
//

import SwiftUI
import RealmSwift

struct Search: View {
    
    @EnvironmentObject var state: AppState

    @State var users: Results<User>?

    
    @State private var searchText = ""

    var body: some View {

        ScrollView {

        VStack {
            

            SearchBar(text: $searchText)

            //fetch all cloud users
          
                List {
                   
                   //how can I search for users??
               //   ForEach(state.user.freeze().filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { user in

                    //user name
                    Text(state.user!.name)

                    }
                 .onAppear(perform: searchTasks)
             
          
            }
            }
        .navigationTitle("Search")

        }


    func searchTasks() {
                        
            // mongodb-atlas is the cluster service name
        let client = app.currentUser!.mongoClient("mongodb-atlas")

            // Select the database
        let database = client.database(named: "tracker2")

            // Select the collection
        let collection = database.collection(withName: "User")

            // Using the user's id to look up tasks
            let user = app.currentUser!
            let identity = "user=\(user.id)"

        collection.aggregate( pipeline: [], { (result) in
              // Note: this completion handler may be called on a background thread.
              //       If you intend to operate on the UI, dispatch back to the main
              //       thread with `DispatchQueue.main.async {}`.
              switch result {

              case .failure(let error):
                  // Handle errors
                  print("Call to MongoDB failed: \(error.localizedDescription)")
                  return

              case .success(let documents):
                  // Print each document
                  print("Results: \(documents)")
                  documents.forEach({(document) in
                      print("Document:")
                      document.forEach({ (key, value) in
                          print("  key: \(key), value: \(value)")
                      })
                  })
              }
          })
      }
        
        
        
    
    
    
    
    
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
