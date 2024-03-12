//
//  SettingView.swift
//  iRecipe
//
//  Created by Feihuan Peng on 3/9/24.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var vm: DataViewModel

    var body: some View {
        
        VStack{
            
                Text("Setting")
                    .font(.system(size: 36, weight: .black))
                    .offset(y: -60)
                
                
            if let user = vm.users.first {
                Button(action: {
                    vm.toggleVolumeUnit()
                }, label: {
                    Text("Volume: \(user.isVolumeUnitTbsp ? "tbsp" : "ml")")
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.cornerRadius(10))
                })
                .padding()
                
                Button(action: {
                    vm.toggleWeightUnit()
                }, label: {
                    Text("Weight: \(user.isWeightUnitOz ? "oz" : "g")")
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.cornerRadius(10))
                })
                .padding()
            }
                
                Button(action: {
                    vm.deleteAllData()
                }, label: {
                    Text("Life Saver")
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.green.cornerRadius(10))
                })
                .padding()
                
                
                Button(action: {
                    
                }, label: {
                    Text("Sign Out")
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.cornerRadius(10))
                })
                .padding()
            
        }
            .padding()
        
        
    }
}

