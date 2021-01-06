//
//  Home.swift
//  task-tracker-swiftui
//
//  Created by Alexandre Lordelo on 2021-01-04.
//

import Foundation
import RealmSwift
import SwiftUI

struct Home: View {
    
    @EnvironmentObject var state: AppState


    @State var tasksRealm: Realm
    
    @State var showProjects = false


    @State private var selection: NavigationItem? = .Tasks

    enum NavigationItem {
        case Tasks
        case Search
        case Fabrics
    }

    var body: some View {

        List(selection: self.$selection) {

            //tasks
            NavigationLink(destination:
             TasksView(realm: tasksRealm)

            ) {
                Label("Browse", systemImage: "rectangle.on.rectangle.angled")
            }
            .tag(NavigationItem.Tasks)

        }
        .listStyle(SidebarListStyle())
        
        .navigationBarTitle(state.selectedProject.name!)

        
        .toolbar {


          //button that shows project list
            ToolbarItem(placement: .bottomBar) {
                //select projec
                Button(action: { self.showProjects = true }) {
                Text("select project")
             }
            }
        }
        
        .sheet(isPresented: $showProjects) {
            ProjectSelect()
        }

    }
}
