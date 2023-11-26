class SaveData {
  String saveName;
  DateTime saveDate;
  String savePath;

  SaveData(this.saveName, this.saveDate, this.savePath);

  String get getName => saveName;
  String get getDate => convertDate();
  String get getPath => savePath;

  String convertDate() {
    return "${saveDate.month}/${saveDate.day}/${saveDate.year}";
  }

  String diskDate() {
    return "${saveDate.year}-${saveDate.month}-${saveDate.day}";
  }

  String diskName() {
    return "${saveName}_${diskDate()}";
  }
}
