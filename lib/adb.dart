import 'dart:io';

class ADB {
  String path = "platform-tools/";

  Future<ProcessResult> adb(List<String> command) async {
    return Process.run("${path}adb.exe", command);
  }

  Future<List<String>> detectDevice() async {
    ProcessResult result = await adb(["devices", "-l"]);
    List<String> phoneInfo = result.stdout.split("\n");
    phoneInfo.removeAt(0); // Remove the first line
    List<String> phones = [];
    for (String phone in phoneInfo) {
      if (phone.length <= 1) {
        // There is an invisible character from stdout, just checking if
        // the string is empty or not
        continue;
      }
      String serial = phone.split(" ")[0];
      String model = phone.split(" model:")[1].split(" ")[0];
      phones.add("$serial / $model");
    }
    return phones;
  }

  Future<bool> setUSBMode(bool usb) async {
    if (usb) {
      await adb(["usb"]);
      return true;
    } else {
      await adb(["tcpip", "5555"]);
      return true;
    }
  }
}
