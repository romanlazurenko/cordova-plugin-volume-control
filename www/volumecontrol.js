var exec = require('cordova/exec');

var VolumeControl = {
    /**
     * Get the current media volume level
     * @param {Function} successCallback - Called with volume info
     * @param {Function} errorCallback - Called on error
     */
    getVolume: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'VolumeControlPlugin', 'getVolume', []);
    },
    
    /**
     * Set the media volume level
     * @param {number} volume - Volume level (0.0 to 1.0)
     * @param {Function} successCallback - Called on success
     * @param {Function} errorCallback - Called on error
     */
    setVolume: function(volume, successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'VolumeControlPlugin', 'setVolume', [volume]);
    },
    
    /**
     * Check if device is muted or has very low volume
     * @param {Function} successCallback - Called with mute status
     * @param {Function} errorCallback - Called on error
     */
    isMuted: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'VolumeControlPlugin', 'isMuted', []);
    },
    
    /**
     * Get detailed volume information
     * @param {Function} successCallback - Called with volume details
     * @param {Function} errorCallback - Called on error
     */
    getVolumeInfo: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, 'VolumeControlPlugin', 'getVolumeInfo', []);
    }
};

module.exports = VolumeControl; 