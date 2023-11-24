using MediaDevices;



/// <summary>
/// Class to handle the MediaDevice API
/// Commands: 
///     List: List all devices, and write them to file
///     Read, Device, Source, Destination: Reads a file from the device
///     Write, Device, Source, Destination: Writes a file to the device
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
            args = new string[] { Functions.READ, "Sebastian's S22 Ultra", @"com.RedNexusGamesInc.Peglin\files", @"test"};
        }
        new MediaDeviceAPI(args);
    }

    public MediaDeviceAPI(string[] args) {
        checkDataFolderExists();
        if (args[0] == Functions.LIST) {
            writeDeviceList();
        }
        else if (args[0] == Functions.READ && args.Length == 4) {
            readFromDevice(args[1], args[2], args[3]);
        }
        else if (args[0] == Functions.WRITE && args.Length == 4) {
            writeToDevice(args[1], args[2], args[3]);
        } else {
            throw new Exception("Invalid arguments");
        }
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
                    device.UploadFolder(source, destination, true);
                    device.Disconnect();
                    return; // Early exit
                }
            }
        } catch (Exception e) {
            throw new Exception ("Error writing to device: " + e.Message);
        }
        throw new Exception ("Error writing to device: Device not found");
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