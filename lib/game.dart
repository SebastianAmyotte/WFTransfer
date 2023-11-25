class Game {
  String name;
  String desktopLocation;
  String mobileLocation;
  String img;
  String info;
  Game(this.name, this.desktopLocation, this.mobileLocation, this.img,
      this.info);

  String describe() {
    return "$name, $desktopLocation, $mobileLocation, $img, $info";
  }

  String get getName {
    return name;
  }

  String get getDesktopLocation {
    return desktopLocation;
  }

  String get getMobileLocation {
    return mobileLocation;
  }

  String get getImg {
    return img;
  }

  String get getInfo {
    return info;
  }
}
