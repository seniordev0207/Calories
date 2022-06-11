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
    @Environment(\.redactionReasons) var redactionReasons
    
    var energy: Energy
    
    var body: some View {
        HStack {
            ZStack {
                RingView(value: Float(energy.dietary) / Float(energy.active + energy.resting),
                         startColor: .heathcareLightGreen,
                         endColor: .heathcareGreen)
                .scaleEffect(0.8)
                
                VStack(spacing: 7) {
                    if energy.ingestible >= 0 {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .scaleEffect(1.5)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    EnergySmallView(value: energy.resting + energy.active, color: .heathcareOrange)
                    EnergySmallView(value: energy.dietary, color: .heathcareGreen)
                    EnergySmallView(value: energy.ingestible, color: .heathcareIrisPurple)
                }
            }
            .padding(.leading, 20)
        }
    }
}

// MARK: - Small Widget
struct CaloriesWidgetSmallView: View {
    var energy: Energy
    
    var body: some View {
        ZStack {
            RingView(value: Float(energy.dietary) / Float(energy.active + energy.resting),
                     startColor: .heathcareLightGreen,
                     endColor: .heathcareGreen)
            .scaleEffect(0.9)
            
            VStack(spacing: 10) {
                VStack {
                    if energy.ingestible >= 0 {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .scaleEffect(1.5)
                
                HStack(alignment: .bottom, spacing: 1) {
                    Text("\(energy.ingestible)")
                        .font(.system(.body, design: .rounded).monospacedDigit())
                        .fontWeight(.medium)
                        .privacySensitive()
                    Text("kcal")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.bottom, 1)
                }
                .scaleEffect(0.9)
            }
        }
    }
}

// MARK: - Small Widget (Bar chart)
struct BarView: View {
    var value: CGFloat
    var color: Color = Color(.sRGB, red: 0.2, green: 0.5, blue: 0.8)
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: value, height: 15)
                .foregroundColor(color)
        }
    }
}

struct EnergyBarChartView: View {
    var energy: Energy
    
    let scale: CGFloat = 1.0 / 20.0
    let maxWidth = 90.0
    
    @Environment(\.redactionReasons) var redactionReasons
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                if redactionReasons.contains(.privacy) {
                    // hide bar charts
                    BarView(value: maxWidth, color: .heathcareOrange.opacity(0.2))
                    BarView(value: maxWidth, color: .heathcareGreen.opacity(0.2))
                } else {
                    let values = calcBarChartWidth(
                        consumptionEnergy: energy.resting + energy.active,
                        intakeEnergy: energy.dietary
                    )
                    
                    BarView(value: values.comsumption,
                            color: .heathcareOrange)
                    
                    BarView(value: values.intake,
                            color: .heathcareGreen)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 5)
    }
    
    private func calcBarChartWidth(consumptionEnergy: Int, intakeEnergy: Int) -> (comsumption: CGFloat, intake: CGFloat) {
        
        if CGFloat(consumptionEnergy) * scale < maxWidth &&
            CGFloat(intakeEnergy) * scale < maxWidth {
            return (CGFloat(consumptionEnergy) * scale, CGFloat(intakeEnergy) * scale)
        }
        
        if consumptionEnergy > intakeEnergy {
            return (maxWidth, CGFloat(intakeEnergy) / CGFloat(consumptionEnergy) * maxWidth)
        } else {
            return (CGFloat(consumptionEnergy) / CGFloat(intakeEnergy) * maxWidth, maxWidth)
        }
    }
}

struct EnergySmallView: View {
    var value: Int
    var color: Color
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 1) {
            Text("\(value)")
                .foregroundColor(color)
                .font(.system(.title3, design: .rounded).monospacedDigit())
                .fontWeight(.medium)
                .privacySensitive()
            Text("KCAL")
                .foregroundColor(color)
                .font(.system(.body, design: .rounded))
                .fontWeight(.medium)
                .padding(.bottom, 1)
                
        }
    }
}

struct CaloriesWidgetSmallBarChartView: View {
    var energy: Energy
    
    var body: some View {
        VStack {
            EnergyBarChartView(energy: energy)
            
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    EnergySmallView(value: energy.resting + energy.active, color: .heathcareOrange)
                    EnergySmallView(value: energy.dietary, color: .heathcareGreen)
                    EnergySmallView(value: energy.ingestible, color: .heathcareIrisPurple)
                }
                Spacer()
            }
            .padding(.leading, 20)
        }
    }
}

// MARK: - Previews
struct CaloriesWidgetView_Previews: PreviewProvider {
    static var energy = Energy(resting: 1500, active: 200, dietary: 4000)
    
    static var previews: some View {
        Group {
            CaloriesWidgetMediumView(energy: energy)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            CaloriesWidgetSmallView(energy: energy)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            CaloriesWidgetSmallBarChartView(energy: energy)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
