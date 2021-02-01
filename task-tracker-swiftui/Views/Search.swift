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
                    ForEach(userList) { users in

                    //user name
                    Text(users.name)
                
               }

                    }
                 .onAppear(perform: fetchData)
             
          
            }
            }
        .navigationTitle("Search")

        }
    
    struct UserObject: Identifiable {
           let id: String
           let name: String
           let _partition: String
           
           init(document: Document) {
               self.id = document["_id"]!!.stringValue!
               self.name = document["name"]!!.stringValue!
               self._partition = document["_partition"]!!.stringValue!
           }
       }
       
       @State var userList: [UserObject] = []
        
       private func fetchData() {
           let user = app.currentUser!
           user.functions.filterUser(["alelor"]) {(result, _) in
               guard result != nil else {
                   // This can happen if the view is dismissed
                   // before the operation completes
                   print("User list no longer exists.")
                   return
               }
               self.userList = result!.arrayValue!.map({ (bson) in
                   return UserObject(document: bson!.documentValue!)
               })
               
               if userList.count > 0 {
                   // Get first user
                   let user: UserObject = self.userList[0]
                   print(user.id)
                   print(user.name)
               }
           }
       }
    
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
