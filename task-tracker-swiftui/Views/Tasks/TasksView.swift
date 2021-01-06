//
//  TasksView.swift
//  task-tracker-swiftui
//
//  Created by Andrew Morgan on 03/11/2020.
//

import SwiftUI
import RealmSwift

struct TasksView: View {
    let realm: Realm
   // let projectName: String

    @EnvironmentObject var state: AppState

    @State var realmNotificationToken: NotificationToken?
    @State var tasks: Results<Task>?
    @State var lastUpdate: Date?
    @State var showingSheet = false

    var body: some View {
        VStack {
            if let tasks = tasks {
                List {
                    ForEach(tasks.freeze()) { task in
                        if let tasksRealm = tasks.realm {
                            TaskView(task: (tasksRealm.resolve(ThreadSafeReference(to: task)))!)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
            } else {
                Text("Loading...")
            }
            if let lastUpdate = lastUpdate {
                LastUpdate(date: lastUpdate)
            }
        }
        .navigationBarTitle("Tasks in \(state.selectedProject.name!)", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: { self.showingSheet = true }) {
            Image(systemName: "plus.circle.fill")
                .renderingMode(.original)

        })
        .sheet(isPresented: $showingSheet) { AddTaskView(realm: realm) }
        .onAppear(perform: loadData)
        .onDisappear(perform: stopWatching)
    }

    func loadData() {
        tasks = realm.objects(Task.self).sorted(byKeyPath: "_id")
        realmNotificationToken = realm.observe { _, _  in
            lastUpdate = Date()
        }
    }

    func stopWatching() {
        if let token = realmNotificationToken {
            token.invalidate()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        do {
            try realm.write {
                guard let tasks = tasks else {
                    print("tasks not set")
                    return
                }
                realm.delete(tasks[offsets.first!])
            }
        } catch {
            state.error = "Unable to open Realm write transaction"
        }
    }
}

//struct TasksView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppearancePreviews(
//            Group {
//                NavigationView {
//                    TasksView(realm: .sample, projectName: "Sample Project")
//                }
//                Landscape(
//                    NavigationView {
//                        TasksView(realm: .sample, projectName: "Sample Project")
//                    }
//                )
//            }
//        )
//        .environmentObject(AppState())
//    }
//}
