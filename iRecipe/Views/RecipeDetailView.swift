//
//  RecipeDetailView.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/10/24.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: DataViewModel
    @State var recipe: RecipesEntity
    @State var isEditing: Bool = false
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .frame(height: 200)
                    .foregroundColor(Color.gray.opacity(0.3))

                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 30))
                    .padding(16)
            }
            ScrollView {
                Text(recipe.name ?? "")
                    .font(.system(size: 30, weight: .bold))
                // categories
                
                Text(recipe.intro ?? "")
                    .padding(25.0)
                    .foregroundColor(Color("textColor"))
                Text("Recipe Ingredients")
                    .font(.system(size: 22, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(recipe.belongsTo?.allObjects as? [CategoriesEntity] ?? [], id: \.self) { category in
                            Button(action: {
                                // filter catergory and refetch recipe and redirect to home
                            }) {
                                Text(category.name ?? "")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                Text("Instructions")
                    .font(.system(size: 22, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Text(recipe.instructions ?? "")
                    .foregroundColor(Color("textColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25.0)
               
                Button(action: {
                    vm.deleteRecipe(recipe: recipe)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Delete")
                        .foregroundStyle(.white)
                        .frame(height: 45)
                        .frame(width: 135)
                        .background(Color.red.cornerRadius(10))
                        .padding(.top, 50)
                })
            }
        }
        .navigationBarItems(
            trailing:
                Button(action: {
                isEditing.toggle()
            }, label: {
                Text("Edit")
                    .foregroundColor(.black)
                    
            })
        )
        .fullScreenCover(isPresented: $isEditing, content: {
            EditView(vm: vm, recipe: recipe, isPresented: $isEditing)
        })
    }
}


