//
//  Fetch.swift
//  task-tracker-swiftui
//
//  Created by Alexandre Lordelo on 2021-01-12.
//

import SwiftUI
import RealmSwift

struct Fetch: View {
    
    @EnvironmentObject var state: AppState

    @State var realmNotificationToken: NotificationToken?
    
    //how to define task as the server task, not local?
    @State var tasks: Results<Task>?
    
    var body: some View {
        
            if let tasks = tasks {
                List {
                    ForEach(tasks.freeze()) { task in
                        if let tasksRealm = tasks.realm {
                            TaskView(task: (tasksRealm.resolve(ThreadSafeReference(to: task)))!)
                        }
                    }
                }
                
            } else {
                Text("Loading...")
                    
            .onAppear(perform: fetchData)
            .onDisappear(perform: stopWatching)


            }
        
        
      
        
    }
    
    
  private func fetchData() {
    
    // mongodb-atlas is the cluster service name
    let client = app.currentUser!.mongoClient("mongodb-atlas")
    
    // Select the database
    let database = client.database(named: "tracker2")
    
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
    
    
    func stopWatching() {
        if let token = realmNotificationToken {
            token.invalidate()
        }
    }
    
    
}
struct Fetch_Previews: PreviewProvider {
    static var previews: some View {
        Fetch()
    }
}
