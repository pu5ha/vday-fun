import SwiftUI

struct TemplatePickerView: View {
    let onSelect: (MessageTemplate) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: MessageTemplate.Category = .romantic

    var body: some View {
        ZStack {
            GradientBackground(style: .soft)

            VStack(spacing: 0) {
                // Category pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(MessageTemplate.Category.allCases, id: \.rawValue) { category in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCategory = category
                                }
                            } label: {
                                Text(category.rawValue)
                                    .font(ValentineTheme.captionFont)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(selectedCategory == category
                                                ? AnyShapeStyle(ValentineTheme.buttonGradient)
                                                : AnyShapeStyle(Color.white)
                                            )
                                    )
                                    .foregroundStyle(selectedCategory == category ? .white : ValentineTheme.textPrimary)
                                    .shadow(color: ValentineTheme.softPink.opacity(0.2), radius: 4, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }

                // Templates list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(MessageTemplate.templates(for: selectedCategory)) { template in
                            Button {
                                onSelect(template)
                                dismiss()
                            } label: {
                                HStack(alignment: .top, spacing: 12) {
                                    Text(template.emoji)
                                        .font(.system(size: 28))

                                    Text(template.text)
                                        .font(ValentineTheme.bodyFont)
                                        .foregroundStyle(ValentineTheme.textPrimary)
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(4)

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(ValentineTheme.softPink)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.white)
                                        .shadow(color: ValentineTheme.softPink.opacity(0.15), radius: 6, y: 3)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Get Inspired")
        .navigationBarTitleDisplayMode(.inline)
    }
}
