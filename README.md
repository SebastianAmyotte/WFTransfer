# WF Transfer

Provides backup and transferring of games saves between Android and Windows devices.

Optional internet access to update the internal database to provide up to date game rules.

Use your own rules to add games not currently in the database.

## Getting Started

This project has two internal projects that must both be built in order to function:

### Flutter project

A GUI wrapper for the MTP API that communicates with your Android device. 

After compilation, make sure you include the '/default/' folder and it's contents inside the root of your final built program.

Also make sure that the MTP API solution has been built and placed a folder named '/MTPAPI/' in the final built program directory.

### MTPAPI

Recommended to build using Visual Studio Code, requires MediaDevices package: https://www.nuget.org/packages/MediaDevices
