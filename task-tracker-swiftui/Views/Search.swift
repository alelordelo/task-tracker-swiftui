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
       }
    
    
    
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
