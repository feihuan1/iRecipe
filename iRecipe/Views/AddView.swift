//
//  AddAndEditView.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/9/24.
//

import SwiftUI

struct AddView: View {
    @ObservedObject var vm: DataViewModel
    @Binding var isPresented: Bool
    
    @State private var recipeName = ""
    @State private var description = ""
    @State private var instruction = ""
    @State private var selectedCategories: [CategoriesEntity] = []
    @State private var showAllCategoryAlert = false
    
    @State private var newCategoryName = ""
    @State private var showNewCategorySheet = false
    
    
    var body: some View {
        HStack{
            Button("← Back", action: {
                isPresented = false
            })
            .foregroundColor(Color.black)
            Spacer()
            
            Button("Save", action: {
                vm.addRecipe(name: recipeName, intro: description, instruction: instruction, categories: selectedCategories)
                isPresented = false
            })
            .foregroundColor(Color.black)
            
        }
        .padding(.horizontal)
        VStack {
            Text("Add Recipe")
                .font(.title)
                .padding()
            ScrollView{
                Text("Recipe Name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("name", text: $recipeName)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(5))
                Text("Descrption")
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextEditor(text: $description)
                    .frame(height: 150)
                    .foregroundColor(.black)
                    .colorMultiply(.gray.opacity(0.3))
                    .cornerRadius(5)
                Text("Category")
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        Button(action: {
                            showAllCategoryAlert = true
                        }) {
                            Text("All")
                                .frame(width: 50)
                                .padding(.vertical, 8)
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        ForEach(selectedCategories, id: \.self) { category in
                            Button(action: {
                                removeCategory(category)
                            }) {
                                Text("\(category.name ?? "") -")
                                    .padding(.vertical, 8)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 12)
                                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .alert(isPresented: $showAllCategoryAlert) {
                        Alert(title: Text("Warning"), message: Text("You can't remove the 'All' category"), dismissButton: .default(Text("OK")))
                    }
                }
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        Button(action: {
                            showNewCategorySheet = true
                        }) {
                            Text("New")
                                .padding(.vertical, 8)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 12)
                                .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .sheet(isPresented: $showNewCategorySheet) {
                            VStack {
                                TextField("Category Name", text: $newCategoryName)
                                    .padding()
                                    .background(Color.gray.opacity(0.3).cornerRadius(5))
                                
                                HStack {
                                    Button("Add") {
                                        if !newCategoryName.isEmpty {
                                            addCategory(newCategoryName)
                                        }
                                        showNewCategorySheet = false
                                    }
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    
                                    Button("Cancel") {
                                        showNewCategorySheet = false
                                    }
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                                .padding(.top, 16)
                            }
                            .padding()
                        }
                        
                        ForEach(vm.categories, id: \.self) { category in
                            if category.name != "All" {
                                Button(action: {
                                    addCategory(category.name ?? "")
                                }) {
                                    Text("\(category.name ?? "") +")
                                        .padding(.vertical, 8)
                                        .foregroundColor(.gray)
                                    
                                        .padding(.horizontal, 12)
                                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                Text("Ingredients")
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                // add here
                Text("Instructions")
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextEditor(text: $instruction)
                    .frame(height: 150)
                    .foregroundColor(.black)
                    .colorMultiply(.gray.opacity(0.3))
                    .cornerRadius(5)
            }

        }
        .padding(.all, 25.0)
    }
    
    private func removeCategory(_ category: CategoriesEntity) {
        guard category.name != "All" else {
            return
        }
        if let index = selectedCategories.firstIndex(of: category) {
            selectedCategories.remove(at: index)
        }
    }
    private func addCategory(_ categoryName: String) {
        guard !selectedCategories.contains(where: { $0.name == categoryName }) else {
            return
        }

        if let existingCategory = vm.categories.first(where: { $0.name == categoryName }) {
            selectedCategories.append(existingCategory)
        } else {
            vm.addCategory(name: categoryName)
            
        }
    }
}

