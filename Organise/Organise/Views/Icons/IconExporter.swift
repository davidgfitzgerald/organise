import SwiftUI
import UIKit

struct IconExporter: View {
    @State private var exportStatus = ""
    
    let iconSizes: [(size: CGFloat, name: String)] = [
        (1024, "icon-1024"),     // App Store
        (180, "icon-180"),       // iPhone (3x)
        (120, "icon-120"),       // iPhone (2x)
        (167, "icon-167"),       // iPad Pro
        (152, "icon-152"),       // iPad (2x)
        (76, "icon-76")          // iPad (1x)
    ]
    
    let iconTypes: [(view: AnyView, name: String)] = [
        (AnyView(CheckmarkIcon()), "checkmark"),
        (AnyView(ProgressIcon()), "progress"),
        (AnyView(StreakIcon()), "streak"),
        (AnyView(TargetIcon()), "target")
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Icon Exporter")
                .font(.title)
                .fontWeight(.bold)
            
            // Preview of all icons
            HStack(spacing: 20) {
                CheckmarkIcon()
                    .frame(width: 60, height: 60)
                ProgressIcon()
                    .frame(width: 60, height: 60)
                StreakIcon()
                    .frame(width: 60, height: 60)
                TargetIcon()
                    .frame(width: 60, height: 60)
            }
            
            Button("Export All Icons & Sizes") {
                exportAllIconsAndSizes()
            }
            .buttonStyle(.borderedProminent)
            .font(.headline)
            
            if !exportStatus.isEmpty {
                Text(exportStatus)
                    .foregroundColor(exportStatus.contains("❌") ? .red : .green)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            Text("Icons will be saved to Documents/AppIcons/[icon-name]/")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    func exportAllIconsAndSizes() {
        exportStatus = "Exporting..."
        var totalSuccessCount = 0
        let totalExpected = iconTypes.count * iconSizes.count
        
        for iconType in iconTypes {
            for iconSize in iconSizes {
                let filename = "\(iconType.name)-\(iconSize.name)"
                if exportIcon(iconView: iconType.view, size: iconSize.size, filename: filename, folderName: iconType.name) {
                    totalSuccessCount += 1
                }
            }
        }
        
        if totalSuccessCount == totalExpected {
            exportStatus = "✅ All \(totalExpected) icons exported successfully!\n(\(iconTypes.count) icon types × \(iconSizes.count) sizes)"
        } else {
            exportStatus = "⚠️ Exported \(totalSuccessCount)/\(totalExpected) icons. Check console for errors."
        }
    }
    
    func exportIcon(iconView: AnyView, size: CGFloat, filename: String, folderName: String) -> Bool {
        // Create the icon view that fills the entire frame
        let scaledIconView = iconView
            .frame(width: size, height: size)
            .scaleEffect(1.0) // Ensure it fills the frame
            .background(Color.clear)
        
        let renderer = ImageRenderer(content: scaledIconView)
        renderer.scale = 1.0 // Use 1.0 since we're setting exact pixel dimensions
        // Set the proposed size to match our intended output
        renderer.proposedSize = ProposedViewSize(width: size, height: size)
        
        guard let uiImage = renderer.uiImage,
              let pngData = uiImage.pngData() else {
            print("❌ Failed to render \(filename)")
            return false
        }
        
        // Get Documents directory
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory,
                                                           in: .userDomainMask).first else {
            print("❌ Could not access Documents directory")
            return false
        }
        
        // Create AppIcons/[icon-name] subfolder
        let appIconsFolder = documentsPath.appendingPathComponent("AppIcons").appendingPathComponent(folderName)
        
        do {
            try FileManager.default.createDirectory(at: appIconsFolder,
                                                   withIntermediateDirectories: true,
                                                   attributes: nil)
        } catch {
            print("❌ Could not create AppIcons/\(folderName) folder: \(error)")
            return false
        }
        
        // Save the file
        let fileURL = appIconsFolder.appendingPathComponent("\(filename).png")
        
        do {
            try pngData.write(to: fileURL)
            print("✅ Exported \(filename).png at \(size)×\(size)px to: \(fileURL.path)")
            return true
        } catch {
            print("❌ Failed to save \(filename): \(error)")
            return false
        }
    }
}

// MARK: - Alternative: Desktop Export (macOS)
#if os(macOS)
import AppKit

struct IconExporterMac: View {
    @State private var exportStatus = ""
    
    let iconSizes: [(size: CGFloat, name: String)] = [
        (1024, "icon-1024"),
        (180, "icon-180"),
        (120, "icon-120"),
        (167, "icon-167"),
        (152, "icon-152"),
        (76, "icon-76")
    ]
    
    let iconTypes: [(view: AnyView, name: String)] = [
        (AnyView(CheckmarkIcon()), "checkmark"),
        (AnyView(ProgressIcon()), "progress"),
        (AnyView(StreakIcon()), "streak"),
        (AnyView(TargetIcon()), "target")
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Icon Exporter (macOS)")
                .font(.title)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                CheckmarkIcon()
                    .frame(width: 60, height: 60)
                ProgressIcon()
                    .frame(width: 60, height: 60)
                StreakIcon()
                    .frame(width: 60, height: 60)
                TargetIcon()
                    .frame(width: 60, height: 60)
            }
            
            Button("Export to Desktop") {
                exportToDesktop()
            }
            .buttonStyle(.borderedProminent)
            
            if !exportStatus.isEmpty {
                Text(exportStatus)
                    .foregroundColor(exportStatus.contains("❌") ? .red : .green)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
    
    func exportToDesktop() {
        exportStatus = "Exporting..."
        var totalSuccessCount = 0
        let totalExpected = iconTypes.count * iconSizes.count
        
        // Get Desktop directory
        guard let desktopPath = FileManager.default.urls(for: .desktopDirectory,
                                                         in: .userDomainMask).first else {
            exportStatus = "❌ Could not access Desktop directory"
            return
        }
        
        for iconType in iconTypes {
            // Create AppIcons/[icon-name] folder on Desktop
            let appIconsFolder = desktopPath.appendingPathComponent("AppIcons").appendingPathComponent(iconType.name)
            
            do {
                try FileManager.default.createDirectory(at: appIconsFolder,
                                                       withIntermediateDirectories: true,
                                                       attributes: nil)
            } catch {
                exportStatus = "❌ Could not create AppIcons/\(iconType.name) folder: \(error.localizedDescription)"
                return
            }
            
            for iconSize in iconSizes {
                let filename = "\(iconType.name)-\(iconSize.name)"
                if exportIconMac(iconView: iconType.view, size: iconSize.size, filename: filename, to: appIconsFolder) {
                    totalSuccessCount += 1
                }
            }
        }
        
        if totalSuccessCount == totalExpected {
            exportStatus = "✅ All \(totalExpected) icons exported to Desktop/AppIcons/"
        } else {
            exportStatus = "⚠️ Exported \(totalSuccessCount)/\(totalExpected) icons"
        }
    }
    
    func exportIconMac(iconView: AnyView, size: CGFloat, filename: String, to folder: URL) -> Bool {
        let scaledIconView = iconView
            .frame(width: size, height: size)
            .background(Color.clear)
        
        let renderer = ImageRenderer(content: scaledIconView)
        renderer.scale = 1.0
        
        guard let nsImage = renderer.nsImage else {
            print("❌ Failed to render \(filename)")
            return false
        }
        
        // Convert to PNG data
        guard let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            print("❌ Failed to convert \(filename) to PNG")
            return false
        }
        
        // Save file
        let fileURL = folder.appendingPathComponent("\(filename).png")
        
        do {
            try pngData.write(to: fileURL)
            print("✅ Exported \(filename).png to: \(fileURL.path)")
            return true
        } catch {
            print("❌ Failed to save \(filename): \(error)")
            return false
        }
    }
}
#endif

#Preview("Exporter") {
    IconExporter()
}
