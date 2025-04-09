//
//  QuestionsVewController.swift
//  BaseApp
//
//  Created by Ihab yasser on 01/11/2024.
//

import Foundation
import UIKit
import SnapKit
import Combine
import AVFoundation
import AVKit


class SurpriseQuestionsVewController: UIViewController, TimerDelegate, SlideButtonDelegate, OTPDidEnteredDelegate {
    
    private let viewModel:SurpriseViewModel = SurpriseViewModel()
    open var cancellables: Set<AnyCancellable>  = Set<AnyCancellable>()
    private let timer:TimerManager = TimerManager()
    private var result: AnswerResult = .none
    private var time:Int = 300 {
        didSet {
            timer.start(with: time)
        }
    }
    private var question: Question?{
        didSet{
            self.hideShowSkipTry()
            self.hideShowLifeLines()
        }
    }
    private let backgroundView:HorizontalGradientView = {
        let view = HorizontalGradientView()
        return view
    }()
    
    private let closeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    
    private let lifeLineView:GameLifeLineView = {
        let view = GameLifeLineView(frame: .zero)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let progressBar:LinearProgressBar = {
        let bar = LinearProgressBar()
        bar.barColor = .secondary
        bar.trackColor = .white.withAlphaComponent(0.1)
        bar.barHeight = 4.0
        bar.cornerRadius = 2.0
        bar.setProgress(0)
        return bar
    }()
    
    
    private let timerView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let timeIcon:UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "time_")
        img.tintColor = .secondary
        return img
    }()
    
    
    private let timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = .accent
        label.font = AppFont.shared.font(family: .Inter, fontWeight: .bold, size: 12)
        return label
    }()
    
    private let slideToSkip:SlideButton = {
        let btn = SlideButton()
        return btn
    }()
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.layer.cornerRadius = 16
        table.register(QuestionTitleHeaderView.self, forHeaderFooterViewReuseIdentifier: QuestionTitleHeaderView.identifier)
        table.register(QuestionFooterView.self, forHeaderFooterViewReuseIdentifier: QuestionFooterView.identifier)
        table.register(AnswerCell.self, forCellReuseIdentifier: AnswerCell.identifier)
        table.register(QRCell.self, forCellReuseIdentifier: QRCell.identifier)
        table.register(CodeCell.self, forCellReuseIdentifier: CodeCell.identifier)
        table.register(VideoCell.self, forCellReuseIdentifier: VideoCell.identifier)
        table.estimatedSectionHeaderHeight = 200
        table.estimatedSectionFooterHeight = 54
        table.estimatedRowHeight = 64
        table.allowsSelection = true
        table.showsVerticalScrollIndicator = false
        table.isUserInteractionEnabled = true
        table.isScrollEnabled = false
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        return table
    }()
    
    
    private let lineLifeView:LifrLineView = {
        let view = LifrLineView()
        return view
    }()

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.timerView.snp.bottom).offset(16)
            make.height.equalTo(self.question == nil ? 0 : self.tableView.contentSize.height)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actions()
        observers()
        setup()
    }
    
    func setup() {
        self.timer.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isUserInteractionEnabled = true
        self.view.addSubview(backgroundView)
        self.slideToSkip.isHidden = true
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [closeBtn, lifeLineView, progressBar, timerView, tableView, lineLifeView, slideToSkip].forEach { view in
            self.backgroundView.addSubview(view)
        }
        
        [timeIcon, timeLabel].forEach { view in
            self.timerView.addSubview(view)
        }
        
        timeIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(6)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.timeIcon.snp.trailing).offset(6)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(64)
            make.width.height.equalTo(24)
        }
        
        lifeLineView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(64)
            make.height.equalTo(24)
            make.width.equalTo(212)
        }
        
        timerView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(72)
            make.height.equalTo(24)
            make.top.equalTo(self.lifeLineView.snp.bottom).offset(16)
        }
        
        progressBar.snp.makeConstraints { make in
            make.centerY.equalTo(self.timerView.snp.centerY)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(self.timerView.snp.leading).offset(-16)
            make.height.equalTo(4)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.timerView.snp.bottom).offset(16)
            make.height.equalTo(0)
        }
        
        lineLifeView.isHidden = true
        lineLifeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(self.tableView.snp.bottom).offset(32)
            make.height.equalTo(82)
        }
        
        slideToSkip.delegate = self
        slideToSkip.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        self.viewModel.getState()
        getQuestion()
    }
    
    
    func observers() {
        self.viewModel.$loading.receive(on: DispatchQueue.main).sink(receiveValue: { isLoading in
            LoadingIndicator.shared.loading(isShow: isLoading)
        }).store(in: &cancellables)
        
        self.viewModel.$state.dropFirst().receive(on: DispatchQueue.main).sink { res in
            guard let res else { return }
            self.lifeLineView.lifes = res.lifes
            self.lifeLineView.skips = res.skips
            self.lifeLineView.completed = res.answered
        }.store(in: &cancellables)
        
        self.viewModel.$error.receive(on: DispatchQueue.main).sink { error in
            guard let _ = error else { return }
            if let error = error as? ErrorResponse{
                switch error {
                case .error( _,  let data, _):
                    if let data = data {
                        let decodedObj =  CodableHelper.decode(SubmitAnswer.self, from: data)
                        if let response = decodedObj.decodableObj, let status = response.status {
                            self.handleStatus(status: status)
                        }
                    }
                }
            }else{
                MainHelper.handleApiError(error)
            }
        }.store(in: &cancellables)
        
        self.viewModel.$question.receive(on: DispatchQueue.main).sink { question in
            guard let question = question else { return }
            self.question = question
            self.tableView.reloadData()
            if let seconds = question.seconds {
                self.time = seconds
            }
        }.store(in: &cancellables)
        
        self.viewModel.$answer.receive(on: DispatchQueue.main).sink { game in
            guard let game = game else { return }
            if let status = game.status, status == .NOGAMESESSIONS || status == .SKIPNOTALLOWED || status == .TIMEEXCEEDED {
                self.handleStatus(status: status)
            }else{
                if game.isEnded == true {
                    if game.isWinner == true {
                        let vc = WinnerGameViewController(closinglocation: game.closinglocation)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if game.reviveavailable == 1 {
                        let vc = GameOverViewController(canRevive: true)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        let vc = GameOverViewController(canRevive: false)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else {
                    self.lifeLineView.lifes = game.lifes
                    self.lifeLineView.skips = game.skips
                    self.lifeLineView.completed = game.answered
                    self.answerResult(result: self.result)
                }
            }
            
        }.store(in: &cancellables)
    }
    
    private func handleStatus(status: SubmitAnswer.Status) {
        switch status {
        case .TIMEEXCEEDED:
            let sessionVc = ExpiredViewController(titleStr: "Time’s Up!".localized, message: "You ran out of time! Keep an eye on the clock and try again for another chance to succeed.".localized) {}
            SheetPresenter.shared.presentSheet(sessionVc, on: self, height: 200, isCancellable: false)
            break
        case .SKIPNOTALLOWED:
            let sessionVc = ExpiredViewController(titleStr: "Skip Not Available".localized, message: "Skipping is not allowed in this stage. Complete the current task to progress further!".localized) {}
            SheetPresenter.shared.presentSheet(sessionVc, on: self, height: 200, isCancellable: false)
            break
        case .NOGAMESESSIONS:
            let sessionVc = ExpiredViewController(titleStr: "No Active Game Sessions".localized, message: "NOGAMESESSIONS".localized) {
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.timer.invalidateTimer()
            SheetPresenter.shared.presentSheet(sessionVc, on: self, height: 200, isCancellable: false)
            break
        case .SUCCESS:
            break
        }

    }
    
    func actions() {
        closeBtn.tap {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        lineLifeView.fiftyBtn.tap = {
            let vc = LifeLineUseViewController(lifeLine: .fiftyFifty)
            vc.isModalInPresentation = true
            vc.callback = {
                DispatchQueue.main.async {
                    var currentQuestion = self.question
                    currentQuestion?.hasfiftyfifty  = (self.question?.hasfiftyfifty ?? 0) - 1
                    currentQuestion?.isUsedFifty = true
                    self.question = currentQuestion
                    self.tableView.reloadData()
                }
            }
            self.present(vc, animated: true)
        }
        
        lineLifeView.vastaBtn.tap = {
            let vc = LifeLineUseViewController(lifeLine: .vasta)
            vc.isModalInPresentation = true
            vc.callback = {
                self.submitAnswer(answer: "", wrong: "0", correct: "1", skip: "0" , wasta: "1", fiftyfifty: "")
            }
            self.present(vc, animated: true)
        }
    }
    
    private func getQuestion() {
        self.viewModel.getQuestion()
    }
    
    private func submitAnswer(answer:String, wrong:String, correct:String, skip:String , wasta:String, fiftyfifty:String) {
        self.result = if (wrong == "1"){
            .wrong
        }else if (correct == "1") || (skip == "1"){
            .correct
        }else{
            .none
        }
        self.viewModel.answerQuestion(answer: answer, questionid: self.question?.questionid ?? "", wrong: wrong, correct: correct, skip: skip , wasta: wasta, fiftyfifty: fiftyfifty)
    }
    
    func runing(time: Int) {
        if time < 0 { return }
        self.timeLabel.text = time.formatSecondsToTimerString()
        let progress = CGFloat(self.time - time) / CGFloat(self.time)
        self.progressBar.setProgress(CGFloat(progress))
    }
    
    
    func finished() {
        self.submitAnswer(answer: "", wrong: "1", correct: "0", skip: "0", wasta: "", fiftyfifty: "")
    }
    
    
    func slideButtonDidSlideComplete(_ button: SlideButton) {
        self.submitAnswer(answer: "", wrong: "0", correct: "0", skip: "1", wasta: "", fiftyfifty: "")
    }
    
    private func hideShowSkipTry(){
        guard let question else { return }
        self.slideToSkip.isHidden = question.hasskip == 0
    }
    
    
    private func hideShowLifeLines(){
        guard let question else { return }
        if let fiftyfiftys = question.hasfiftyfifty {
            self.lineLifeView.isFiftyActive = fiftyfiftys != 0 && question.type() == .Choices
        }
        
        if let vasta = question.haswasta {
            self.lineLifeView.isVastaActive = vasta != 0
        }
        
        if !self.lineLifeView.isFiftyActive && !self.lineLifeView.isVastaActive {
            self.lineLifeView.isHidden = true
        }else{
            self.lineLifeView.isHidden = false
        }
    }
    
    func entered(text: String) {
        let wrong = self.question?.questionAnswer ?? "" == text ? "0" : "1"
        let correct = self.question?.questionAnswer ?? "" == text ? "1" : "0"
        self.submitAnswer(answer: text, wrong: wrong, correct: correct, skip: "0", wasta: "", fiftyfifty: "")
    }
    
    func entering() {}
    
    
    func answerResult(result: AnswerResult){
        let viewController = AnswerResultViewController(result: result)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = viewController
        viewController.callback = {
            self.getQuestion()
        }
        self.present(viewController, animated: true, completion: nil)
    }
}
extension SurpriseQuestionsVewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let question else { return 0 }
        switch question.type() {
        case .Choices:
            return self.question?.getAnswers().count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let question else { return UITableViewCell() }
        switch question.type() {
        case .Video:
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identifier) as! VideoCell
            return cell
        case .QR:
            let cell = tableView.dequeueReusableCell(withIdentifier: QRCell.identifier) as! QRCell
            return cell
        case .Choices:
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerCell.identifier) as! AnswerCell
            cell.answer = question.getAnswers()[safe: indexPath.row]
            return cell
        case .Code:
            let cell = tableView.dequeueReusableCell(withIdentifier: CodeCell.identifier) as! CodeCell
            cell.otpView.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let question else { return nil }
        let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: QuestionTitleHeaderView.identifier) as! QuestionTitleHeaderView
        header.question = question
        return header
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let question = question, let hint = question.questionHint, !hint.isEmpty else { return nil }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: QuestionFooterView.identifier) as! QuestionFooterView
        footer.giveMeHint.tap {
            ConfirmationAlert.show(on: self, title: "Hint".localized, message: hint, icon: UIImage(named: "hint"), positiveButtonTitle: "Got it!".localized , withNigativeButton: false)
        }
        return footer
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        guard let question else { return  }
        switch question.type() {
        case .Video:
            self.openLink()
            break
        case .Choices:
            if let answers = self.question?.getAnswers(), let selectedAnswer = answers[safe: indexPath.row] {
                let wrong = selectedAnswer.isCorrect == true ? "0" : "1"
                let corroct = selectedAnswer.isCorrect == true ? "1" : "0"
                let fiftyfifty = (self.question?.isUsedFifty ?? false) ? "1" : "0"
                self.submitAnswer(answer: selectedAnswer.answerEn ?? "", wrong: wrong, correct: corroct, skip: "0", wasta: "" , fiftyfifty:fiftyfifty)
            }
        case .QR:
            let vc = QRCodeScannerViewController()
            vc.isModalInPresentation = true
            vc.callback = { result in
                self.entered(text: result)
            }
            self.present(vc, animated: true)
            break
        default:
            break
        }
    }
    
    private func openLink(){
        if let openLink = question?.openlink {
            let link = openLink.string
            if let url = URL(string: link) {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        }
    }
}

