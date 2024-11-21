
class LoginDetails {
    LoginDetails({
         this.date,
         this.day,
         this.holidayFlag,
         this.logId,
         this.employeeId,
         this.loginDate,
         this.loginType,
         this.logInTime,
         this.logOutTime,
         this.isLatemarked,
         this.isEarlymarked,
         this.isLateLeave,
         this.isEarlyLeave,
         this.loginCoordinates,
         this.logoutCoordinates,
         this.wh,
         this.th,
         this.ah,
         this.isLeave,
         this.half,
         this.loginTimeStr,
         this.logoutTimeStr,
    });

    final DateTime? date;
    final String? day;
    final bool? holidayFlag;
    final String? logId;
    final int? employeeId;
    final DateTime? loginDate;
    final String? loginType;
    final DateTime? logInTime;
    final DateTime? logOutTime;
    final bool? isLatemarked;
    final bool? isEarlymarked;
    final bool? isLateLeave;
    final bool? isEarlyLeave;
    final String? loginCoordinates;
    final String? logoutCoordinates;
    final double? wh;
    final double? th;
    final double? ah;
    final int? isLeave;
    final String? half;
    final String? loginTimeStr;
    final String? logoutTimeStr;

    factory LoginDetails.fromJson(Map<String, dynamic> json){ 
        return LoginDetails(
            date: DateTime.tryParse(json["Date"] ?? ""),
            day: json["Day"],
            holidayFlag: json["HolidayFlag"],
            logId: json["LogId"],
            employeeId: json["EmployeeId"],
            loginDate: DateTime.tryParse(json["LoginDate"] ?? ""),
            loginType: json["LoginType"],
            logInTime: DateTime.tryParse(json["LogInTime"] ?? ""),
            logOutTime: DateTime.tryParse(json["LogOutTime"] ?? ""),
            isLatemarked: json["IsLatemarked"],
            isEarlymarked: json["IsEarlymarked"],
            isLateLeave: json["IsLateLeave"],
            isEarlyLeave: json["IsEarlyLeave"],
            loginCoordinates: json["LoginCoordinates"],
            logoutCoordinates: json["LogoutCoordinates"],
            wh:double.tryParse(json["WH"].toString()),
            th: double.tryParse(json["TH"].toString()),
            ah: double.tryParse(json["AH"].toString()),
            isLeave: json["IsLeave"],
            half: json["Half"],
            loginTimeStr: json["LoginTimeStr"],
            logoutTimeStr: json["LogoutTimeStr"],
        );
    }

    Map<String, dynamic> toJson() => {
        "Date": date?.toIso8601String(),
        "Day": day,
        "HolidayFlag": holidayFlag,
        "LogId": logId,
        "EmployeeId": employeeId,
        "LoginDate": loginDate?.toIso8601String(),
        "LoginType": loginType,
        "LogInTime": logInTime?.toIso8601String(),
        "LogOutTime": logOutTime?.toIso8601String(),
        "IsLatemarked": isLatemarked,
        "IsEarlymarked": isEarlymarked,
        "IsLateLeave": isLateLeave,
        "IsEarlyLeave": isEarlyLeave,
        "LoginCoordinates": loginCoordinates,
        "LogoutCoordinates": logoutCoordinates,
        "WH": wh,
        "TH": th,
        "AH": ah,
        "IsLeave": isLeave,
        "Half": half,
        "LoginTimeStr": loginTimeStr,
        "LogoutTimeStr": logoutTimeStr,
    };

    @override
    String toString(){
        return "$date, $day, $holidayFlag, $logId, $employeeId, $loginDate, $loginType, $logInTime, $logOutTime, $isLatemarked, $isEarlymarked, $isLateLeave, $isEarlyLeave, $loginCoordinates, $logoutCoordinates, $wh, $th, $ah, $isLeave, $half, $loginTimeStr, $logoutTimeStr, ";
    }
}
