# WF Transfer

Provides backup and transferring of games saves between Android and Windows devices.

Optional internet access to update the internal database to provide up to date game rules.

Use your own rules to add games not currently in the database.

<img src="https://github.com/SebastianAmyotte/WFTransfer/assets/71189225/63ff7821-1702-4fc4-ba39-7bc8ac022306" width="250">

<img src="https://github.com/SebastianAmyotte/WFTransfer/assets/71189225/25bf9b25-2a9b-403f-94ed-5b918857f6e2" width="250">

<img src="https://github.com/SebastianAmyotte/WFTransfer/assets/71189225/0b81716c-392c-461c-a70e-939c2cee164d" width="250">

<img src="https://github.com/SebastianAmyotte/WFTransfer/assets/71189225/634a3bb0-92f7-468d-a27d-59de81cb9ab6" width="250">


## Getting Started

This project has two internal projects that must both be built in order to function:

### Flutter project

A GUI wrapper for the MTP API that communicates with your Android device. 

After compilation, make sure you include the '/default/' folder and it's contents inside the root of your final built program.

Also make sure that the MTP API solution has been built and placed a folder named '/MTPAPI/' in the final built program directory.

### MTPAPI - C# project

Recommended to build using Visual Studio Code, requires MediaDevices package: https://www.nuget.org/packages/MediaDevices

## Help

Make sure your device is plugged in and unlocked, some devices will not accept MTP connections while the phone is locked. Try increasing your screen timeout in settings.

Enable MTP or Mass storage after plugging in your device, check your notification panel for these settings.

## Todo:

Improve performance over cable, especially older USB 2.0 standards. Perhaps a change of Android communication is necessary. ADB is a potential choice, but requires more initial technical user interaction
