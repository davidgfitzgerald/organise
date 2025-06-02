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
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Icon Exporter")
                .font(.title)
                .fontWeight(.bold)
            
            // Preview of the icons
            IconsPreview(lightMode: .constant(true))
            
            Button("Export All Icon Sizes") {
                exportAllSizes()
            }
            .buttonStyle(.borderedProminent)
            .font(.headline)
            
            if !exportStatus.isEmpty {
                Text(exportStatus)
                    .foregroundColor(exportStatus.contains("❌") ? .red : .green)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            Text("Icons will be saved to Documents folder")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    func exportAllSizes() {
        exportStatus = "Exporting..."
        var successCount = 0
        
        for iconSize in iconSizes {
            if exportIcon(size: iconSize.size, filename: iconSize.name) {
                successCount += 1
            }
        }
        
        if successCount == iconSizes.count {
            exportStatus = "✅ All \(iconSizes.count) icon sizes exported to Documents/AppIcons/"
        } else {
            exportStatus = "⚠️ Exported \(successCount)/\(iconSizes.count) icons. Check console for errors."
        }
    }
    
    func exportIcon(size: CGFloat, filename: String) -> Bool {
        // Create the icon view that fills the entire frame
        let iconView = CheckmarkIcon()
            .frame(width: size, height: size)
            .scaleEffect(1.0) // Ensure it fills the frame
            .background(Color.clear)
        
        let renderer = ImageRenderer(content: iconView)
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
        
        // Create AppIcons subfolder
        let appIconsFolder = documentsPath.appendingPathComponent("AppIcons")
        
        do {
            try FileManager.default.createDirectory(at: appIconsFolder,
                                                   withIntermediateDirectories: true,
                                                   attributes: nil)
        } catch {
            print("❌ Could not create AppIcons folder: \(error)")
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
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Icon Exporter (macOS)")
                .font(.title)
                .fontWeight(.bold)
            
            CheckmarkIcon()
                .frame(width: 100, height: 100)
            
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
        var successCount = 0
        
        // Get Desktop directory
        guard let desktopPath = FileManager.default.urls(for: .desktopDirectory,
                                                         in: .userDomainMask).first else {
            exportStatus = "❌ Could not access Desktop directory"
            return
        }
        
        // Create AppIcons folder on Desktop
        let appIconsFolder = desktopPath.appendingPathComponent("AppIcons")
        
        do {
            try FileManager.default.createDirectory(at: appIconsFolder,
                                                   withIntermediateDirectories: true,
                                                   attributes: nil)
        } catch {
            exportStatus = "❌ Could not create AppIcons folder: \(error.localizedDescription)"
            return
        }
        
        for iconSize in iconSizes {
            if exportIconMac(size: iconSize.size, filename: iconSize.name, to: appIconsFolder) {
                successCount += 1
            }
        }
        
        if successCount == iconSizes.count {
            exportStatus = "✅ All \(iconSizes.count) icons exported to Desktop/AppIcons/"
        } else {
            exportStatus = "⚠️ Exported \(successCount)/\(iconSizes.count) icons"
        }
    }
    
    func exportIconMac(size: CGFloat, filename: String, to folder: URL) -> Bool {
        let iconView = CheckmarkIcon()
            .frame(width: size, height: size)
            .background(Color.clear)
        
        let renderer = ImageRenderer(content: iconView)
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
