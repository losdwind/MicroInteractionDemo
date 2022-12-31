//
//  AppStoreAnimation.swift
//
//  Created by Losd wind on 2022/12/29.
//

import Foundation

import SwiftUI
import UIKit

struct AppStoreAnimationView: View {
    // MARK: Animation Properties

    @State var currentItem: HeroCard?
    @State var showDetailPage: Bool = false

    // Matched Geometry Effect
    @Namespace var animation

    // MARK: Detail Animation Properties

    @State var animateView: Bool = false
    @State var animateContent: Bool = false
    @State var scrollOffset: CGFloat = 0

    @State var scale: CGFloat = 1

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(cards) { card in
                    Button {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            currentItem = card
                            showDetailPage = true
                        }
                    } label: {
                        CardView(item: card)
                            // For Matched Geometry Effect We Didnt applied Padding
                            // Instead Applying Scaling
                            // Approx Scaling Value to match padding
                            .scaleEffect(currentItem?.id == card.id && showDetailPage ? 1 : 0.93)
                    }
                    .buttonStyle(ScaledButtonStyle())
                    .opacity(showDetailPage ? (currentItem?.id == card.id ? 1 : 0) : 1)
                    .zIndex(currentItem?.id == card.id && showDetailPage ? 10 : 0)
                }
            }
            .padding(.vertical)
        }
        .overlay {
            if let currentItem = currentItem, showDetailPage {
                DetailView(item: currentItem)
                    .ignoresSafeArea(.container, edges: .top)
//                        .scaleEffect(scale)
            }
        }
        .background(alignment: .top) {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.black)
                .frame(height: animateView ? nil : 350, alignment: .top)
                .scaleEffect(animateView ? 1 : 0.93)
                .opacity(animateView ? 1 : 0)
                .ignoresSafeArea()
        }
    }

    // MARK: CardView

    @ViewBuilder
    func CardView(item: HeroCard)->some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack(alignment: .topLeading) {
                // Banner Image
                GeometryReader { proxy in
                    let size = proxy.size

                    Image(item.artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 400)

                LinearGradient(colors: [
                    .black.opacity(0.5),
                    .black.opacity(0.2),
                    .clear
                ], startPoint: .top, endPoint: .bottom)

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.platformTitle.uppercased())
                        .foregroundColor(.white)
                        .font(.callout)
                        .fontWeight(.semibold)

                    Text(item.bannerTitle)
                        .foregroundColor(.white)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.leading)
                }
                .foregroundColor(.primary)
                .padding()
                .offset(y: currentItem?.id == item.id && animateView ? safeArea().top : 0)
            }
            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 15))

            HStack(spacing: 12) {
                Image(item.appLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.platformTitle.uppercased())
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text(item.appName)
                        .foregroundColor(.white)
                        .fontWeight(.bold)

                    Text(item.appDescription)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button {} label: {
                    Text("GET")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background {
                            Capsule()
                                .fill(.ultraThinMaterial)
                        }
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background(Color.black, in:
            RoundedRectangle(cornerRadius: 15, style: .continuous))
        .matchedGeometryEffect(id: item.id, in: animation)
    }

    // MARK: Detail View

    @ViewBuilder
    func DetailView(item: HeroCard)->some View {
        let drag = DragGesture(minimumDistance: 0)
            .onChanged { value in
                // calculating scale value by total height...

                let scale = value.translation.height / UIScreen.main.bounds.height

                // if scale is 0.1 means the actual scale will be 1- 0.1 => 0.9
                // limiting scale value...

                if 1 - scale > 0.75 {
                    self.scale = 1 - scale
                }
            }
            .onEnded { _ in

                // closing detail view when scale is less than 0.9...
                if scale < 0.9 {
                    // Closing View

                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                        animateView = false
                        animateContent = false
                    }

                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)) {
                        currentItem = nil
                        showDetailPage = false
                    }
                }
                scale = 1
            }

        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                CardView(item: item)
                    .scaleEffect(animateView ? 1 : 0.93)
//                    .animation(.interactiveSpring())
                    .gesture(drag)

                VStack(spacing: 15) {
                    Text(dummyText)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10)
                        .padding(.bottom, 20)

                    Divider()

                    Button {} label: {
                        Label {
                            Text("Share Story")
                        } icon: {
                            Image(systemName: "square.and.arrow.up.fill")
                        }
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(.ultraThinMaterial)
                        }
                    }
                }
                .padding()
                .offset(y: scrollOffset > 0 ? scrollOffset : 0)
                .opacity(animateContent ? 1 : 0)
                .scaleEffect(animateView ? 1 : 0, anchor: .top)
            }
            .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
            .offset(offset: $scrollOffset)
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .topTrailing, content: {
            Button {
                // Closing View
                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    animateView = false
                    animateContent = false
                }

                withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)) {
                    currentItem = nil
                    showDetailPage = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding()
            .padding(.top, safeArea().top)
            .offset(y: -10)
            .opacity(animateView ? 1 : 0)
        })
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                animateView = true
            }
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)) {
                animateContent = true
            }
        }
        .transition(.identity)
    }
}

struct AppStoreAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AppStoreAnimationView()
            .preferredColorScheme(.dark)
    }
}

// MARK: ScaledButton Style

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration)->some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

// Safe Area Value
extension View {
    func safeArea()->UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }

        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }

        return safeArea
    }

    // MARK: ScrollView Offset

    func offset(offset: Binding<CGFloat>)->some View {
        return overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .named("SCROLL")).minY

                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
            }
            .onPreferenceChange(OffsetKey.self) { value in
                offset.wrappedValue = value
            }
        }
    }
}

// MARK: Offset Key

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: ()->CGFloat) {
        value = nextValue()
    }
}
