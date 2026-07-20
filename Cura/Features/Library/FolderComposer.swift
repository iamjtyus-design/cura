import SwiftUI

public struct FolderComposer: View {
    @ObservedObject public var model: PhaseOneViewModel

    public init(model: PhaseOneViewModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Folders")
                .font(.headline)
            HStack {
                TextField("New folder", text: $model.newFolderName)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("New folder name")
                Button("Add") {
                    Task { await model.addFolder() }
                }
                .disabled(model.newFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .accessibilityLabel("Add Folder")
            }
            if !model.folders.isEmpty {
                Text(model.folders.map(\.name).joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel("Folders: \(model.folders.map(\.name).joined(separator: ", "))")
            }
        }
    }
}
