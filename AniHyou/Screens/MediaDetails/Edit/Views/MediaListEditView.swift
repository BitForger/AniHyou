//
//  MediaListEditView.swift
//  AniHyou
//
//  Created by Axel Lopez on 20/6/22.
//

import SwiftUI
import AniListAPI

struct MediaListEditView: View {
    @Environment(\.dismiss) private var dismiss

    let mediaDetails: BasicMediaDetails
    var mediaList: BasicMediaListEntry?
    var onSave: (_ updatedEntry: BasicMediaListEntry) -> Void = { _ in }
    var onDelete: () -> Void = {}

    @StateObject private var viewModel = MediaListEditViewModel()
    @State private var showDeleteDialog = false
    
    @AppStorage(ADVANCED_SCORING_ENABLED_KEY) private var advancedScoringEnabled: Bool?

    @State private var status: MediaListStatus = .planning
    @State private var progress = 0
    @State private var progressVolumes = 0
    @State private var repeatCount = 0
    @State private var startDate = Date()
    @State private var isStartDateSet = false
    @State private var finishDate = Date()
    @State private var isFinishDateSet = false
    @State private var showStartDate = false
    @State private var showFinishDate = false
    @State private var isPrivate = false
    @State private var notes = ""
    @State private var advancedScores: [String: Double] = [:]

    private let textFieldWidth: CGFloat = 65
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        NavigationStack {
            Form(content: {
                Picker("Status", selection: $status) {
                    ForEach(MediaListStatus.allCases, id: \.self) { status in
                        Label(status.localizedName, systemImage: status.systemImage)
                    }
                }

                Section("Score") {
                    switch viewModel.scoreFormat {
                    case .point5:
                        HStack {
                            Spacer()
                            StarRatingView(rating: $viewModel.score)
                            Spacer()
                        }
                    case .point3:
                        HStack {
                            Spacer()
                            SmileyRatingView(rating: $viewModel.score)
                            Spacer()
                        }
                    default:
                        HStack {
                            TextField("", value: $viewModel.score, formatter: decimalFormatter)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: textFieldWidth)

                            Stepper("/\(viewModel.scoreHint)",
                                    value: $viewModel.score,
                                    in: viewModel.scoreRange,
                                    step: viewModel.scoreStep
                            )
                        }
                    }
                }

                Section("Progress") {
                    HStack {
                        TextField("", value: $progress, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: textFieldWidth)
                            .onChange(of: progress) { value in
                                if let max = mediaDetails.maxProgress, value > max {
                                    progress = max
                                }
                            }
                        Stepper(
                            mediaDetails.type == .anime ? "Episodes" : "Chapters",
                            value: $progress, in: 0...(mediaDetails.maxProgress ?? Int.max)
                        )
                    }
                    if mediaDetails.type == .manga {
                        HStack {
                            TextField("", value: $progressVolumes, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: textFieldWidth)
                                .onChange(of: progressVolumes) { value in
                                    if let max = mediaDetails.volumes, value > max {
                                        progressVolumes = max
                                    }
                                }
                            Stepper("Volumes", value: $progressVolumes, in: 0...(mediaDetails.volumes ?? Int.max))
                        }
                    }
                }

                Section {
                    HStack {
                        TextField("", value: $repeatCount, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: textFieldWidth)
                        Stepper("Repeat Count", value: $repeatCount, in: 0...Int.max)
                    }
                }

                Section("Dates") {
                    DatePickerToggleView(text: "Start Date", selection: $startDate, isDateSet: $isStartDateSet)
                    DatePickerToggleView(text: "Finish Date", selection: $finishDate, isDateSet: $isFinishDateSet)
                }

                Section {
                    Toggle("Private", isOn: $isPrivate)
                }

                Section {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(5)
                }
                
                if advancedScoringEnabled == true {
                    advancedScoresView
                }

                Button("Delete", role: .destructive) {
                    showDeleteDialog = true
                }
                .confirmationDialog("Delete this entry?", isPresented: $showDeleteDialog) {
                    Button("Delete", role: .destructive) {
                        viewModel.deleteEntry(entryId: mediaList!.id)
                    }
                } message: {
                    Text("Delete this entry?")
                }
                .disabled(mediaList == nil)

            })//:Form
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Save") {
                            viewModel.updateEntry(
                                mediaId: mediaDetails.id,
                                status: status,
                                score: viewModel.score,
                                advancedScoresDict: advancedScores,
                                progress: progress,
                                progressVolumes: progressVolumes,
                                startedAt: isStartDateSet ? startDate : nil,
                                completedAt: isFinishDateSet ? finishDate : nil,
                                repeatCount: repeatCount,
                                isPrivate: isPrivate,
                                notes: notes
                            )
                        }
                        .font(.bold(.body)())
                    }
                }
            }//:Toolbar
        }//:NavigationStack
        .onAppear {
            setValues()
        }
        .onChange(of: viewModel.isUpdateSuccess) { isUpdateSuccess in
            if isUpdateSuccess, let entry = viewModel.updatedEntry {
                onSave(entry)
                dismiss()
            }
        }
        .onChange(of: viewModel.isDeleteSuccess) { isDeleteSuccess in
            if isDeleteSuccess {
                onDelete()
                dismiss()
            }
        }
    }
    
    @ViewBuilder
    private var advancedScoresView: some View {
        ForEach(advancedScores.keys.sorted(), id: \.self) { name in
            Section {
                let value = Binding(
                    get: { advancedScores[name] ?? 0 },
                    set: { advancedScores[name] = $0 }
                )
                
                HStack {
                    TextField("", value: value, formatter: decimalFormatter)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: textFieldWidth)
                    
                    Stepper("/\(viewModel.scoreHint)",
                            value: value,
                            in: viewModel.scoreRange,
                            step: viewModel.scoreStep
                    )
                }
            } header: {
                Text(name)
            }
        }
    }

    private func setValues() {
        viewModel.oldEntry = self.mediaList
        self.status = self.mediaList?.status?.value ?? .planning
        self.progress = self.mediaList?.progress ?? 0
        self.progressVolumes = self.mediaList?.progressVolumes ?? 0
        self.repeatCount = self.mediaList?.repeat ?? 0
        viewModel.score = self.mediaList?.score ?? 0
        if let startedYear = self.mediaList?.startedAt?.year {
            if let startedMonth = self.mediaList?.startedAt?.month {
                if let startedDay = self.mediaList?.startedAt?.day {
                    if let startDate = date(year: startedYear, month: startedMonth, day: startedDay) {
                        self.startDate = startDate
                    }
                }
            }
        }
        self.isStartDateSet = self.mediaList?.startedAt?.year != nil

        if let completedYear = self.mediaList?.completedAt?.year {
            if let completedMonth = self.mediaList?.completedAt?.month {
                if let completedDay = self.mediaList?.completedAt?.day {
                    if let finishDate = date(year: completedYear, month: completedMonth, day: completedDay) {
                        self.finishDate = finishDate
                    }
                }
            }
        }
        self.isFinishDateSet = self.mediaList?.completedAt?.year != nil

        self.isPrivate = self.mediaList?.private ?? false
        self.notes = self.mediaList?.notes ?? ""
        self.advancedScores = self.mediaList?.advancedScoresDict ?? [:]
    }
}

#Preview {
    MediaListEditView(mediaDetails: BasicMediaDetails(_fieldData: nil))
}
