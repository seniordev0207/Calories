//
//  CaloriesDetailView.swift
//  Calories
//
//  Created by MacBook Pro M1 on 2022/06/12.
//

import SwiftUI

// MARK: - CaloriesView
struct CaloriesView: View {
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    var body: some View {
        NavigationView {
            List {
                Section("Calorie") {
                    NavigationLink {
                        CalorieDetailView(energy: energy)
                    } label: {
                        CalorieTopView(energy: energy)
                    }
                }
                
                Section("Nutrition") {
                    NutritionTopView(basicNutrition: basicNutrition)
                }
            }
            .navigationTitle("Calories")
        }
    }
}

// MARK: - Calorie top View
struct CalorieTopView: View {
    var energy: Energy
    
    private let textStyle: Font.TextStyle = .body
    
    var body: some View {
        HStack(spacing: 25) {
            RingView(value: Float(energy.dietary) / Float(energy.active + energy.resting),
                     startColor: .intakeEnergyLightGreen,
                     endColor: .intakeEnergyGreen,
                     lineWidth: 20)
            .scaleEffect(0.3)
            .frame(width: 45, height: 45)
            
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 15) {
                    CalorieView(energyName: "Resting",
                                energy: energy.resting,
                                color: .consumptionEnergyOrange,
                                textStyle: textStyle)
                    
                    Divider()
                    
                    CalorieView(energyName: "Active",
                                energy: energy.active,
                                color: .consumptionEnergyOrange,
                                textStyle: textStyle)
                }
                .padding(.horizontal, 0)
                
                HStack(spacing: 15) {
                    CalorieView(energyName: "Dietary",
                                energy: energy.dietary,
                                color: .intakeEnergyGreen,
                                textStyle: textStyle)
                    
                    Divider()
                    
                    CalorieView(energyName: "Ingestible",
                                energy: energy.ingestible,
                                color: .irisPurple,
                                textStyle: .body)
                }
                .padding(.horizontal, 0)
        }
        .padding(.vertical, 15)
    }
    }
}

// MARK: - Nutrition top View
struct NutritionTopView: View {
    var basicNutrition: BasicNutrition
    
    private let basicNutritionGoal = BasicNutrition.goal()
    private let textStyle: Font.TextStyle = .body
    
    var body: some View {
        HStack(spacing: 25) {
            ZStack {
                RingView(value: Float(basicNutrition.protein) / Float(basicNutritionGoal.protein),
                         startColor: .proteinLightOrange,
                         endColor: .proteinOrange,
                         lineWidth: 20)
                .scaleEffect(0.3)
                
                RingView(value: Float(basicNutrition.carbohydrates) / Float(basicNutritionGoal.carbohydrates),
                         startColor: .carbohydratesLightBlue,
                         endColor: .carbohydratesBlue,
                         lineWidth: 30)
                .scaleEffect(0.2)
                
                RingView(value: Float(basicNutrition.fatTotal) / Float(basicNutritionGoal.fatTotal),
                         startColor: .fatLightPurple,
                         endColor: .fatPurple,
                         lineWidth: 50)
                .scaleEffect(0.107)
            }
            .frame(width: 45, height: 45)
            
            HStack(spacing: 10) {
                HealthValueView(name: "Protein", value: basicNutrition.protein, unit: "g", color: .proteinOrange)
                
                Divider()
                
                HealthValueView(name: "Carbohydrates", value: basicNutrition.carbohydrates, unit: "g", color: .carbohydratesBlue)
                
                Divider()
                
                HealthValueView(name: "Fat", value: basicNutrition.fatTotal, unit: "g", color: .fatPurple)
            }
        }
        .padding(.vertical, 15)
    }
}


// MARK: - Preview
struct CaloriesView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(energy: Energy(resting: 1500,
                                          active: 200,
                                          dietary: 1600),
        basicNutrition: BasicNutrition(protein: 30, carbohydrates: 200, fatTotal: 20))
        .preferredColorScheme(.dark)
        
    }
}
