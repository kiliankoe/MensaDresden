import SwiftUI
import EmealKit
import os.log

struct DatePickerView: View {

    var canteen: Canteen

    var currentTwoWeeks: [Date] {
        let calendar = Calendar(identifier: .gregorian)
        guard let thisMonday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return []
        }

        var dates: [Date] = []
        for _ in 0..<14 {
            dates.append(calendar.date(byAdding: .day, value: 1, to: dates.last ?? thisMonday)!)
        }
        return dates
    }

    func string(for date: Date) -> String {
        Formatter.string(for: date, dateStyle: .full, timeStyle: .none)
    }

    var body: some View {
        List {
            if let openingHours = canteen.openingHours {
                Section {
                    OpeningHoursInfoView(openingHours: openingHours)
                        .padding(.vertical, 8)
                }
            }
            
            Section {
                ForEach(currentTwoWeeks) { date in
                    NavigationLink(destination: CustomDateMealListView(canteen: self.canteen, selectedDate: date)) {
                        DateRowView(date: date, string: self.string(for: date))
                    }
                }
            }
        }
        .navigationBarTitle(Text(canteen.name), displayMode: .inline)
        .onAppear {
            Logger.breadcrumb.info("Appear DatePickerView")
        }
    }
}

// MARK: - Supporting Views

private struct OpeningHoursInfoView: View {
    let openingHours: OpeningHours
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("opening-hours.title")
                .font(.headline)
            
            if !openingHours.regularHours.isEmpty {
                RegularHoursSection(slots: openingHours.regularHours)
            }
            
            if !openingHours.changedHours.isEmpty {
                ChangedHoursSection(slots: openingHours.changedHours)
            }
        }
    }
}

private struct RegularHoursSection: View {
    let slots: [OpeningHours.TimeSlot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(slots, id: \.area) { slot in
                TimeSlotView(slot: slot)
            }
        }
    }
}

private struct ChangedHoursSection: View {
    let slots: [OpeningHours.TimeSlot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("opening-hours.modified")
                .font(.subheadline)
                .foregroundColor(.orange)
            
            ForEach(slots, id: \.area) { slot in
                TimeSlotView(slot: slot, showDateRange: true)
            }
        }
    }
}

private struct TimeSlotView: View {
    let slot: OpeningHours.TimeSlot
    var showDateRange: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(slot.area)
                    .font(.caption)
                    .fontWeight(.medium)
                
                if showDateRange, let dateRange = slot.dateRange {
                    Text("(\(dateRange.text))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            if !slot.parsedHours.isEmpty {
                ForEach(Array(slot.parsedHours.enumerated()), id: \.offset) { _, hours in
                    let sortedDays = hours.days.sorted { 
                        OpeningHours.Weekday.allCases.firstIndex(of: $0)! < OpeningHours.Weekday.allCases.firstIndex(of: $1)!
                    }
                    let daysText = sortedDays.map { $0.rawValue }.joined(separator: ", ")
                    let openTime = String(format: "%02d:%02d", hours.openTime.hour, hours.openTime.minute)
                    let closeTime = String(format: "%02d:%02d", hours.closeTime.hour, hours.closeTime.minute)
                    Text("\(daysText): \(openTime) - \(closeTime)")
                        .font(.caption2)
                        .foregroundColor(.primary)
                }
            } else {
                Text(slot.hoursText)
                    .font(.caption2)
                    .foregroundColor(.primary)
            }
        }
    }
}

private struct DateRowView: View {
    let date: Date
    let string: String
    
    var body: some View {
        if date.isToday {
            Text(string)
                .foregroundColor(.accentColor)
        } else if date.isWeekend {
            Text(string)
                .foregroundColor(.gray)
        } else {
            Text(string)
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatePickerView(canteen: Canteen.example)
        }
    }
}
