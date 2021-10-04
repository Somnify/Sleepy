import Foundation
import SwiftUI

public enum BarType {
    case rectangle(color: Color)
    case circle(color: Color)
    case filled(foregroundElementColor: Color, backgroundElementColor: Color, percentage: Double)
}

public enum StandardChartType {

    case phasesChart
    case defaultChart(barType: BarType)
    case verticalProgress(foregroundElementColor: Color, backgroundElementColor: Color, max: Double)

}
