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
                   
                   //how can I filter??
                  //  ForEach(state.user.freeze().filter({ searchText.isEmpty ? true : $0.name.contains(searchText) })) { user in

                        
                    Text(state.user!.name)

                    }
                 .onAppear(perform: searchTasks)
             
          
            }
            }
        .navigationTitle("Search")

        }


    func searchTasks() {
// how can I fetch seacrched items on Realm MongoDB??
        
        // mongodb-atlas is the cluster service name
        let client = app.currentUser!.mongoClient("mongodb-atlas")
        
        // Select the database
        let database = client.database(named: "tracker")
        
        // Select the collection
        let collection = database.collection(withName: "Task")
         
        // Using the user's id to look up tasks
        let user = app.currentUser!
        let identity = user.id
        
        // Run the query
        collection.find(filter: ["_partition": AnyBSON(identity)], { (result) in
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
                print("Results:")
                documents.forEach({(document) in
                    print("Document:")
                    document.forEach({ (key, value) in
                        print("  key: \(key), value: \(value!)")
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
