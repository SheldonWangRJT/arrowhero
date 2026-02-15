import SwiftUI

struct UpgradeChoiceView: View {
    @EnvironmentObject var run: GameRunState

    private var isPresenting: Bool { !run.levelSystem.pendingChoices.isEmpty }

    var body: some View {
        Group {
            if isPresenting {
                ZStack {
                    // Dimmed backdrop — game visible underneath
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { } // Swallow taps so only cards are tappable

                    // Compact overlay: title + horizontal cards
                    VStack(spacing: 12) {
                        Text("Level \(run.levelSystem.level)!")
                            .font(.headline)
                            .foregroundStyle(.white)

                        HStack(spacing: 12) {
                            ForEach(run.levelSystem.pendingChoices.prefix(3), id: \.id) { upgrade in
                                UpgradeCard(upgrade: upgrade) {
                                    AudioManager.play(.levelUp)
                                    run.chooseUpgrade(upgrade)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 24)
                    .frame(maxWidth: 400)
                }
            }
        }
        .onChange(of: isPresenting) { _, presenting in
            run.isPaused = presenting
        }
    }
}

private struct UpgradeCard: View {
    let upgrade: Upgrade
    let onSelect: () -> Void

    private let cardWidth: CGFloat = 100
    private let cardHeight: CGFloat = 108

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                if let icon = PixelAssets.upgradeIcon(for: upgrade.id) {
                    Image(uiImage: icon)
                        .interpolation(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                }
                Text(upgrade.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text(upgrade.description)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: cardWidth, height: cardHeight)
            .padding(8)
            .background(Color(.systemBackground).opacity(0.9), in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let run = GameRunState()
    run.levelSystem.pendingChoices = defaultUpgrades().shuffled().prefix(3).map { $0 }
    return UpgradeChoiceView().environmentObject(run)
}
