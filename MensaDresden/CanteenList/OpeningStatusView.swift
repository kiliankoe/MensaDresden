import SwiftUI
import EmealKit

struct OpeningStatusView: View {
    let canteen: Canteen
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            if let statuses = openingStatuses(at: context.date), !statuses.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(statuses) { status in
                        HStack(spacing: 4) {
                            Image(systemName: status.icon, variableValue: status.fillPercentage)
                                .font(.system(size: 15))
                                .foregroundColor(status.color)
                            
                            HStack(spacing: 4) {
                                if status.text == NSLocalizedString("opening-status.open", comment: "") {
                                    Text(status.subtext)
                                        .font(.caption2)
                                        .foregroundColor(.primary)
                                        .layoutPriority(1)
                                    
                                    Text("opening-status.open")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text(status.text)
                                        .font(.caption2)
                                        .foregroundColor(.primary)
                                        .layoutPriority(1)
                                    
                                    Text(status.subtext)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    
                    if hasActiveChangedHours {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 15))
                                .foregroundColor(.red)
                            
                            Text(canteen.openingHours?.changedHours.first?.area ?? NSLocalizedString("opening-status.modified-hours", comment: ""))
                                .font(.caption2)
                                .foregroundColor(.primary)
                        }
                    }
                }
            } else {
                // Fallback for no data - do not show "Closed", just empty view
                EmptyView()
            }
        }
    }
    
    private var hasActiveChangedHours: Bool {
        canteen.openingHours?.hasChangedHours(at: Date()) ?? false
    }
    
    struct StatusDisplay: Identifiable {
        let id: UUID
        let text: String
        let subtext: String
        let icon: String
        let color: Color
        let fillPercentage: Double
    }
    
    private func openingStatuses(at date: Date) -> [StatusDisplay]? {
        guard let openingHours = canteen.openingHours else {
            return canteen.isOpen(at: date) ? 
                [StatusDisplay(id: UUID(), text: NSLocalizedString("opening-status.open", comment: ""), subtext: "", icon: "checkmark", color: .green, fillPercentage: 1.0)] : 
                nil
        }
        
        let rawStatuses = openingHours.serviceStatuses(at: date)
        guard !rawStatuses.isEmpty else { return nil }
        
        // Deduplicate statuses with same time
        var uniqueStatuses: [OpeningHours.ServiceStatus] = []
        var timesSeen: Set<Int> = [] // Time interval as int for rough equality
        
        for status in rawStatuses {
            let timeKey = Int(status.timeUntilChange)
            
            // Check if we have a status with roughly the same time (within 1 minute)
            if let existingIndex = uniqueStatuses.firstIndex(where: { abs(Int($0.timeUntilChange) - timeKey) < 60 }) {
                let existing = uniqueStatuses[existingIndex]
                
                // If current status is more specific (not "House" / "Öffnungszeiten"), replace existing
                let existingIsGeneric = existing.area.contains("Öffnungszeiten") || existing.area.contains("Haus")
                let currentIsGeneric = status.area.contains("Öffnungszeiten") || status.area.contains("Haus")
                
                if existingIsGeneric && !currentIsGeneric {
                    uniqueStatuses[existingIndex] = status
                }
                // If both are generic or both specific, keep existing (earlier in list usually means higher priority from OpeningHours logic)
            } else {
                uniqueStatuses.append(status)
            }
        }
        
        return uniqueStatuses.map { status in
            let minutes = Int(status.timeUntilChange / 60)
            let hours = Int(status.timeUntilChange / 3600)
            
            var text = ""
            var icon = "clock"
            var color: Color = .secondary
            var fill = 0.0
            
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
            
            if status.isOpen {
                // OPEN
                color = minutes < 60 ? .orange : .green
                icon = minutes < 60 ? "clock" : "checkmark"
                
                if minutes >= 60 {
                    text = NSLocalizedString("opening-status.open", comment: "")
                } else if minutes <= 0 {
                    text = NSLocalizedString("opening-status.closes-now", comment: "")
                } else {
                    text = String(format: NSLocalizedString("opening-status.closes-in-minutes", comment: ""), minutes)
                }
                
                fill = status.progress
                
            } else {
                // CLOSED
                color = minutes < 60 ? .green : .secondary // Green if opening soon
                icon = "clock"
                
                if hours >= 24 {
                     text = NSLocalizedString("opening-status.closed", comment: "")
                } else if minutes <= 0 {
                    text = NSLocalizedString("opening-status.opens-now", comment: "")
                } else if minutes < 60 {
                    text = String(format: NSLocalizedString("opening-status.opens-in-minutes", comment: ""), minutes)
                } else {
                    text = String(format: NSLocalizedString("opening-status.opens-in-hours", comment: ""), hours)
                }
                fill = 0.0
            }
            
            return StatusDisplay(
                id: status.id,
                text: text,
                subtext: areaName,
                icon: icon,
                color: color,
                fillPercentage: fill
            )
        }
    }
}
