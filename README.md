# WF Transfer

Provides backup and transferring of games saves between Android and Windows devices.

Optional internet access to update the internal database to provide up to date game rules.

Use your own rules to add games not currently in the database.

## Getting Started

This project has two internal projects that must both be built in order to function:

### Flutter project

A GUI wrapper for ADB that communicates with your Android device. 

### ADB tools required

TODO

## Help

Make sure your device is plugged in and unlocked, some devices will not accept MTP connections while the phone is locked. Try increasing your screen timeout in settings.

Enable MTP or Mass storage after plugging in your device, check your notification panel for these settings.

## Application preview

<img src="https://github.com/SebastianAmyotte/WFTransfer/assets/71189225/63ff7821-1702-4fc4-ba39-7bc8ac022306" width="300">

<img src="https://github.com/SebastianAmyotte/WFTransfer/assets/71189225/25bf9b25-2a9b-403f-94ed-5b918857f6e2" width="300">

<img src="https://github.com/SebastianAmyotte/WFTransfer/assets/71189225/0b81716c-392c-461c-a70e-939c2cee164d" width="300">

<img src="https://github.com/SebastianAmyotte/WFTransfer/assets/71189225/634a3bb0-92f7-468d-a27d-59de81cb9ab6" width="300">

## Todo:

Improve performance over cable, especially older USB 2.0 standards. Perhaps a change of Android communication is necessary. ADB is a potential choice, but requires more initial technical user interaction
