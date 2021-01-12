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

    @State private var searchText = ""


    @State private var selection: NavigationItem? = .List

    enum NavigationItem {
        case List
        case Search
        case Fetch
    }

    var body: some View {

        List(selection: self.$selection) {

            //tasks
            NavigationLink(destination:
             TasksView(realm: tasksRealm)

            ) {
                Label("List", systemImage: "list.bullet")
            }
            .tag(NavigationItem.List)
            
            //search
            NavigationLink(destination:
            SearchBar(text: $searchText)

            ) {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(NavigationItem.Search)
            
            
            //fetch
            NavigationLink(destination:
             Fetch()

            ) {
                Label("Fetch", systemImage: "arrow.down.square")
            }
            .tag(NavigationItem.Fetch)

        }
        .listStyle(SidebarListStyle())
        
      //  .navigationBarTitle(state.selectedProject.name!)

        
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
