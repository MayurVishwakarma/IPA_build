class LeaveHistoryModel {
    LeaveHistoryModel({
        required this.status,
        required this.data,
    });

    final String? status;
    final Data? data;

    factory LeaveHistoryModel.fromJson(Map<String, dynamic> json){ 
        return LeaveHistoryModel(
            status: json["Status"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "Status": status,
        "data": data?.toJson(),
    };

    @override
    String toString(){
        return "$status, $data, ";
    }
}

class Data {
    Data({
        required this.leaveHistory,
        required this.leavesTaken,
        required this.leavesInitial,
    });

    final List<LeaveHistory> leaveHistory;
    final List<LeavesTaken> leavesTaken;
    final List<LeavesInitial> leavesInitial;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            leaveHistory: json["leaveHistory"] == null ? [] : List<LeaveHistory>.from(json["leaveHistory"]!.map((x) => LeaveHistory.fromJson(x))),
            leavesTaken: json["leavesTaken"] == null ? [] : List<LeavesTaken>.from(json["leavesTaken"]!.map((x) => LeavesTaken.fromJson(x))),
            leavesInitial: json["leavesInitial"] == null ? [] : List<LeavesInitial>.from(json["leavesInitial"]!.map((x) => LeavesInitial.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "leaveHistory": leaveHistory.map((x) => x.toJson()).toList(),
        "leavesTaken": leavesTaken.map((x) => x.toJson()).toList(),
        "leavesInitial": leavesInitial.map((x) => x.toJson()).toList(),
    };

    @override
    String toString(){
        return "$leaveHistory, $leavesTaken, $leavesInitial, ";
    }
}

class LeaveHistory {
    LeaveHistory({
        required this.leaveId,
        required this.employeeId,
        required this.fromDate,
        required this.toDate,
        required this.year,
        required this.leaveType,
        required this.half,
        required this.noOfDays,
        required this.reason,
        required this.appliedOn,
        required this.isApproved,
        required this.approvedBy,
        required this.approvedOn,
        required this.isSystemGen,
        required this.clTakenBefore,
        required this.plTakenBefore,
        required this.slTakenBefore,
        required this.wpTakenBefore,
        required this.clBalanceBefore,
        required this.plBalanceBefore,
        required this.slBalanceBefore,
        required this.clBalanceAfter,
        required this.plBalanceAfter,
        required this.slBalanceAfter,
        required this.appBy,
    });

    final String? leaveId;
    final int? employeeId;
    final DateTime? fromDate;
    final DateTime? toDate;
    final int? year;
    final String? leaveType;
    final String? half;
    final double? noOfDays;
    final String? reason;
    final DateTime? appliedOn;
    final bool? isApproved;
    final double? approvedBy;
    final DateTime? approvedOn;
    final bool? isSystemGen;
    final double? clTakenBefore;
    final double? plTakenBefore;
    final double? slTakenBefore;
    final double? wpTakenBefore;
    final double? clBalanceBefore;
    final double? plBalanceBefore;
    final double? slBalanceBefore;
    final double? clBalanceAfter;
    final double? plBalanceAfter;
    final double? slBalanceAfter;
    final String? appBy;

    factory LeaveHistory.fromJson(Map<String, dynamic> json){ 
        return LeaveHistory(
            leaveId: json["LeaveId"],
            employeeId: json["EmployeeId"],
            fromDate: DateTime.tryParse(json["FromDate"] ?? ""),
            toDate: DateTime.tryParse(json["ToDate"] ?? ""),
            year: json["Year"],
            leaveType: json["LeaveType"],
            half: json["Half"],
            noOfDays:double.tryParse(json["NoOfDays"].toString()),
            reason: json["Reason"],
            appliedOn: DateTime.tryParse(json["AppliedOn"] ?? ""),
            isApproved: json["IsApproved"],
            approvedBy: double.tryParse(json["ApprovedBy"].toString()),
            approvedOn: DateTime.tryParse(json["ApprovedOn"] ?? ""),
            isSystemGen: json["IsSystemGen"],
            clTakenBefore: double.tryParse(json["CLTakenBefore"].toString()),
            plTakenBefore: double.tryParse(json["PLTakenBefore"].toString()),
            slTakenBefore: double.tryParse(json["SLTakenBefore"].toString()),
            wpTakenBefore: double.tryParse(json["WPTakenBefore"].toString()),
            clBalanceBefore: double.tryParse(json["CLBalanceBefore"].toString()),
            plBalanceBefore:double.tryParse(json["PLBalanceBefore"].toString()),
            slBalanceBefore: double.tryParse(json["SLBalanceBefore"].toString()),
            clBalanceAfter: double.tryParse(json["CLBalanceAfter"].toString()),
            plBalanceAfter:double.tryParse(json["PLBalanceAfter"].toString()),
            slBalanceAfter: double.tryParse(json["SLBalanceAfter"].toString()),
            appBy: json["AppBy"],
        );
    }

    Map<String, dynamic> toJson() => {
        "LeaveId": leaveId,
        "EmployeeId": employeeId,
        "FromDate": fromDate?.toIso8601String(),
        "ToDate": toDate?.toIso8601String(),
        "Year": year,
        "LeaveType": leaveType,
        "Half": half,
        "NoOfDays": noOfDays,
        "Reason": reason,
        "AppliedOn": appliedOn?.toIso8601String(),
        "IsApproved": isApproved,
        "ApprovedBy": approvedBy,
        "ApprovedOn": approvedOn?.toIso8601String(),
        "IsSystemGen": isSystemGen,
        "CLTakenBefore": clTakenBefore,
        "PLTakenBefore": plTakenBefore,
        "SLTakenBefore": slTakenBefore,
        "WPTakenBefore": wpTakenBefore,
        "CLBalanceBefore": clBalanceBefore,
        "PLBalanceBefore": plBalanceBefore,
        "SLBalanceBefore": slBalanceBefore,
        "CLBalanceAfter": clBalanceAfter,
        "PLBalanceAfter": plBalanceAfter,
        "SLBalanceAfter": slBalanceAfter,
        "AppBy": appBy,
    };

    @override
    String toString(){
        return "$leaveId, $employeeId, $fromDate, $toDate, $year, $leaveType, $half, $noOfDays, $reason, $appliedOn, $isApproved, $approvedBy, $approvedOn, $isSystemGen, $clTakenBefore, $plTakenBefore, $slTakenBefore, $wpTakenBefore, $clBalanceBefore, $plBalanceBefore, $slBalanceBefore, $clBalanceAfter, $plBalanceAfter, $slBalanceAfter, $appBy, ";
    }
}

class LeavesInitial {
    LeavesInitial({
        required this.employeeId,
        required this.year,
        required this.cl,
        required this.pl,
        required this.sl,
    });

    final int? employeeId;
    final int? year;
    final int? cl;
    final int? pl;
    final int? sl;

    factory LeavesInitial.fromJson(Map<String, dynamic> json){ 
        return LeavesInitial(
            employeeId: json["EmployeeId"],
            year: json["Year"],
            cl: json["CL"],
            pl: json["PL"],
            sl: json["SL"],
        );
    }

    Map<String, dynamic> toJson() => {
        "EmployeeId": employeeId,
        "Year": year,
        "CL": cl,
        "PL": pl,
        "SL": sl,
    };

    @override
    String toString(){
        return "$employeeId, $year, $cl, $pl, $sl, ";
    }
}

class LeavesTaken {
    LeavesTaken({
        required this.leaveType,
        required this.days,
    });

    final String? leaveType;
    final double? days;

    factory LeavesTaken.fromJson(Map<String, dynamic> json){ 
        return LeavesTaken(
            leaveType: json["LeaveType"],
            days: double.tryParse(json["Days"].toString()),
        );
    }

    Map<String, dynamic> toJson() => {
        "LeaveType": leaveType,
        "Days": days,
    };

    @override
    String toString(){
        return "$leaveType, $days, ";
    }
}
