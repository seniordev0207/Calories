//
//  CaloriesWidgetView.swift
//  CaloriesWidgetExtension
//
//  Created by MacBook Pro M1 on 2022/02/21.
//

import SwiftUI
import WidgetKit

// MARK: - Medium Widget
struct CaloriesWidgetMediumView: View {
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    var body: some View {
        HStack {
            CalorieNutritionRingView(energy: energy, basicNutrition: basicNutrition)
            .scaleEffect(0.8)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    EnergySmallView(value: energy.ingestible, color: .irisPurple, unit: "KCAL")
                    EnergySmallView(value: basicNutrition.protein, color: .proteinPink, unit: "g")
                    EnergySmallView(value: basicNutrition.carbohydrates, color: .carbohydratesBlue, unit: "g")
                    EnergySmallView(value: basicNutrition.fatTotal, color: .fatSkyBlue, unit: "g")
                }
            }
            .padding(.leading, 20)
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

// MARK: - Small Widget
struct CaloriesWidgetSmallView: View {
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    var body: some View {
        CalorieNutritionRingView(energy: energy,
                                 basicNutrition: basicNutrition)
            .scaleEffect(0.8)
            .containerBackground(for: .widget) {
                Color.clear
            }
    }
}

struct EnergySmallView: View {
    var value: Int
    var color: Color
    var unit: String
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 1) {
            Text("\(value)")
                .foregroundColor(color)
                .font(.system(.title3, design: .rounded).monospacedDigit())
                .fontWeight(.medium)
                .privacySensitive()
            Text(unit)
                .foregroundColor(color)
                .font(.system(.body, design: .rounded))
                .fontWeight(.medium)
                .padding(.bottom, 1)
        }
    }
}


// MARK: - Calorie and Nutrition Ring View
struct CalorieNutritionRingView: View {
    @Environment(\.redactionReasons) var redactionReasons
    
    var energy: Energy
    var basicNutrition: BasicNutrition
    
    // Basic nutrition goal
    var basicNutritionGoal = BasicNutritionGoal()
    
    var body: some View {
        ZStack {
            if redactionReasons.contains(.privacy) {
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.intakeEnergyGreen)
                    .frame(width: 120, height: 120)
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.proteinPink)
                    .frame(width: 89.5, height: 89.5)
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.carbohydratesBlue)
                    .frame(width: 58.5, height: 58.5)
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.3)
                    .foregroundColor(.fatSkyBlue)
                    .frame(width: 28, height: 28)
            } else {
                // Calorie Ring
                let calorie = Float(energy.dietary) / Float(energy.active + energy.resting)
                RingView(value: calorie,
                         startColor: .intakeEnergyGreen,
                         endColor: .intakeEnergyLightGreen,
                         lineWidth: 15,
                         size: 120)
                
                // Protein Ring
                let protein = Float(basicNutrition.protein) / Float(basicNutritionGoal.protein)
                RingView(value: protein, startColor: .proteinPink, endColor: .proteinLightPink,
                lineWidth: 15,
                         size: 89.5)
                
                // Carbohydrates Ring
                let carbohydrates = Float(basicNutrition.carbohydrates) / Float(basicNutritionGoal.carbohydrates)
                RingView(value: carbohydrates, startColor: .carbohydratesBlue, endColor: .carbohydratesLightBlue,
                lineWidth: 15,
                         size: 58.5)
                
                // Fat Ring
                let fat = Float(basicNutrition.fatTotal) / Float(basicNutritionGoal.fatTotal)
                RingView(value: fat, startColor: .fatSkyBlue, endColor: .fatLightSkyBlue,
                lineWidth: 15,
                size: 28)
            }
        }
    }
}

// MARK: - Previews
struct CaloriesWidgetView_Previews: PreviewProvider {
    static var energy = Energy(resting: 1500, active: 200, dietary: 4000)
    static var basicNutrition = BasicNutrition(protein: 50, carbohydrates: 200, fatTotal: 30)
    
    static var previews: some View {
        Group {
            CaloriesWidgetMediumView(energy: energy, basicNutrition: basicNutrition)
                .preferredColorScheme(.dark)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            CaloriesWidgetSmallView(energy: energy, basicNutrition: basicNutrition)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
