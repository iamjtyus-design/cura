import SwiftUI

public struct FolderComposer: View {
    @ObservedObject public var model: PhaseOneViewModel
    @State private var isComposing = false

    public init(model: PhaseOneViewModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Folders")
                .font(.headline)
            if isComposing {
                TextField("New folder", text: $model.newFolderName)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel("New folder name")
                HStack {
                    Button("Save Folder") {
                        Task {
                            if await model.addFolder() != nil {
                                isComposing = false
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(model.newFolderName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityIdentifier("saveFolderButton")

                    Button("Cancel") {
                        model.newFolderName = ""
                        isComposing = false
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                Button("Add Folder") {
                    isComposing = true
                }
                .buttonStyle(.bordered)
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
