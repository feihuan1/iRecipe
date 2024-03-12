//
//  RecipeCell.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/10/24.
//

import SwiftUI

struct RecipeCell: View {
    @ObservedObject var vm: DataViewModel
    @State var recipe: RecipesEntity
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(height: 150)
                .foregroundColor(Color.gray.opacity(0.3))
            HStack{
                Text(recipe.name ?? "")
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(Color.red)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(recipe.belongsTo?.allObjects as? [CategoriesEntity] ?? [], id: \.self) { category in
                        Button(action: {
                            //How the heck do i filter catergory and refetch recipe
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
            
        }
    }
}


