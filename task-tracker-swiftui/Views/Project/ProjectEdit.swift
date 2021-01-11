//
//  ProjectEdit.swift
//  task-tracker-swiftui
//
//  Created by Alexandre Lordelo on 2021-01-11.
//

import SwiftUI

struct ProjectEdit: View {
    
   // let realm: Realm
    
    var project: Project

    @EnvironmentObject var state: AppState
    @Environment(\.presentationMode) var presentationMode


    @State var name = ""
    
    var body: some View {
        
        NavigationView {
        
        Form {
            
        TextField("Name", text: $name)

         }
            
        .navigationBarTitle(project.name ?? "Workplace name")

        }
        .navigationViewStyle(StackNavigationViewStyle())

        
        
    }
}

//struct ProjectEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectEdit()
//    }
//}
