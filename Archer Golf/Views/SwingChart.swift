//
//  SwingChart.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 11/10/23.
//

import SwiftUI
import Charts
import SwiftData

struct SwingChart: View {
    @Binding var swing: Swing
    
    var body: some View {
        let accelXData = swing.accelX.enumerated().map { index, element in
            SensorReading(index: index , reading: element)
        }
        let accelYData = swing.accelY.enumerated().map { index, element in
            SensorReading(index: index , reading: element)
        }
        let accelZData = swing.accelZ.enumerated().map { index, element in
            SensorReading(index: index , reading: element)
        }
        let chartData = [ (axis: "Accel X", data: accelXData),
                      (axis: "Accel Y", data: accelYData),
                      (axis: "Accel Z", data: accelZData)]
        
        Chart {
            ForEach(chartData, id: \.axis) { series in
                ForEach(series.data) { item in
                    LineMark(
                        x: .value("x", item.index),
                        y: .value("y", item.reading)
                    )
                }
                .foregroundStyle(by: .value("Axis", series.axis))
            }
        }
        .padding()
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxisLabel("ms")
        .chartYAxisLabel("Gs")
    }
}

struct SensorReading: Identifiable {
    var id = UUID()
    var index: Int
    var reading: Double
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Swing.self, SwingSession.self, configurations: config)
        
        @State var exampleSwing: Swing = Swing(faceAngle: 0.0, swingSpeed: 1.2, swingPath: 2.2, backSwingTime: 1.1, downSwingTime: 0.7)
        
        exampleSwing.accelX = (1...100).map { _ in Double.random(in: -6.0...6.0) }
        exampleSwing.accelY = (1...100).map { _ in Double.random(in: -6.0...6.0) }
        exampleSwing.accelZ = (1...100).map { _ in Double.random(in: -6.0...6.0) }
        
        exampleSwing.gyroX = (1...100).map { _ in Double.random(in: -6.0...6.0) }
        exampleSwing.gyroY = (1...100).map { _ in Double.random(in: -6.0...6.0) }
        exampleSwing.gyroZ = (1...100).map { _ in Double.random(in: -6.0...6.0) }
        
        var exampleSession = SwingSession()
        exampleSession.accelX = [0.2, 0.1, 0.3]
        
        exampleSession.swings.append(exampleSwing)
        
        return SwingChart(swing: $exampleSwing)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
