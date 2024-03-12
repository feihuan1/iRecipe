//
//  DataViewModel.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/9/24.
//

import Foundation
import CoreData

class DataViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    @Published var recipes: [RecipesEntity] = []
    @Published var users: [UsersEntity] = []
    @Published var categories: [CategoriesEntity] = []
    
    init() {
        addDefaultRecipes()
        addDefaultCategories()
        addDefaultUser()
        getRecipes()
        getUsers()
        getCategories()

    }
    
    
    func getRecipes() {
        let request = NSFetchRequest<RecipesEntity>(entityName: "RecipesEntity")
        
        do {
            recipes = try manager.context.fetch(request)
        } catch let error {
            print("error fetching recipes: \(error)")
        }
    }
        
    func getUsers() {
        let request = NSFetchRequest<UsersEntity>(entityName: "UsersEntity")
        
        do {
            users = try manager.context.fetch(request)
        } catch let error {
            print("error fetching Users: \(error)")
        }
    }
        
    func getCategories() {
        let request = NSFetchRequest<CategoriesEntity>(entityName: "CategoriesEntity")
        
        do {
            categories = try manager.context.fetch(request)
        } catch let error {
            print("error fetching categories: \(error)")
        }
    }
    
    func addRecipe(name: String, intro: String, instruction: String, categories: [CategoriesEntity]) {
        let request = NSFetchRequest<CategoriesEntity>(entityName: "CategoriesEntity")
        request.predicate = NSPredicate(format: "name == %@", "All")
        
        do {
            var allCategory = try manager.context.fetch(request).first

            if allCategory == nil {
                allCategory = CategoriesEntity(context: manager.context)
                allCategory?.name = "All"
            }

            let newRecipe = RecipesEntity(context: manager.context)
            newRecipe.id = UUID()
            newRecipe.name = name
            newRecipe.intro = intro
            newRecipe.instructions = instruction

            if let existingAllCategory = allCategory {
                newRecipe.belongsTo = [existingAllCategory]
            }

            for category in categories {
                newRecipe.addToBelongsTo(category)
            }

            save()
        } catch {
            print("Fetch recipe func had a problem: \(error.localizedDescription)")
        }
    }
    
    func addUser(username: String, password: String) {
        let newUser = UsersEntity(context: manager.context)
        newUser.id = UUID()
        newUser.userName = username
        newUser.password = password
        newUser.isVolumeUnitTbsp = false
        newUser.isWeightUnitOz = false
        save()
    }
    
    func addCategory(name: String) {
        guard !categories.contains(where: { $0.name == name }) else {
            return
        }

        let newCategory = CategoriesEntity(context: manager.context)
        newCategory.name = name
        categories = categories.filter { $0.name != name }

        save()
    }
    func addCategoriesToRecipe(recipe: RecipesEntity, categoryNames: [String]) {
        var categoriesToAdd: [CategoriesEntity] = []

        for categoryName in categoryNames {
            if let existingCategory = categories.first(where: { $0.name == categoryName }) {
                categoriesToAdd.append(existingCategory)
            } else {
                let newCategory = CategoriesEntity(context: manager.context)
                newCategory.name = categoryName
                categoriesToAdd.append(newCategory)
            }
        }
        recipe.addToBelongsTo(NSSet(array: categoriesToAdd))

        save()
    }
    
    func removeCategoryFromRecipe(recipe: RecipesEntity, categoryName: String) {
        if let categoryToRemove = categories.first(where: { $0.name == categoryName }) {
            recipe.removeFromBelongsTo(categoryToRemove)
            save()
        }
    }
    
    func editRecipe(recipe: RecipesEntity, newName: String, newIntro: String, newInstructions: String) {
        recipe.name = newName
        recipe.intro = newIntro
        recipe.instructions = newInstructions

        save()
    }
    
    func deleteRecipe(recipe: RecipesEntity) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            manager.context.delete(recipes[index])
            recipes.remove(at: index)
            save()
        }
    }
    
    
    func toggleWeightUnit() {
        guard let firstUser = users.first else {
            return
        }
        firstUser.isWeightUnitOz.toggle()
        save()
    }
    
    func toggleVolumeUnit() {
        guard let firstUser = users.first else {
            return 
        }
        firstUser.isVolumeUnitTbsp.toggle()
        save()
    }
    
    
    func deleteAllData() {
        let recipesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipesEntity")
        let recipesDeleteRequest = NSBatchDeleteRequest(fetchRequest: recipesFetchRequest)

        let usersFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersEntity")
        let usersDeleteRequest = NSBatchDeleteRequest(fetchRequest: usersFetchRequest)

        let categoriesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesEntity")
        let categoriesDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoriesFetchRequest)

        do {
            try manager.context.execute(recipesDeleteRequest)
            try manager.context.execute(usersDeleteRequest)
            try manager.context.execute(categoriesDeleteRequest)

            save()

            getUsers()
            getRecipes()
            getCategories()

        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
    
    func save (){
        recipes.removeAll()
        users.removeAll()
        categories.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
            self.manager.save()
            self.getUsers()
            self.getRecipes()
            self.getCategories()
        }
    }
    
    func addDefaultUser() {
        let request = NSFetchRequest<UsersEntity>(entityName: "UsersEntity")

        do {
            let userCount = try manager.context.count(for: request)
            guard userCount == 0 else {
                return
            }
     
        let defaultUser = UsersEntity(context: manager.context)
        defaultUser.id = UUID()
        defaultUser.userName = "DefaultUser"
        defaultUser.password = "DefaultPassword"
        defaultUser.isVolumeUnitTbsp = false
        defaultUser.isWeightUnitOz = false

        save()

        getUsers()
        } catch {
            print("Error checking category count: \(error.localizedDescription)")
        }
    }
    
    func addDefaultCategories() {
        let request = NSFetchRequest<CategoriesEntity>(entityName: "CategoriesEntity")

        do {
            let categoryCount = try manager.context.count(for: request)
            guard categoryCount < 2 else {
                return
            }

        let defaultCategory1 = CategoriesEntity(context: manager.context)
        defaultCategory1.name = "Vegetarian"

        let defaultCategory2 = CategoriesEntity(context: manager.context)
        defaultCategory2.name = "Seafood"

        let defaultCategory3 = CategoriesEntity(context: manager.context)
        defaultCategory3.name = "Desserts"

        let defaultCategory4 = CategoriesEntity(context: manager.context)
        defaultCategory4.name = "Italian"

        let defaultCategory5 = CategoriesEntity(context: manager.context)
        defaultCategory5.name = "Breakfast"

        save()

        getCategories()
        } catch {
            print("Error checking category count: \(error.localizedDescription)")
        }
    }
    
    func addDefaultRecipes() {
        let request = NSFetchRequest<RecipesEntity>(entityName: "RecipesEntity")

        do {
            let recipeCount = try manager.context.count(for: request)
            guard recipeCount == 0 else {
                return
            }
        let allCategory = CategoriesEntity(context: manager.context)
        allCategory.name = "All"

        let defaultRecipe1 = RecipesEntity(context: manager.context)
        defaultRecipe1.id = UUID()
        defaultRecipe1.name = "Kongpao chicken"
        defaultRecipe1.intro = "Dont' eat it if you can't handle spicy food"
        defaultRecipe1.instructions = "Very easy to make, just call User eats"
        defaultRecipe1.belongsTo = [allCategory]

        let defaultRecipe2 = RecipesEntity(context: manager.context)
        defaultRecipe2.id = UUID()
        defaultRecipe2.name = "apple pie"
        defaultRecipe2.intro = "this is a sweet food that might cause you gain weight"
        defaultRecipe2.instructions = "why make it? go to walmart"
        defaultRecipe2.belongsTo = [allCategory]

        let defaultRecipe3 = RecipesEntity(context: manager.context)
        defaultRecipe3.id = UUID()
        defaultRecipe3.name = "Ramen"
        defaultRecipe3.intro = "the spirit of fire, best food in Naruto"
        defaultRecipe3.instructions = "you can have it in sweet dreams, dont need cook it yourself"
        defaultRecipe3.belongsTo = [allCategory]

        let defaultRecipe4 = RecipesEntity(context: manager.context)
        defaultRecipe4.id = UUID()
        defaultRecipe4.name = "steam fish"
        defaultRecipe4.intro = "eat this will make your life longer"
        defaultRecipe4.instructions = "buy a fish and cook it"
        defaultRecipe4.belongsTo = [allCategory]

        let defaultRecipe5 = RecipesEntity(context: manager.context)
        defaultRecipe5.id = UUID()
        defaultRecipe5.name = "veggi"
        defaultRecipe5.intro = "it taste bad but you'd better eat some"
        defaultRecipe5.instructions = "easy to make, just buy from store and eat it raw"
        defaultRecipe5.belongsTo = [allCategory]

        save()

        getRecipes()
        } catch {
            print("Error checking recipe count: \(error.localizedDescription)")
        }
    }
    
}
