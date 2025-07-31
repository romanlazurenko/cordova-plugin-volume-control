# Cordova Volume Control Plugin

A custom Cordova plugin for detecting and controlling device volume levels on iOS and Android.

## Features

- ✅ **Volume Detection**: Get current media volume level
- ✅ **Mute Detection**: Check if device is muted or has very low volume
- ✅ **Volume Control**: Set media volume level (Android only)
- ✅ **Detailed Info**: Get comprehensive volume information
- ✅ **Cross-Platform**: Works on both iOS and Android

## Installation

### From GitHub

```bash
cordova plugin add https://github.com/romanlazurenko/cordova-plugin-volume-control.git
```

## Usage

### Basic Volume Check

```javascript
// Get current volume level (0.0 to 1.0)
cordova.plugins.VolumeControl.getVolume(
    function(volume) {
        console.log('Current volume:', volume);
    },
    function(error) {
        console.error('Error getting volume:', error);
    }
);
```

### Check if Device is Muted

```javascript
// Check if device is muted (volume < 10%)
cordova.plugins.VolumeControl.isMuted(
    function(result) {
        console.log('Is muted:', result.isMuted);
        console.log('Volume level:', result.volume);
    },
    function(error) {
        console.error('Error checking mute status:', error);
    }
);
```

### Set Volume (Android Only)

```javascript
// Set volume to 50%
cordova.plugins.VolumeControl.setVolume(0.5,
    function() {
        console.log('Volume set successfully');
    },
    function(error) {
        console.error('Error setting volume:', error);
    }
);
```

### Get Detailed Volume Information

```javascript
// Get comprehensive volume info
cordova.plugins.VolumeControl.getVolumeInfo(
    function(info) {
        console.log('Volume info:', info);
        // Returns: {
        //   volume: 0.75,
        //   isMuted: false,
        //   volumePercentage: 75,
        //   currentVolume: 15,
        //   maxVolume: 20,
        //   threshold: 0.1,
        //   platform: "Android",
        //   timestamp: 1234567890
        // }
    },
    function(error) {
        console.error('Error getting volume info:', error);
    }
);
```

## API Reference

### Methods

#### `getVolume(successCallback, errorCallback)`
Get the current media volume level.

- **Returns**: `number` (0.0 to 1.0)

#### `setVolume(volume, successCallback, errorCallback)`
Set the media volume level (Android only).

- **Parameters**: 
  - `volume` (number): Volume level from 0.0 to 1.0
- **Note**: iOS doesn't allow apps to directly change volume without user interaction

#### `isMuted(successCallback, errorCallback)`
Check if device is muted or has very low volume.

- **Returns**: `object`
  ```javascript
  {
    isMuted: boolean,
    volume: number,
    threshold: number
  }
  ```

#### `getVolumeInfo(successCallback, errorCallback)`
Get detailed volume information.

- **Returns**: `object`
  ```javascript
  {
    volume: number,
    isMuted: boolean,
    volumePercentage: number,
    currentVolume: number,
    maxVolume: number,
    threshold: number,
    platform: string,
    timestamp: number
  }
  ```

## Platform Support

| Feature | iOS | Android |
|---------|-----|---------|
| Volume Detection | ✅ | ✅ |
| Mute Detection | ✅ | ✅ |
| Volume Control | ❌ | ✅ |
| Detailed Info | ✅ | ✅ |

## iOS Limitations

- **Volume Control**: iOS doesn't allow apps to directly change volume without user interaction for security reasons
- **Volume Detection**: Uses `AVAudioSession.outputVolume` which is reliable and accurate

## Android Features

- **Full Volume Control**: Can read and write media volume
- **Real-time Updates**: Volume changes are detected immediately
- **Permission**: Requires `MODIFY_AUDIO_SETTINGS` permission

## Integration with Your App

### Example: Check Volume Before Playing Sound

```javascript
cordova.plugins.VolumeControl.isMuted(
    function(result) {
        if (!result.isMuted) {
            // Play sound
            playSound();
        } else {
            console.log('Device is muted, skipping sound');
        }
    },
    function(error) {
        // Fallback: play sound anyway
        playSound();
    }
);
```

## Development

### Building the Plugin

1. Clone the repository
2. Make your changes
3. Test with your Cordova app
4. Push to GitHub

### Testing

# Build and test
cordova build ios
cordova build android
```

## License

MIT License - see LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Support

For issues and questions, please create an issue on GitHub. 