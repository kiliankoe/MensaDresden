import SwiftUI
import EmealKit

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
        List(currentTwoWeeks) { date in
            NavigationLink(destination: CustomDateMealListView(canteen: self.canteen, selectedDate: date)) {
                if date.isToday {
                    Text(self.string(for: date))
                        .foregroundColor(.accentColor)
                } else if date.isWeekend {
                    Text(self.string(for: date))
                        .foregroundColor(.gray)
                } else {
                    Text(self.string(for: date))
                }
            }
        }
        .navigationBarTitle(Text(canteen.name), displayMode: .inline)
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DatePickerView(canteen: Canteen.example)
        }
    }
}
