//
//  ProjectDetail.swift
//  task-tracker-swiftui
//
//  Created by Alexandre Lordelo on 2021-01-11.
//

import SwiftUI
import RealmSwift

struct ProjectDetail: View {
    
    var project: Project
    
    @State var showProjectEdit = false

    
    @EnvironmentObject var state: AppState

  //  let realm: Realm
   // var project: Project
    
    var body: some View {
        
        Form {
            
            Text(project.name ?? "project name")
    }
        
        .toolbar {

            ToolbarItem(placement: .primaryAction) {
                

                //edit button
                Button(action: {
                    showProjectEdit = true
                }, label: {
                    Text("Edit")
                })
                
                //edit modal
                .sheet(isPresented: $showProjectEdit) {
                    ProjectEdit(project: project,
                                name: project.name ?? "Project Name"
                    
                    )
                }
                
   
                
            }

        }
        
 }
}

//struct ProjectDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDetail()
//    }
//}
