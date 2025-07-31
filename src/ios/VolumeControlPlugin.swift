import Cordova
import Foundation
import AVFoundation
import MediaPlayer

@objc(VolumeControlPlugin)
class VolumeControlPlugin: CDVPlugin {
    
    private var audioSession: AVAudioSession?
    private var volumeView: MPVolumeView?
    
    override func pluginInitialize() {
        super.pluginInitialize()
        
        // Initialize audio session
        audioSession = AVAudioSession.sharedInstance()
        
        // Create volume view for volume control
        volumeView = MPVolumeView()
        volumeView?.isHidden = true
        
        // Add to view hierarchy (hidden)
        if let webView = self.webView {
            webView.addSubview(volumeView!)
        }
    }
    
    @objc(getVolume:)
    func getVolume(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult
        
        do {
            let volume = try getCurrentVolume()
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: volume)
        } catch {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
        }
        
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }
    
    @objc(setVolume:)
    func setVolume(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult
        
        guard let volumeValue = command.arguments.first as? Double else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid volume parameter")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
            return
        }
        
        do {
            try setCurrentVolume(volume: Float(volumeValue))
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Volume set successfully")
        } catch {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
        }
        
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }
    
    @objc(isMuted:)
    func isMuted(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult
        
        do {
            let volume = try getCurrentVolume()
            let isMuted = volume < 0.1 // Consider volume below 10% as muted
            
            let result = [
                "isMuted": isMuted,
                "volume": volume,
                "threshold": 0.1
            ]
            
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result)
        } catch {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
        }
        
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }
    
    @objc(getVolumeInfo:)
    func getVolumeInfo(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult
        
        do {
            let volume = try getCurrentVolume()
            let isMuted = volume < 0.1
            
            let result = [
                "volume": volume,
                "isMuted": isMuted,
                "volumePercentage": Int(volume * 100),
                "threshold": 0.1,
                "platform": "iOS",
                "timestamp": Date().timeIntervalSince1970
            ]
            
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: result)
        } catch {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription)
        }
        
        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
    }
    
    // MARK: - Private Methods
    
    private func getCurrentVolume() throws -> Double {
        guard let audioSession = audioSession else {
            throw VolumeError.audioSessionNotAvailable
        }
        
        // Get the current output volume
        let volume = audioSession.outputVolume
        return Double(volume)
    }
    
    private func setCurrentVolume(volume: Float) throws {
        guard let volumeView = volumeView else {
            throw VolumeError.volumeViewNotAvailable
        }
        
        // Find the volume slider in the MPVolumeView
        guard let volumeSlider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider else {
            throw VolumeError.volumeSliderNotAvailable
        }
        
        // Set the volume (this requires user interaction on iOS)
        // Note: iOS doesn't allow apps to directly change volume without user interaction
        // This is a limitation of iOS for security reasons
        DispatchQueue.main.async {
            volumeSlider.value = volume
        }
    }
}

// MARK: - Error Types

enum VolumeError: Error {
    case audioSessionNotAvailable
    case volumeViewNotAvailable
    case volumeSliderNotAvailable
}

extension VolumeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .audioSessionNotAvailable:
            return "Audio session is not available"
        case .volumeViewNotAvailable:
            return "Volume view is not available"
        case .volumeSliderNotAvailable:
            return "Volume slider is not available"
        }
    }
} 