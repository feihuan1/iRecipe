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
    
    var body: some View {
        HStack{
            Button("← Back", action: {
                isPresented = false
            })
            .foregroundColor(Color.black)
            Spacer()
            
            Button("Save", action: {
                vm.addRecipe(name: recipeName, intro: description, instruction: instruction)
                isPresented = false
            })
            .foregroundColor(Color.black)

        }
        .padding(.horizontal)
        VStack {
            Text("Add/Edit Recipe")
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
                                        ForEach(vm.categories, id: \.self) { category in
                                            Button(action: {
                                                // how the heck do i add mutiple category in a recipe???
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
}

