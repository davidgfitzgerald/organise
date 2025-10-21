import SwiftUI

// Minimal Reproducible Example of Infinite Scrolling Technique
// Demonstrates: View Recycling + Recentering

struct InfiniteScrollMRE: View {
    var body: some View {
        NavigationStack {
            SimpleInfiniteScroll()
                .navigationTitle("Infinite Scroll MRE")
        }
    }
}

struct SimpleInfiniteScroll: UIViewRepresentable {
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = CustomInfiniteScrollView()
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
}

// The core infinite scroll implementation
class CustomInfiniteScrollView: UIScrollView, UIScrollViewDelegate {
    // STEP 1: Limited view pool (only keep visible views)
    private var visibleViews: [(view: UIView, index: Int)] = []
    
    // STEP 2: Track current center index
    private var centerIndex = 0
    
    // STEP 3: View sizing
    private let itemHeight: CGFloat = 80
    private let itemSpacing: CGFloat = 8
    
    // Track if we've initialized
    private var isInitialized = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.showsVerticalScrollIndicator = true
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Initialize on first layout when we have real bounds
        if !isInitialized && bounds.width > 0 && bounds.height > 0 {
            isInitialized = true
            
            // Make content large for recentering trick
            self.contentSize = CGSize(width: bounds.width, height: bounds.height * 3)
            
            // Start centered
            let centerY = (contentSize.height - bounds.height) / 2
            self.contentOffset = CGPoint(x: 0, y: centerY)
            
            print("📱 Initialized with bounds: \(bounds), contentSize: \(contentSize)")
        }
        
        layoutViews()
    }
    
    private func layoutViews() {
        // Don't layout until we have proper bounds
        guard bounds.width > 0, bounds.height > 0 else { return }
        
        let visibleBounds = self.bounds
        let minY = visibleBounds.minY
        let maxY = visibleBounds.maxY
        
        // STEP 7: Add views above if needed
        if let firstView = visibleViews.first {
            var topEdge = firstView.view.frame.minY
            while topEdge > minY - itemHeight {
                let newIndex = firstView.index - 1
                let newView = createView(for: newIndex)
                topEdge -= (itemHeight + itemSpacing)
                newView.frame = CGRect(x: 20, y: topEdge, width: bounds.width - 40, height: itemHeight)
                addSubview(newView)
                visibleViews.insert((newView, newIndex), at: 0)
            }
        } else {
            // No views yet - create first one centered in visible area
            let startY = minY + 20
            let newView = createView(for: centerIndex)
            newView.frame = CGRect(x: 20, y: startY, width: bounds.width - 40, height: itemHeight)
            addSubview(newView)
            visibleViews.append((newView, centerIndex))
        }
        
        // STEP 8: Add views below if needed
        if let lastView = visibleViews.last {
            var bottomEdge = lastView.view.frame.maxY + itemSpacing
            while bottomEdge < maxY + itemHeight {
                let newIndex = visibleViews.last!.index + 1  // Always get the latest index
                let newView = createView(for: newIndex)
                newView.frame = CGRect(x: 20, y: bottomEdge, width: bounds.width - 40, height: itemHeight)
                addSubview(newView)
                visibleViews.append((newView, newIndex))
                bottomEdge = newView.frame.maxY + itemSpacing
            }
        }
        
        // STEP 9: Remove views that scrolled off screen
        visibleViews.removeAll { item in
            if item.view.frame.maxY < minY - itemHeight || item.view.frame.minY > maxY + itemHeight {
                item.view.removeFromSuperview()
                return true
            }
            return false
        }
        
        // STEP 10: THE RECENTERING TRICK
        // If scrolled too far from center, snap back to center
        let currentOffset = contentOffset.y
        let centerOffsetY = (contentSize.height - bounds.height) / 2
        let distanceFromCenter = abs(currentOffset - centerOffsetY)
        
        if distanceFromCenter > contentSize.height / 6 {
            print("🔄 RECENTERING from offset \(Int(currentOffset)) to \(Int(centerOffsetY))")
            
            // Move scroll position
            let adjustment = centerOffsetY - currentOffset
            contentOffset.y = centerOffsetY
            
            // Move all views by same amount so they appear stationary
            for item in visibleViews {
                var frame = item.view.frame
                frame.origin.y += adjustment
                item.view.frame = frame
            }
        }
    }
    
    // STEP 11: Create a view for a given index
    private func createView(for index: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = "Item \(index)"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = index == 0 ? .systemBlue : .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let sublabel = UILabel()
        sublabel.text = "Index: \(index)"
        sublabel.font = .systemFont(ofSize: 14)
        sublabel.textColor = .secondaryLabel
        sublabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        container.addSubview(sublabel)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -8),
            sublabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            sublabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4)
        ])
        
        print("✅ Created view for index \(index)")
        return container
    }
}

#Preview {
    InfiniteScrollMRE()
}
