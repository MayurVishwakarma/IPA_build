import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/api/leave_api.dart';
import 'package:timesheet/app/constants.dart';
import 'package:timesheet/provider/data_provider.dart';
import 'package:timesheet/screens/widgets/custom_widgets.dart';

import '../resources/color_constants.dart';

class ApplyLeavePage extends StatefulWidget {
  static const routeName = "/applyLeave";
  const ApplyLeavePage({super.key});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (context.mounted) {
      LeaveApi.getLeavehistory(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Row getRow(String title, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 1, child: Text("$title :")),
          Expanded(
            flex: 1,
            child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConstant.blueIris),
                child: Text(
                  value.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                )),
          )
        ],
      );
    }

    final dtProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("APPLY LEAVE"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getRow("Balance Leave", dtProvider.balenceLeaves.toString()),
              DropdownButtonFormField(
                isDense: true,
                borderRadius: BorderRadius.circular(5),
                decoration: InputDecoration(
                  hintText: "select leave type".toUpperCase(),
                  filled: true,
                  border: const OutlineInputBorder(),
                  fillColor: ColorConstant.whiteA700,
                  isDense: true,
                  // border: OutlineInputBorder()
                ),
                value: dtProvider.leaveType,
                items: dtProvider.leaveTypeList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    enabled: dtProvider.checkInitialLeaves(e),
                    child: Text(
                      e,
                      style: TextStyle(
                          color: dtProvider.checkInitialLeaves(e)
                              ? Colors.black
                              : Colors.red),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  dtProvider.updateLeaveType(val ?? "");
                },
              ),
              height10,
              Consumer<DataProvider>(
                builder: (context, value, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                              text: value.getDateString(value.fromDate)),
                          onTap: () async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate:value.fromDate ?? dtProvider.getInitialDate(),
                                firstDate: dtProvider.getFirstDateOfLeave(),
                                lastDate: DateTime(2100));
                            dtProvider.updateDate(
                                date: date, fromDateStatus: true);
                          },
                          readOnly: true,
                          decoration: getDecoration("From Date"),
                        ),
                      ),
                      width5,
                      Expanded(
                        child: TextFormField(
                          controller: TextEditingController(
                              text: value.getDateString(value.toDate)),
                          readOnly: true,
                          decoration: getDecoration("To Date"),
                          onTap: () async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: value.toDate ?? dtProvider.getInitialDate(),
                                firstDate: dtProvider.getFirstDateOfLeave(),
                                lastDate: dtProvider.getLastDateOfLeave());
                            dtProvider.updateDate(
                                date: date, toDateStatus: true);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              height10,
              if (dtProvider.compareDates(
                  firstDate: dtProvider.fromDate ?? DateTime.now(),
                  secDate: dtProvider.toDate))
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorConstant.black900),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: RadioListTile(
                              value: null,
                              groupValue: dtProvider.halfOrFull,
                              onChanged: (value) {
                                dtProvider.updateHalfOrFullLeave(value);
                              },
                              title: const Text('Full'))),
                      Expanded(
                          child: RadioListTile(
                              value: "half",
                              groupValue: dtProvider.halfOrFull,
                              onChanged: (value) {
                                dtProvider.updateHalfOrFullLeave(value);
                              },
                              title: const Text('Half'))),
                    ],
                  ),
                ),
              if (dtProvider.compareDates(
                  firstDate: dtProvider.fromDate ?? DateTime.now(),
                  secDate: dtProvider.toDate))
                height10,
              if (dtProvider.halfOrFull != null)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorConstant.black900),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: RadioListTile(
                              value: "first",
                              groupValue: dtProvider.halfLeaveType,
                              onChanged: (value) {
                                dtProvider.updateHalfLeaveType(value);
                              },
                              title: const Text('First'))),
                      Expanded(
                          child: RadioListTile(
                              value: "second",
                              groupValue: dtProvider.halfLeaveType,
                              onChanged: (value) {
                                dtProvider.updateHalfLeaveType(value);
                              },
                              title: const Text('Second'))),
                    ],
                  ),
                ),
              if (dtProvider.compareDates(
                  firstDate: dtProvider.fromDate ?? DateTime.now(),
                  secDate: dtProvider.toDate))
                height10,
              TextFormField(
                maxLines: 3,
                controller: reasonController,
                decoration: getDecoration("Reason"),
              ),
              if (dtProvider.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              height10,
              CustomButton(
                title: "Apply".toUpperCase(),
                onPressed: () {
                  LeaveApi.applyLeave(context, reasonController.text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
