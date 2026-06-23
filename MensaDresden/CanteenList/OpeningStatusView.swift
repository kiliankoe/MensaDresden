import SwiftUI
import EmealKit

struct OpeningStatusView: View {
    let canteen: Canteen
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            let statuses = openingStatuses(at: context.date) ?? []
            let hasChanged = hasActiveChangedHours(at: context.date)

            if !statuses.isEmpty || hasChanged {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(statuses) { status in
                        HStack(spacing: 4) {
                            Image(systemName: status.icon)
                                .font(.system(size: 15))
                                .foregroundColor(status.color)
                                .frame(width: 18, alignment: .center)

                            label(for: status)
                                .font(.caption2)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }

                    if hasChanged {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 15))
                                .foregroundColor(.red)
                                .frame(width: 18, alignment: .center)

                            Text(canteen.openingHours?.changedHours.first?.area ?? NSLocalizedString("opening-status.modified-hours", comment: ""))
                                .font(.caption2)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }
                    }
                }
            } else {
                // Fallback for no data - do not show "Closed", just empty view
                EmptyView()
            }
        }
    }

    private func hasActiveChangedHours(at date: Date) -> Bool {
        canteen.openingHours?.hasChangedHours(at: date) ?? false
    }

    /// Builds the compact status label: a leading detail token (countdown / "now" /
    /// "closed") in secondary color, followed by the area name in primary color.
    /// Concatenating into a single `Text` prevents per-character wrapping on narrow rows.
    private func label(for status: StatusDisplay) -> Text {
        let area = Text(status.area).foregroundColor(.primary)
        if status.detail.isEmpty { return area }
        if status.area.isEmpty { return Text(status.detail).foregroundColor(.secondary) }
        return Text(status.detail).foregroundColor(.secondary) + Text(" ") + area
    }

    struct StatusDisplay: Identifiable {
        let id: UUID
        let area: String      // meal/area name, may be ""
        let detail: String    // leading token (countdown / "now" / "closed"), may be ""
        let icon: String
        let color: Color
    }
    
    private func openingStatuses(at date: Date) -> [StatusDisplay]? {
        guard let openingHours = canteen.openingHours else {
            return canteen.isOpen(at: date) ?
                [StatusDisplay(id: UUID(), area: "", detail: NSLocalizedString("opening-status.open", comment: ""), icon: "checkmark", color: .green)] :
                nil
        }
        
        let rawStatuses = openingHours.serviceStatuses(at: date)
        guard !rawStatuses.isEmpty else { return nil }
        
        // Deduplicate statuses with same time
        var uniqueStatuses: [OpeningHours.ServiceStatus] = []
        
        for status in rawStatuses {
            let timeKey = Int(status.timeUntilChange)
            
            // Check if we have a status with roughly the same time (within 1 minute)
            if let existingIndex = uniqueStatuses.firstIndex(where: { abs(Int($0.timeUntilChange) - timeKey) < 60 }) {
                let existing = uniqueStatuses[existingIndex]
                
                // Check if names are generic
                let existingIsGeneric = existing.area.contains("Öffnungszeiten") || existing.area.contains("Haus")
                let currentIsGeneric = status.area.contains("Öffnungszeiten") || status.area.contains("Haus")
                
                if existingIsGeneric && !currentIsGeneric {
                    // Replace generic with specific
                    uniqueStatuses[existingIndex] = status
                } else if !existingIsGeneric && !currentIsGeneric {
                    // Both are specific names - prefer shorter opening span
                    if status.totalDuration < existing.totalDuration {
                        uniqueStatuses[existingIndex] = status
                    }
                }
                // If both are generic or current is generic, keep existing
            } else {
                uniqueStatuses.append(status)
            }
        }
        
        return uniqueStatuses.map { status in
            let minutes = Int(status.timeUntilChange / 60)
            let hours = Int(status.timeUntilChange / 3600)

            var detail = ""
            var icon = "clock"
            var color: Color = .secondary

            var areaName = status.area

            // Clean up area name
            // Remove "Öffnungszeiten" and "Semester"
            areaName = areaName.replacingOccurrences(of: "Öffnungszeiten", with: "")
                .replacingOccurrences(of: "Semester", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)

            // If empty or too short after cleaning, fallback to "House"
            if areaName.count <= 3 {
                areaName = NSLocalizedString("opening-hours.house", comment: "")
            }
            // Remove leading colons/punctuation if present
            areaName = areaName.trimmingCharacters(in: CharacterSet(charactersIn: ": "))

            // The verbose state words ("Open"/"Opens in"/"Closes in") are dropped — the
            // icon and color convey the state. Only a compact time token is shown.
            if status.isOpen {
                // OPEN
                color = minutes < 60 ? .orange : .green
                icon = minutes < 60 ? "hourglass" : "checkmark"

                if minutes >= 60 {
                    detail = "" // plenty of time left: just the area name
                } else if minutes <= 0 {
                    detail = NSLocalizedString("opening-status.now-short", comment: "")
                } else {
                    detail = String(format: NSLocalizedString("opening-status.in-minutes-short", comment: ""), minutes)
                }

            } else {
                // CLOSED
                color = minutes < 60 ? .green : .secondary // Green if opening soon
                icon = "clock"

                if hours >= 24 {
                    detail = NSLocalizedString("opening-status.closed", comment: "")
                } else if minutes <= 0 {
                    detail = NSLocalizedString("opening-status.now-short", comment: "")
                } else if minutes < 60 {
                    detail = String(format: NSLocalizedString("opening-status.in-minutes-short", comment: ""), minutes)
                } else {
                    detail = String(format: NSLocalizedString("opening-status.in-hours-short", comment: ""), hours)
                }
            }

            return StatusDisplay(
                id: status.id,
                area: areaName,
                detail: detail,
                icon: icon,
                color: color
            )
        }
    }
}
