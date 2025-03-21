//
//  ControlsView.swift
//  WhisperCaptionPro
//
//  Created by 조형구 on 3/21/25.
//

import SwiftUI

struct ControlsView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack {
            BasicSettingsView(viewModel: viewModel)

            if let selectedCategoryId = viewModel.selectedCategoryId,
               let item = viewModel.menu.first(where: { $0.id == selectedCategoryId }) {
                switch item.name {
                case "Transcribe":
                    VStack {
                        HStack {
                            Button {
                                viewModel.resetState()
                            } label: {
                                Label("Reset", systemImage: "arrow.clockwise")
                            }
                            .buttonStyle(BorderlessButtonStyle())

                            Spacer()

                            AudioDevicesView(viewModel: viewModel)

                            Spacer()

                            Button {
                                viewModel.showAdvancedOptions.toggle()
                            } label: {
                                Label("Settings", systemImage: "slider.horizontal.3")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }

                        HStack {
                            let color: Color = viewModel.modelState != .loaded ? .gray : .red
                            Button {
                                withAnimation {
                                    viewModel.selectFile()
                                }
                            } label: {
                                Text("FROM FILE")
                                    .font(.headline)
                                    .foregroundColor(color)
                                    .padding()
                                    .cornerRadius(40)
                                    .frame(minWidth: 70, minHeight: 70)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(color, lineWidth: 4)
                                    )
                            }
                            .fileImporter(
                                isPresented: $viewModel.isFilePickerPresented,
                                allowedContentTypes: [.audio],
                                allowsMultipleSelection: false,
                                onCompletion: viewModel.handleFilePicker
                            )
                            .lineLimit(1)
                            .contentTransition(.symbolEffect(.replace))
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(viewModel.modelState != .loaded)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()

                            ZStack {
                                Button {
                                    withAnimation {
                                        viewModel.toggleRecording(shouldLoop: false)
                                    }
                                } label: {
                                    if !viewModel.isRecording {
                                        Text("RECORD")
                                            .font(.headline)
                                            .foregroundColor(color)
                                            .padding()
                                            .cornerRadius(40)
                                            .frame(minWidth: 70, minHeight: 70)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 40)
                                                    .stroke(color, lineWidth: 4)
                                            )
                                    } else {
                                        Image(systemName: "stop.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 70, height: 70)
                                            .padding()
                                            .foregroundColor(viewModel
                                                .modelState != .loaded ? .gray : .red)
                                    }
                                }
                                .lineLimit(1)
                                .contentTransition(.symbolEffect(.replace))
                                .buttonStyle(BorderlessButtonStyle())
                                .disabled(viewModel.modelState != .loaded)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()

                                if viewModel.isRecording {
                                    Text("\(String(format: "%.1f", viewModel.bufferSeconds)) s")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .offset(x: 80, y: 0)
                                }
                            }
                        }
                    }
                case "Stream":
                    VStack {
                        HStack {
                            Button {
                                viewModel.resetState()
                            } label: {
                                Label("Reset", systemImage: "arrow.clockwise")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .buttonStyle(BorderlessButtonStyle())

                            Spacer()

                            AudioDevicesView(viewModel: viewModel)

                            Spacer()

                            VStack {
                                Button {
                                    viewModel.showAdvancedOptions.toggle()
                                } label: {
                                    Label("Settings", systemImage: "slider.horizontal.3")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }

                        ZStack {
                            Button {
                                withAnimation {
                                    viewModel.toggleRecording(shouldLoop: true)
                                }
                            } label: {
                                Image(systemName: !viewModel
                                    .isRecording ? "record.circle" : "stop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .padding()
                                    .foregroundColor(viewModel.modelState != .loaded ? .gray : .red)
                            }
                            .contentTransition(.symbolEffect(.replace))
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(viewModel.modelState != .loaded)
                            .frame(minWidth: 0, maxWidth: .infinity)

                            VStack {
                                Text("Encoder runs: \(viewModel.currentEncodingLoops)")
                                    .font(.caption)
                                Text("Decoder runs: \(viewModel.currentDecodingLoops)")
                                    .font(.caption)
                            }
                            .offset(x: -120, y: 0)

                            if viewModel.isRecording {
                                Text("\(String(format: "%.1f", viewModel.bufferSeconds)) s")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .offset(x: 80, y: 0)
                            }
                        }
                    }
                default:
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.showAdvancedOptions) {
            SettingsView(viewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled)
                .presentationContentInteraction(.scrolls)
        }
    }
}

#Preview {
    ControlsView(viewModel: ContentViewModel())
}
