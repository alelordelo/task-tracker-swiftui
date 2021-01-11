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
    
    @EnvironmentObject var state: AppState

  //  let realm: Realm
   // var project: Project
    
    var body: some View {
        
        Form {
            
            Text(project.name ?? "project name")
    }
        
 }
}

//struct ProjectDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectDetail()
//    }
//}
