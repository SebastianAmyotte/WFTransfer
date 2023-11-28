using MediaDevices;
using Microsoft.VisualBasic.FileIO;

/// <summary>
/// Class to handle the MediaDevice API
/// Commands: 
///     List:  List all devices, and write them to file
///     Read:  Device, Source, Destination: Reads a file from the device
///     Write: Device, Source, Destination: Writes a file to the device
///     XFER:  Source, Destination: Copies a folder from one device to another
/// </summary>
class MediaDeviceAPI
{
    static string HOST_ROOT_PATH = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments) + @"\WFSaves\";
    static string MOBILE_ROOT_PATH = @"\Internal storage\Android\data\";
    static string MOBILE_DEVICE_LIST_PATH = HOST_ROOT_PATH + @"devices.txt";

    // Entry point
    static void Main(string[] args) {
        if (args.Length == 0) {
            // debug args
            args = new string[] { Functions.WRITE, "Sebastian's S22 Ultra", @"C:\Users\Sebastian\Documents\WFSaves\saves\Peglin\Mobile save_2023-11-26", @"\Internal storage\Android\data\com.RedNexusGamesInc.Peglin\files\"};
        }
        new MediaDeviceAPI(args);
    }

    public MediaDeviceAPI(string[] args) {
        try {
            checkDataFolderExists();
            if (args[0] == Functions.LIST) {
                writeDeviceList();
            }
            else if (args[0] == Functions.READ && args.Length == 4) {
                readFromDevice(args[1], args[2], args[3]);
            }
            else if (args[0] == Functions.WRITE && args.Length == 4) {
                writeToDevice(args[1], args[2], args[3]);
            }
            else if (args[0] == Functions.XFER && args.Length == 3) {
                copyOnDevice(args[1], args[2]);
            }
            else {
                throw new Exception("Invalid arguments");
            }
        } catch (Exception e) {
            // Write error to disk
            File.WriteAllText("e.txt", e.Message + " " + args[1]);
            Environment.Exit(-1);
        }
        Environment.Exit(0);
    }

    /// <summary>
    /// Write the list of devices to a file
    /// </summary>
    void writeDeviceList() {
        IEnumerable<MediaDevice> devices = MediaDevice.GetDevices();
        String deviceNames = "";
        foreach (var device in devices)
        {
            deviceNames = deviceNames + device.FriendlyName + "\n";
        }
        File.WriteAllText(MOBILE_DEVICE_LIST_PATH, deviceNames);
    }

    void readFromDevice(String deviceName, String path, String destination) {
        try {
            foreach (var device in MediaDevice.GetDevices()) {
                if (device.FriendlyName == deviceName) {
                    device.Connect();
                    device.DownloadFolder(MOBILE_ROOT_PATH + path, HOST_ROOT_PATH + destination, true);
                    device.Disconnect();
                    return; // Early exit
                }
            }
        } catch (Exception e) {
            throw new Exception ("Error reading from device: " + e.Message);
        }
        throw new Exception ("Error reading from device: Device not found");
    }

    void writeToDevice(String deviceName, String source, String destination) {
        try {
            foreach (var device in MediaDevice.GetDevices()) {
                if (device.FriendlyName == deviceName) {
                    device.Connect();
                    var files = device.EnumerateFiles(destination);
                    foreach (var file in files) {
                        device.DeleteFile(file);
                    }
                    device.UploadFolder(source, destination, false);
                    device.Disconnect();
                    return; // Early exit
                }
            }
        } catch (Exception e) {
            throw new Exception ("Error writing to device: " + e.Message);
        }
        throw new Exception ("Error writing to device: Device not found");
    }

    void copyOnDevice(string source, string destination) {
        FileSystem.CopyDirectory(
            Environment.ExpandEnvironmentVariables(source),
            Environment.ExpandEnvironmentVariables(destination),
            true
        );
    }

    /// <summary>
    /// Check if the data folder exists, if not create it
    /// </summary>
    void checkDataFolderExists() {
        if (!Directory.Exists(HOST_ROOT_PATH)) {
            Directory.CreateDirectory(HOST_ROOT_PATH);
        }
    }
}