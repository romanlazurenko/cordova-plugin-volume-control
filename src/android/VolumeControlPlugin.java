package com.yourname.volumecontrol;

import android.content.Context;
import android.media.AudioManager;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class VolumeControlPlugin extends CordovaPlugin {
    
    private static final String TAG = "VolumeControlPlugin";
    private AudioManager audioManager;
    
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        
        if (audioManager == null) {
            audioManager = (AudioManager) cordova.getActivity().getSystemService(Context.AUDIO_SERVICE);
        }
        
        switch (action) {
            case "getVolume":
                getVolume(callbackContext);
                return true;
            case "setVolume":
                setVolume(args, callbackContext);
                return true;
            case "isMuted":
                isMuted(callbackContext);
                return true;
            case "getVolumeInfo":
                getVolumeInfo(callbackContext);
                return true;
            default:
                return false;
        }
    }
    
    private void getVolume(CallbackContext callbackContext) {
        try {
            int currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
            int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            
            double volumePercentage = maxVolume > 0 ? (double) currentVolume / maxVolume : 0.0;
            
            Log.d(TAG, "Current volume: " + currentVolume + "/" + maxVolume + " (" + (volumePercentage * 100) + "%)");
            callbackContext.success(volumePercentage);
            
        } catch (Exception e) {
            Log.e(TAG, "Error getting volume", e);
            callbackContext.error("Failed to get volume: " + e.getMessage());
        }
    }
    
    private void setVolume(JSONArray args, CallbackContext callbackContext) {
        try {
            double volumeValue = args.getDouble(0);
            
            // Clamp volume between 0.0 and 1.0
            volumeValue = Math.max(0.0, Math.min(1.0, volumeValue));
            
            int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            int targetVolume = (int) (volumeValue * maxVolume);
            
            audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, targetVolume, 0);
            
            Log.d(TAG, "Volume set to: " + targetVolume + "/" + maxVolume + " (" + (volumeValue * 100) + "%)");
            callbackContext.success("Volume set successfully");
            
        } catch (Exception e) {
            Log.e(TAG, "Error setting volume", e);
            callbackContext.error("Failed to set volume: " + e.getMessage());
        }
    }
    
    private void isMuted(CallbackContext callbackContext) {
        try {
            int currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
            int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            
            double volumePercentage = maxVolume > 0 ? (double) currentVolume / maxVolume : 0.0;
            boolean isMuted = volumePercentage < 0.1; // Consider below 10% as muted
            
            JSONObject result = new JSONObject();
            result.put("isMuted", isMuted);
            result.put("volume", volumePercentage);
            result.put("threshold", 0.1);
            
            Log.d(TAG, "Mute check: " + isMuted + " (volume: " + (volumePercentage * 100) + "%)");
            callbackContext.success(result);
            
        } catch (Exception e) {
            Log.e(TAG, "Error checking mute status", e);
            callbackContext.error("Failed to check mute status: " + e.getMessage());
        }
    }
    
    private void getVolumeInfo(CallbackContext callbackContext) {
        try {
            int currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
            int maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            
            double volumePercentage = maxVolume > 0 ? (double) currentVolume / maxVolume : 0.0;
            boolean isMuted = volumePercentage < 0.1;
            
            JSONObject result = new JSONObject();
            result.put("volume", volumePercentage);
            result.put("isMuted", isMuted);
            result.put("volumePercentage", (int) (volumePercentage * 100));
            result.put("currentVolume", currentVolume);
            result.put("maxVolume", maxVolume);
            result.put("threshold", 0.1);
            result.put("platform", "Android");
            result.put("timestamp", System.currentTimeMillis());
            
            Log.d(TAG, "Volume info: " + currentVolume + "/" + maxVolume + " (" + (volumePercentage * 100) + "%)");
            callbackContext.success(result);
            
        } catch (Exception e) {
            Log.e(TAG, "Error getting volume info", e);
            callbackContext.error("Failed to get volume info: " + e.getMessage());
        }
    }
} 