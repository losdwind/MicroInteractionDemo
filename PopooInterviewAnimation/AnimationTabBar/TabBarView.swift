//
//  TabBarView.swift
//  popoo-ios-animation
//
//  Created by Losd wind on 2022/12/29.
//

import SwiftUI

struct TabBarView: View {
    @State var isHidding: Bool = false
    @State var isShrinking: Bool = false
    @State var progress: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 32){
            ZStack {
                HStack(alignment: .center, spacing: 36) {
                        Image("home")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                            .frame(width: 36)
                            .opacity(isHidding ? 0 : 1)


                        Image("hash_tag")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                            .frame(width: 36)
                            .opacity(isHidding ? 0 : 1)


                        Spacer()

                        Image("check_list")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                            .frame(width: 36)
                            .opacity(isHidding ? 0 : 1)

                        Image("person_pin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                            .frame(width: 36)
                            .opacity(isHidding ? 0 : 1)


                }
                .frame(maxWidth: isShrinking ? 0: .infinity)
                .padding(.vertical, 4)
                .padding(.horizontal, 16)
                .cornerRadius(8)
                .background(.white, in: Capsule())


                ZStack {
                    Image("bitcoin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .foregroundColor(.pink)
                        .background(.white, in: Circle())
                        .frame(width: 60)

                    Circle()
                        .trim(from: 0.0, to: progress ? 1.0 : 0.02)
                        .stroke(lineWidth: 2)
                        .rotation(.degrees(270))
                        .foregroundColor(.pink)
                        .frame(width: 48)
                }
            }

            Button {
                withAnimation(Animation.linear(duration: 0.25)) {
                    isHidding.toggle()
                }
                withAnimation(Animation.easeOut(duration: 1)) {
                    isShrinking.toggle()
                }
                withAnimation(Animation.easeInOut(duration: 2).delay(0.25)) {
                    progress.toggle()
                }
            } label: {
                Text(isHidding ? "Reveal" : "Hide")
            }
            .buttonStyle(.bordered)

        }
        .padding(16)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.2))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
