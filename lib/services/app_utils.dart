class AppUtils {
  // static String baseURL = "https://cybot.avanzosolutions.in/hms";
  // static String pythonBaseURL = "http://192.168.0.20:8000/hmsapp/api"; //naveen
  // static String pythonBaseURL =
  //     "http://192.168.0.184:8000/hmsapp/api"; //midhun system
  // static String pythonBaseURL =
  //     "http://192.168.0.83:8000/hmsapp/api"; //midhun laptop

  // static String pythonBaseURL =
  //     "http://192.168.229.28:8000/hmsapp/api"; //highland presentation

  // static const String pythonBaseURL = String.fromEnvironment("BASE_URL",
  //     defaultValue: "http://192.168.1.28:8000/hmsapp/api");

  // naveen
  static const String pythonBaseURL = String.fromEnvironment(
    "BASE_URL",

    defaultValue: "http://192.168.220.75:8000/hmsapp/api",
    // defaultValue: "https://hmsdevenv.highlandhospitals.in/api/hmsapp/api",
    // defaultValue: "https://hms.highlandhospitals.in/api/hmsapp/api",
  );
}
