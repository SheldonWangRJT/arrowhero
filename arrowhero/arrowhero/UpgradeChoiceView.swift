import SwiftUI

struct UpgradeChoiceView: View {
    @EnvironmentObject var run: GameRunState

    var body: some View {
        Color.clear
            .fullScreenCover(isPresented: .constant(!run.levelSystem.pendingChoices.isEmpty), onDismiss: nil) {
                VStack(spacing: 16) {
                    Text("Level \(run.levelSystem.level)!")
                        .font(.title)
                    Text("Choose an upgrade")
                        .font(.headline)

                    ForEach(run.levelSystem.pendingChoices.prefix(3), id: \.id) { upgrade in
                        Button {
                            run.chooseUpgrade(upgrade)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(upgrade.name).font(.headline)
                                Text(upgrade.description).font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 500)
                .background(Color.black.opacity(0.5).ignoresSafeArea())
            }
    }
}

#Preview {
    let run = GameRunState()
    run.levelSystem.pendingChoices = defaultUpgrades().shuffled().prefix(3).map { $0 }
    return UpgradeChoiceView().environmentObject(run)
}
