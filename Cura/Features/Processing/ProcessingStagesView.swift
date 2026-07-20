import SwiftUI

public struct ProcessingStagesView: View {
    @ObservedObject public var model: PhaseOneViewModel

    public init(model: PhaseOneViewModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Processing")
                .font(.headline)
            ForEach(PhaseOneProcessingStage.allCases) { stage in
                HStack {
                    Image(systemName: model.completedStages.contains(stage) ? "checkmark.circle.fill" : "circle")
                    Text(stage.title)
                    Spacer()
                    if model.activeStage == stage {
                        ProgressView()
                            .accessibilityLabel("\(stage.title) in progress")
                    }
                }
                .accessibilityIdentifier("stage-\(stage.rawValue)")
            }
        }
        .padding()
        .background(PhaseOneSurface.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
