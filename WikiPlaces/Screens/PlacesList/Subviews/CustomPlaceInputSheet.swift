import SwiftUI

struct CustomPlaceInputSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var errorMessage = ""

    let coordinateValidator: CoordinateValidatorType
    let onSubmit: (String, Double, Double) -> Void

    var body: some View {
        NavigationStack {
            Form {
                errorView

                TextField("Place name", text: $name)
                    .textInputAutocapitalization(.words)
                    .accessibilityLabel("Place name")
                    .accessibilityHint("Enter a descriptive name for the place")

                TextField("Latitude", text: $latitude)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityLabel("Latitude")
                    .accessibilityValue(latitude)
                    .accessibilityHint("Enter a value between negative ninety and ninety")

                TextField("Longitude", text: $longitude)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityLabel("Longitude")
                    .accessibilityValue(longitude)
                    .accessibilityHint("Enter a value between negative one eighty and one eighty")
            }
            .navigationTitle("Enter custom place")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityLabel("Cancel and close")
                        .accessibilityHint("Dismisses the input sheet without saving")
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        validateInput()
                    }
                    .disabled(latitude.isEmpty || longitude.isEmpty)
                    .accessibilityLabel("Save as a custom place")
                    .accessibilityHint("Validates the input and closes the sheet on success")
                }
            }
        }
    }

    @ViewBuilder
    private var errorView: some View {
        if !errorMessage.isEmpty {
            Text(errorMessage)
                .frame(maxWidth: .infinity)
                .font(.body)
                .lineSpacing(8)
                .foregroundColor(.red)
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red, lineWidth: 1)
                )
                .accessibilityLabel("Error: \(errorMessage.replacingOccurrences(of: "\n\n", with: ", "))")
                .accessibilityAddTraits(.isStaticText)
                .accessibilitySortPriority(1) // read before the input fields
        }
    }

    private func validateInput() {
        var errorMessages: [String] = []

        let passedLatitude = coordinateValidator.isValidLatitude(latitude)
        let passedLongitude = coordinateValidator.isValidLongitude(longitude)

        if !passedLatitude.isValid {
            errorMessages.append("Invalid latitude. Use a value between minus ninety and ninety.")
        }

        if !passedLongitude.isValid {
            errorMessages.append("Invalid longitude. Use a value between minus one eighty and one eighty.")
        }

        if errorMessages.isEmpty {
            onSubmit(name, passedLatitude.doubleValue, passedLongitude.doubleValue)
            dismiss()
        } else {
            errorMessage = errorMessages.joined(separator: "\n\n")
        }
    }
}
