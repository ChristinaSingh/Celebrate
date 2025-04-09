//
//  TimerManager.swift
//  ToolTip
//
//  Created by Ihab yasser on 12/07/2023.
//

import Foundation
import Combine

protocol TimerDelegate {
    func runing(time: Int)
    func finished()
}

class TimerManager: ObservableObject {
    
    private var subscriber: Set<AnyCancellable> = Set<AnyCancellable>()
    private var storage: Int = 0
    private var timer: Timer? // No need for weak, because we manually invalidate it
    var delegate: TimerDelegate?
    
    private var isEnded: Bool {
        return time == 0
    }
    
    @Published private var time: Int! {
        didSet {
            if isEnded {
                subscriber.forEach { cancellable in
                    cancellable.cancel()
                }
                stop()
            }
        }
    }
    
    func start(with time: Int) {
//        stop() // Ensure any previous timer is stopped
        initSubscriber()
        initTime(time: time)
        setupTimer()
    }
    
    func stop() {
        invalidateTimer() // Ensure the timer is invalidated properly
        self.delegate?.finished()
    }
    
    func restart() {
        start(with: storage)
    }
    
    func pause() {
        invalidateTimer() // Invalidate the timer on pause
    }
    
    func resume() {
        setupTimer() // Resume the timer
    }
    
    private func setupTimer() {
        // Schedule a new timer if there's no active one
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func initTime(time: Int) {
        self.time = time
        self.storage = time
    }
    
    private func initSubscriber() {
        $time
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { second in
                self.delegate?.runing(time: second ?? 0)
            })
            .store(in: &subscriber)
    }
    
    @objc private func timerAction() {
        if !isEnded {
            time -= 1
        }
    }
}
