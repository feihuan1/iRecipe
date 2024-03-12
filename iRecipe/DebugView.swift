//
//  ContentView.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/9/24.
//

import SwiftUI

struct DebugView: View {
    @ObservedObject var vm: DataViewModel
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 20) {
                    ScrollView(.horizontal){
                        HStack{
                            Button(action: {
//                                vm.addRecipe(name: "fish", intro: "yoooo", instruction: "go to restaurant", categories: [])
                            }, label: {
                                Text("Add Recipe")
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Color.blue.cornerRadius(10))
                            })
                            
                            Button(action: {
                                vm.addUser(username: "Eric", password: "123")
                            }, label: {
                                Text("Add User")
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Color.blue.cornerRadius(10))
                            })
                            
                            Button(action: {
                                vm.addCategory(name: "heathy")
                            }, label: {
                                Text("Add category")
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Color.blue.cornerRadius(10))
                            })
                        }
                    }
                    Button(action: {
                        vm.deleteAllData()
                    }, label: {
                        Text("Life Saver")
                            .foregroundStyle(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.cornerRadius(10))
                    })

                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.recipes) {recipe in
                                    RecipesView(entity: recipe)
                            }
                        }
                    })
                                        
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.users) {user in
                                    UsersView(entity: user)
                            }
                        }
                    })
                                        
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.categories) {category in
                                    CategoriesView(entity: category)
                            }
                        }
                    })
                    

                    
                }
                .padding()
            }
            .navigationTitle("Debug")
        }
    }
}

struct RecipesView: View {
    
    let entity: RecipesEntity
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20, content: {
            
            Text("name: \(entity.name ?? "default")")
                .bold()
                        
            Text("intro: \(entity.intro ?? "default")")
                .bold()
                        
            Text("instruction: \(entity.instructions ?? "default")")
                .bold()
            
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


struct UsersView: View {
    
    let entity: UsersEntity
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20, content: {
            
            Text("userName: \(entity.userName ?? "default")")
                .bold()
                        
            Text("password: \(entity.password ?? "default")")
                .bold()
                        
            Text("volume type: \(entity.isVolumeUnitTbsp ? "tbsp" : "ml")")
                .bold()
            
            Text("weight type: \(entity.isWeightUnitOz ? "OZ" : "g")")
                .bold()
            
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


struct CategoriesView: View {
    
    let entity: CategoriesEntity
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20, content: {
            
            Text("category name: \(entity.name ?? "default")")
                .bold()
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


