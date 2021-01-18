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

    @State var image: Data = .init(count:0)

    
    @EnvironmentObject var state: AppState

  //  let realm: Realm
   // var project: Project
    
    var body: some View {
        
        Form {
            
            //project name
            Text(project.name ?? "project name")
            
            //project profile image
            HStack(alignment: .center) {

            Text("Profile Image")

            Spacer()
              
            Image(uiImage: UIImage(data: project.profileImage ?? self.image) ?? UIImage())
            .renderingMode(.original)
            .resizable()
            .frame(width: 48, height: 48)
            .clipShape(Circle())

            }
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
