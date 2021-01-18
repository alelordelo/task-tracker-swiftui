//
//  ProjectEdit.swift
//  task-tracker-swiftui
//
//  Created by Alexandre Lordelo on 2021-01-11.
//

import SwiftUI
import RealmSwift

struct ProjectEdit: View {
    
  // let realm: Realm
    
    var project: Project

    @EnvironmentObject var state: AppState
    @Environment(\.presentationMode) var presentationMode

    //selected profile image
    @State var selectedProfileImage = UIImage()

    //file importer
    @State private var target: Binding<UIImage>?
    @State private var openFile = false
    

    @State var name = ""
    
    var body: some View {
        
        NavigationView {
        
        Form {
            
        TextField("Name", text: $name)
            
            
            //profile image
            HStack(alignment: .center) {
            Text("Profile Image")

            Spacer()

            Button(action: {
                    self.target = $selectedProfileImage
                    self.openFile.toggle()
                }) {

                    Image(uiImage: self.selectedProfileImage)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                }
            }
            

         }
        
        .toolbar {

            //update button
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    updateProject(updatedProject: project)
                }) {
                    Text("Done")
                    .foregroundColor(.blue)
                }

            }

            //cancel button
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                         self.presentationMode.wrappedValue.dismiss()
                      }) {
                        Text("Cancel")
                      }

            }
        }
            
        .navigationBarTitle(project.name ?? "Workplace name")

        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        //file importer
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.image]) { (res) in
            do {
                let fileUrl = try res.get()
                print(fileUrl)

                guard fileUrl.startAccessingSecurityScopedResource() else { return }
                if let imageData = try? Data(contentsOf: fileUrl),
                let image = UIImage(data: imageData) {
                    self.target?.wrappedValue = image
                }
                fileUrl.stopAccessingSecurityScopedResource()

            } catch {

                print("error reading")
                print(error.localizedDescription)
            }
        }
 

        
        
    }
    
    
    
//    func updateWorkplace(updatedWorkplace: Workplace) {
//      state.error = nil
//      state.shouldIndicateActivity = true
//
//      do {
//        try state.realmObject!.write {
//            workplace.name = name
//        }
//        state.shouldIndicateActivity = false
//        self.presentationMode.wrappedValue.dismiss()
//
//      } catch {
//        state.error = "Unable to open Realm write transaction"
//      }
//    }
    


    
    //update edited workspace to Realm

    func updateProject(updatedProject: Project) {
         state.error = nil
         let partitionValue = app.currentUser?.id ?? ""
         let realmConfig = app.currentUser?.configuration(partitionValue: "user=\(partitionValue)")
         
         guard var config = realmConfig else {
             state.error = "Internal error - cannot get Realm config"
             return
         }
        
        
        //convert image data
         let selectedProfileImageConverted = self.selectedProfileImage.jpegData(compressionQuality: 0.80)
        
        
         config.objectTypes = [User.self, Project.self]
         
         if state.realmUserObject == nil {
             state.realmUserObject = try! Realm(configuration: config)
         }
         do {
             try state.realmUserObject!.write {
                
                 updatedProject.name = name
                
                updatedProject.profileImage = selectedProfileImageConverted

             }
             state.shouldIndicateActivity = false
             self.presentationMode.wrappedValue.dismiss()
             
         } catch {
             state.error = "Unable to open Realm write transaction"
         }
         
     }

}

//struct ProjectEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectEdit()
//    }
//}
