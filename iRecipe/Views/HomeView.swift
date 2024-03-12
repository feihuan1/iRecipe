//
//  HomeView.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/9/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: DataViewModel
    @State var isAdding = false
    


    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Category")
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.top, 16)
                        .padding(.leading, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let user = vm.users.first {
                        Text("Welcome \(user.userName ?? "")")
                            .font(.caption2)
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(vm.categories, id: \.self) { category in
                            Button(action: {
                                // Your action code here
                            }) {
                                Text(category.name ?? "")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                        
                    }
                    .padding(.horizontal, 16)
                }
                
                Divider()
                    .background(Color.white)
                    .padding(.top, 8)
                List {
                    ForEach(vm.recipes, id: \.id) { recipe in
                        NavigationLink(destination: RecipeDetailView(vm: vm, recipe: recipe)) {
                            RecipeCell(vm: vm, recipe: recipe)
                                .padding(.vertical)
                        }
                    }
                }
                .background(Color.white)
                .overlay(
//                    NavigationLink(destination: AddView(vm: vm, isPresented: $isAdding), isActive: $isAdding){
                        Button(action: {
                            isAdding.toggle()
                        }, label: {
                            Text("+")
                                .frame(width: 50, height: 50)
                                .font(.title)
                                .foregroundColor(.black)
                                .background(Color.gray.opacity(0.5))
                                .clipShape(Circle())
                        })
                        .padding()
//                    },alignment: .bottomTrailing
                        .offset(x: 130, y: 240)
                )
            }
        }
        .fullScreenCover(isPresented: $isAdding, content: {
            AddView(vm: vm, isPresented: $isAdding)
        })
    }
}

