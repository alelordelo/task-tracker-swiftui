//
//  AppState.swift
//  task-tracker-swiftui
//
//  Created by Andrew Morgan on 05/11/2020.
//

import RealmSwift
import SwiftUI
import Combine

class AppState: ObservableObject {
    var loginPublisher = PassthroughSubject<RealmSwift.User, Error>()
    var logoutPublisher = PassthroughSubject<Void, Error>()
    let userRealmPublisher = PassthroughSubject<Realm, Error>()
    var cancellables = Set<AnyCancellable>()
    @Published var shouldIndicateActivity = false
    @Published var error: String?
    
    
    var user: User?

    var selectedProject: Project {
        let project = Project(partition: "project=\(app.currentUser!.id)", name: "Project")
        return project
    }

    var realmObject: Realm?
    
    
    var loggedIn: Bool =  false
    init() {
        loginPublisher
            .receive(on: DispatchQueue.main)
            .flatMap { user -> RealmPublishers.AsyncOpenPublisher in
                self.shouldIndicateActivity = true
                print("UserId \(user.id)")
                var realmConfig = user.configuration(partitionValue: "user=\(user.id)")
                realmConfig.objectTypes = [User.self, Project.self, Task.self]
                return Realm.asyncOpen(configuration: realmConfig)
            }
            .receive(on: DispatchQueue.main)
            .map {
                self.shouldIndicateActivity = false
                return $0
            }
            .subscribe(userRealmPublisher)
            .store(in: &self.cancellables)

        userRealmPublisher
            .sink(receiveCompletion: { result in
                if case let .failure(error) = result {
                    self.error = "Failed to log in and open realm: \(error.localizedDescription)"
                }
            }, receiveValue: { [self] realm in
                print("Realm User file location: \(realm.configuration.fileURL!.path)")

                let project = Project(partition: "project=\(app.currentUser!.id)", name: "Project")
                setAppStateObject(project)
                self.user = realm.objects(User.self).first
            })
            .store(in: &cancellables)

        logoutPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
            }, receiveValue: { _ in
                self.user = nil
                self.loggedIn = false
                self.realmObject = nil
                self.shouldIndicateActivity = false
            })
            .store(in: &cancellables)
        if (app.currentUser?.isLoggedIn) != nil {
            loginPublisher.send(app.currentUser!)
        }
    }

    func setAppStateObject(_ project: Project) {

        let realmConfig = app.currentUser?.configuration(partitionValue: project.partition ?? "")
        guard var config = realmConfig else {
            error = "Cannot get Realm config from current user"
            return
        }
        config.objectTypes = [Task.self]
        Realm.asyncOpen(configuration: config)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in

                self.shouldIndicateActivity = false
                if case let .failure(error) = result {
                    self.error = "Failed to open realm: \(error.localizedDescription)"
                }
            }, receiveValue: { [self] realm in
                print("Realm Project file location: \(realm.configuration.fileURL!.path)")
                self.realmObject = realm
                shouldIndicateActivity = false
                self.loggedIn = true
            })
            .store(in: &self.cancellables)
    }
}
