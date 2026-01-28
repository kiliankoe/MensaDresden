import SwiftUI
import Charts
import EmealKit

struct EmealStatisticsView: View {
    let transactions: [EmealKit.Transaction]
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private func formatCurrency(_ value: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: value)) ?? "€0.00"
    }
    
    private func formatDecimal(_ value: Double) -> String {
        decimalFormatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    private var salesTransactions: [EmealKit.Transaction] {
        transactions.filter { $0.kind == .sale }
    }
    
    private var spendingByMonth: [(month: String, amount: Double, date: Date)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: salesTransactions) { transaction in
            calendar.dateComponents([.year, .month], from: transaction.date)
        }
        
        return grouped.map { (key, transactions) in
            let monthDate = calendar.date(from: key) ?? Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yy"
            let monthStr = formatter.string(from: monthDate)
            let total = transactions.reduce(0) { $0 + abs($1.amount) }
            return (monthStr, total, monthDate)
        }
        .sorted { $0.date < $1.date }
    }
    
    private var locationStats: [(location: String, count: Int, total: Double)] {
        let grouped = Dictionary(grouping: salesTransactions) { $0.location }
        return grouped.map { (location, transactions) in
            let count = transactions.count
            let total = transactions.reduce(0) { $0 + abs($1.amount) }
            return (location, count, total)
        }
        .sorted { $0.count > $1.count }
    }
    
    private func shouldShowRegisterBreakdown(for location: String) -> Bool {
        let registers = Set(salesTransactions.filter { $0.location == location }.map { $0.register })
        return registers.count > 2
    }
    
    private func registerStats(for location: String) -> [(register: String, count: Int)] {
        let grouped = Dictionary(grouping: salesTransactions.filter { $0.location == location }) { $0.register }
        return grouped.map { (register, transactions) in
            (register, transactions.count)
        }
        .sorted { $0.count > $1.count }
    }
    
    private var mostExpensivePurchases: [EmealKit.Transaction] {
        Array(salesTransactions.sorted { abs($0.amount) > abs($1.amount) }.prefix(3))
    }
    
    private var totalSpent: Double {
        salesTransactions.reduce(0) { $0 + abs($1.amount) }
    }
    
    private var averageSpending: Double {
        guard !salesTransactions.isEmpty else { return 0 }
        return totalSpent / Double(salesTransactions.count)
    }
    
    private var totalSaved: Double {
        salesTransactions.reduce(0) { sum, transaction in
            sum + transaction.positions.reduce(0) { posSum, position in
                posSum + (position.discount ?? 0)
            }
        }
    }
    
    private var spendingByDayOfWeek: [(day: String, amount: Double)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: salesTransactions) { transaction in
            calendar.component(.weekday, from: transaction.date)
        }
        
        let dayKeys = ["emeal.statistics.day.sun", "emeal.statistics.day.mon", "emeal.statistics.day.tue", 
                       "emeal.statistics.day.wed", "emeal.statistics.day.thu", "emeal.statistics.day.fri", "emeal.statistics.day.sat"]
        return (1...7).map { weekday in
            let transactions = grouped[weekday] ?? []
            let total = transactions.reduce(0) { $0 + abs($1.amount) }
            return (NSLocalizedString(dayKeys[weekday - 1], comment: ""), total)
        }
    }
    
    private var dailySpending: [Date: Double] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: salesTransactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        
        return grouped.mapValues { transactions in
            transactions.reduce(0) { $0 + abs($1.amount) }
        }
    }
    
    private var maxDailySpending: Double {
        dailySpending.values.max() ?? 1.0
    }
    
    private func heatmapColor(for amount: Double) -> Color {
        let intensity = amount / maxDailySpending
        if intensity == 0 {
            return Color(.systemGray6)
        } else if intensity < 0.25 {
            return Color.green.opacity(0.3)
        } else if intensity < 0.5 {
            return Color.green.opacity(0.5)
        } else if intensity < 0.75 {
            return Color.green.opacity(0.7)
        } else {
            return Color.green.opacity(0.9)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Summary Cards
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        StatCard(title: LocalizedStringKey("emeal.statistics.total-spent"), value: formatCurrency(totalSpent), color: .red)
                        StatCard(title: LocalizedStringKey("emeal.statistics.avg-purchase"), value: formatCurrency(averageSpending), color: .blue)
                    }
                    
                    if totalSaved > 0 {
                        StatCard(title: LocalizedStringKey("emeal.statistics.total-saved"), value: formatCurrency(totalSaved), color: .green)
                            
                    }
                }.padding(.horizontal)
                
                // Activity Heatmap
                if !salesTransactions.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("emeal.statistics.activity-title")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        SpendingHeatmapView(
                            dailySpending: dailySpending,
                            colorForAmount: heatmapColor
                        )
                        .padding(.horizontal)
                        
                        HStack(spacing: 4) {
                            Text("emeal.statistics.activity-legend-less")
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                            ForEach(0..<5) { i in
                                Rectangle()
                                    .fill(heatmapColor(for: maxDailySpending * Double(i) / 4.0))
                                    .frame(width: 10, height: 10)
                                    .cornerRadius(2)
                            }
                            Text("emeal.statistics.activity-legend-more")
                                .font(.system(size: 9))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                }
                
                // Spending by Month
                if !spendingByMonth.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("emeal.statistics.spending-by-month")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(spendingByMonth, id: \.month) { item in
                                BarMark(
                                    x: .value("Month", item.month),
                                    y: .value("Amount", item.amount)
                                )
                                .foregroundStyle(Color.blue.gradient)
                                .annotation(position: .top) {
                                    Text(formatDecimal(item.amount) + " €")
                                        .font(.caption2)
                                }
                            }
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                    }
                }
                
                // Spending by Day of Week
                VStack(alignment: .leading, spacing: 8) {
                    Text("emeal.statistics.spending-by-day")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Chart {
                        ForEach(spendingByDayOfWeek, id: \.day) { item in
                            BarMark(
                                x: .value("Day", item.day),
                                y: .value("Amount", item.amount)
                            )
                            .foregroundStyle(Color.green.gradient)
                        }
                    }
                    .frame(height: 180)
                    .padding(.horizontal)
                }
                
                // Most Visited Locations
                if !locationStats.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("emeal.statistics.most-visited")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(locationStats.prefix(5), id: \.location) { item in
                                // Main location bar
                                BarMark(
                                    x: .value("Visits", item.count),
                                    y: .value("Location", item.location)
                                )
                                .foregroundStyle(Color.orange.gradient)
                                .annotation(position: .trailing) {
                                    Text("\(item.count)")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                }
                                
                                // Register breakdown (if more than 2 registers)
                                if shouldShowRegisterBreakdown(for: item.location) {
                                    ForEach(registerStats(for: item.location), id: \.register) { registerItem in
                                        BarMark(
                                            x: .value("Visits", registerItem.count),
                                            y: .value("Location", "  " + registerItem.register)
                                        )
                                        .foregroundStyle(Color.yellow)
                                        .annotation(position: .trailing) {
                                            Text("\(registerItem.count)")
                                                .font(.caption2)
                                        }
                                    }
                                }
                            }
                        }
                        .chartYAxis {
                            AxisMarks { value in
                                AxisValueLabel {
                                    if let label = value.as(String.self) {
                                        Text(label)
                                            .font(label.hasPrefix("  ") ? .caption : .subheadline)
                                            .foregroundColor(label.hasPrefix("  ") ? .secondary : .primary)
                                    }
                                }
                            }
                        }
                        .frame(height: CGFloat(locationStats.prefix(5).reduce(0) { count, item in
                            count + 1 + (shouldShowRegisterBreakdown(for: item.location) ? registerStats(for: item.location).count : 0)
                        }) * 35)
                        .padding(.horizontal)
                    }
                }
                
                // Location Spending Distribution
                if !locationStats.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("emeal.statistics.spending-by-location")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if #available(iOS 17.0, *) {
                            Chart {
                                ForEach(locationStats, id: \.location) { item in
                                    SectorMark(
                                        angle: .value("Amount", item.total),
                                        innerRadius: .ratio(0.5),
                                        angularInset: 1.5
                                    )
                                    .cornerRadius(4)
                                    .foregroundStyle(by: .value("Location", item.location))
                                }
                            }
                            .chartLegend(alignment: .center, spacing: 16)
                            .frame(height: 300)
                            .padding(.horizontal, 8)
                        } else {
                            Chart {
                                ForEach(locationStats, id: \.location) { item in
                                    BarMark(
                                        x: .value("Amount", item.total),
                                        y: .value("Location", item.location)
                                    )
                                    .foregroundStyle(Color.purple.gradient)
                                    .annotation(position: .trailing) {
                                        Text(formatCurrency(item.total))
                                            .font(.caption2)
                                    }
                                }
                            }
                            .frame(height: CGFloat(min(locationStats.count, 10)) * 40)
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Most Expensive Purchases
                if !mostExpensivePurchases.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("emeal.statistics.most-expensive")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(Array(mostExpensivePurchases.enumerated()), id: \.element.id) { index, purchase in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("#\(index + 1)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .fontWeight(.bold)
                                        Text(purchase.location)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text(formatCurrency(abs(purchase.amount)))
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                    }
                                    
                                    Text(Formatter.string(for: purchase.date, dateStyle: .medium, timeStyle: .short))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    if !purchase.positions.isEmpty {
                                        Divider()
                                            .padding(.vertical, 4)
                                        ForEach(purchase.positions, id: \.id) { position in
                                            HStack {
                                                Text("\(position.amount) × \(position.name)")
                                                    .font(.caption)
                                                Spacer()
                                                Text(formatCurrency((position.price-(position.discount ?? 0))))
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Statistics Summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("emeal.statistics.summary")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        StatRow(label: LocalizedStringKey("emeal.statistics.total-transactions"), value: "\(salesTransactions.count)")
                        StatRow(label: LocalizedStringKey("emeal.statistics.unique-locations"), value: "\(locationStats.count)")
                        if let favorite = locationStats.first {
                            StatRow(label: LocalizedStringKey("emeal.statistics.favorite-location"), value: favorite.location)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

struct StatCard: View {
    let title: LocalizedStringKey
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatRow: View {
    let label: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct SpendingHeatmapView: View {
    let dailySpending: [Date: Double]
    let colorForAmount: (Double) -> Color
    
    private let calendar = Calendar.current
    private let daysToShow = 180
    
    private var weeksData: [(id: Int, dates: [Date])] {
        let today = calendar.startOfDay(for: Date())
        
        // Find the start of the current week (Sunday)
        let todayWeekday = calendar.component(.weekday, from: today)
        let daysToSubtract = todayWeekday - 1 // Days since Sunday
        guard let endOfWeekSunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: today) else {
            return []
        }
        
        // Calculate number of full weeks needed
        let weeksToShow = Int(ceil(Double(daysToShow) / 7.0))
        
        // Start from the beginning (oldest week)
        guard let startDate = calendar.date(byAdding: .weekOfYear, value: -(weeksToShow - 1), to: endOfWeekSunday) else {
            return []
        }
        
        var weeks: [(id: Int, dates: [Date])] = []
        var currentWeekStart = startDate
        
        for weekIndex in 0..<weeksToShow {
            var weekDates: [Date] = []
            for dayOffset in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStart) {
                    weekDates.append(date)
                }
            }
            weeks.append((id: weekIndex, dates: weekDates))
            currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) ?? currentWeekStart
        }
        
        return weeks
    }
    
    var body: some View {
        let weeks = weeksData
        let today = calendar.startOfDay(for: Date())
        let spacing: CGFloat = 2
        let dayLabelWidth: CGFloat = 16
        
        let dayKeys = ["emeal.statistics.day.sun", "emeal.statistics.day.mon", "emeal.statistics.day.tue", 
                       "emeal.statistics.day.wed", "emeal.statistics.day.thu", "emeal.statistics.day.fri", "emeal.statistics.day.sat"]
        let dayLabels = dayKeys.map { key in
            String(NSLocalizedString(key, comment: "").prefix(1))
        }
        
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - dayLabelWidth - 4
            let idealCellSize = (availableWidth - CGFloat(weeks.count - 1) * spacing) / CGFloat(weeks.count)
            // Cap cell size at 12 to prevent excessive growth on large screens
            let cellSize = min(idealCellSize, 12)
            let totalContentWidth = CGFloat(weeks.count) * cellSize + CGFloat(weeks.count - 1) * spacing + dayLabelWidth + 4
            let horizontalPadding = max((geometry.size.width - totalContentWidth) / 2, 0)
            
            HStack {
                Spacer()
                    .frame(width: horizontalPadding)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Heatmap grid with day labels
                    HStack(alignment: .top, spacing: 4) {
                        // Day labels
                        VStack(alignment: .trailing, spacing: spacing) {
                            ForEach(Array(dayLabels.enumerated()), id: \.offset) { _, day in
                                Text(day)
                                    .font(.system(size: 8))
                                    .foregroundColor(.gray)
                                    .frame(width: dayLabelWidth, height: cellSize, alignment: .trailing)
                            }
                        }
                        
                        // Heatmap cells
                        HStack(alignment: .top, spacing: spacing) {
                            ForEach(weeks, id: \.id) { week in
                                VStack(spacing: spacing) {
                                    ForEach(Array(week.dates.enumerated()), id: \.offset) { _, date in
                                        let dayStart = calendar.startOfDay(for: date)
                                        let amount = dailySpending[dayStart] ?? 0
                                        let isFuture = dayStart > today
                                        
                                        Rectangle()
                                            .fill(isFuture ? Color.clear : colorForAmount(amount))
                                            .frame(width: cellSize, height: cellSize)
                                            .cornerRadius(2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 2)
                                                    .stroke(isFuture ? Color.clear : Color.gray.opacity(0.2), lineWidth: 0.5)
                                            )
                                    }
                                }
                            }
                        }
                    }
                    
                    // Month labels
                    HStack(alignment: .top, spacing: 0) {
                        Color.clear
                            .frame(width: dayLabelWidth + 4)
                        
                        ForEach(weeks, id: \.id) { week in
                            if let firstDay = week.dates.first {
                                let dayOfMonth = calendar.component(.day, from: firstDay)
                                let isFirstWeek = week.id == 0
                                let isNewMonth = dayOfMonth <= 7 && week.id > 0
                                
                                if isFirstWeek || isNewMonth {
                                    Text(firstDay.formatted(.dateTime.month(.abbreviated)))
                                        .font(.system(size: 9))
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .fixedSize()
                                        .frame(width: cellSize + spacing, alignment: .leading)
                                } else {
                                    Color.clear
                                        .frame(width: cellSize + spacing)
                                }
                            } else {
                                Color.clear
                                    .frame(width: cellSize + spacing)
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(width: horizontalPadding)
            }
        }
        .frame(height: min(12 * 7 + 6 * 2 + 20, 100))
    }
}

struct EmealStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        EmealStatisticsView(transactions: EmealKit.Transaction.extensiveExampleValues)
    }
}
