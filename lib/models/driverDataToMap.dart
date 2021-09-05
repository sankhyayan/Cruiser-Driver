class DriverDataToMap {
  String name, email, phone;
  DriverDataToMap({required this.name, required this.email, required this.phone});
  static Map<String, dynamic> toMap(DriverDataToMap userData) {
    Map<String, dynamic> userMap = Map<String, dynamic>();
    userMap["name"] = userData.name;
    userMap["email"] = userData.email;
    userMap["phone"] = userData.phone;
    return userMap;
  }
}
