import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/api/leave_api.dart';
import 'package:timesheet/provider/data_provider.dart';
import 'package:timesheet/screens/leave/apply_leave.dart';

import '../resources/color_constants.dart';
import '../widgets/custom_widgets.dart';

class LeaveHistory extends StatefulWidget {
  const LeaveHistory({super.key});
  static const routeName = "/leaveHistory";

  @override
  State<LeaveHistory> createState() => _LeaveHistoryState();
}

class _LeaveHistoryState extends State<LeaveHistory> {
  @override
  void initState() {
    if (context.mounted) {
      LeaveApi.getLeavehistory(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dtProvider = Provider.of<DataProvider>(context);
    final leavehistory = dtProvider.historyModel?.data?.leaveHistory;
    Row getRow(String title, String value, int index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 1, child: Text("$title :")),
          Expanded(
            flex: 2,
            child: Container(
                margin: const EdgeInsets.all(1),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstant.black900),
                  // boxShadow: [BoxShadow(color: (leavehistory![index].approvedOn == null)?ColorConstant.pastalRed: ColorConstant.green,blurRadius: 2)],
                  color: ColorConstant.whiteA700,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  value.toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                )),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Details"),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CustomButton(
              title: "APPLY LEAVE",
              onPressed: () async {
                await Navigator.pushNamed(context, ApplyLeavePage.routeName)
                    .whenComplete(() => LeaveApi.getLeavehistory(context));
              },
            ),
            ExpansionTile(
              initiallyExpanded: true,
              leading: const Icon(Icons.history),
              title: const Text("HISTORY"),
              children: [
                if (leavehistory != null)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leavehistory.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          color: (leavehistory[index].approvedOn == null)
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                          elevation: 8,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(
                            //    color: (leavehistory[index].approvedOn == null)?ColorConstant.pastalRed: ColorConstant.whiteA700,
                            //    border: Border.all(color: (leavehistory[index].approvedOn == null)?ColorConstant.pastalRed: ColorConstant.green),
                            //   boxShadow: [BoxShadow(color: (leavehistory[index].approvedOn == null)?ColorConstant.pastalRed: ColorConstant.mintGreen,blurRadius: 5)],
                            //    color: ColorConstant.whiteA700,
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                            child: Column(
                              children: [
                                getRow(
                                    "From date",
                                    DateFormat('dd-MM-yyyy')
                                        .format(leavehistory[index].fromDate!),
                                    index),
                                getRow(
                                    "To Date",
                                    DateFormat('dd-MM-yyyy')
                                        .format(leavehistory[index].toDate!),
                                    index),
                                getRow(
                                    "Leave Type",
                                    leavehistory[index].leaveType.toString(),
                                    index),
                                getRow("Half",
                                    leavehistory[index].half.toString(), index),
                                getRow(
                                    "Applied On",
                                    DateFormat('dd-MM-yyyy')
                                        .format(leavehistory[index].appliedOn!),
                                    index),
                                getRow("Approved By",
                                    leavehistory[index].appBy ?? "NA", index),
                                getRow(
                                    "Approved On",
                                    (leavehistory[index].approvedOn != null)
                                        ? DateFormat('dd-MM-yyyy').format(
                                            leavehistory[index].approvedOn!)
                                        : "NA",
                                    index),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
