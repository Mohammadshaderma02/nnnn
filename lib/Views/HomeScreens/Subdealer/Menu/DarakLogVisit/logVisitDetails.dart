import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../main.dart';
import '../../../../ReusableComponents/requiredText.dart';
import 'package:http/http.dart' as http;

class LogDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> logData;

  const LogDetailsScreen({Key key, this.logData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF392156),
        title: Text(
          "SubscriberView.logDetails".tr().toString(),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Navigator.pop(context);
          },
        ), //<Widget>[]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            buildDisplayField(
              labelKey: "SubscriberView.subject".tr(),
              value: logData['subject'] ?? '',
              isRequired: true,
            ),
            SizedBox(height: 10,),

            buildDisplayField(
              labelKey: "SubscriberView.visitDescription".tr(),
              value: logData['visitDescription'] ?? '',
              isRequired: true,
            ),
            SizedBox(height: 10,),



            buildDisplayField(
              labelKey: "SubscriberView.accountManagerName".tr(),
              value: logData['accountManagerName'] ?? '',
              isRequired: true,
            ),
            SizedBox(height: 10,),

            buildDisplayField(
              labelKey: "SubscriberView.plannedStartDate".tr(),
              value: logData['plannedStartDate'] ?? '',
              isRequired: true,
            ),
            SizedBox(height: 10,),

            buildDisplayField(
              labelKey: "SubscriberView.plannedEndDate".tr(),
              value: logData['plannedEndDate'] ?? '',
              isRequired: true,
            ),
            SizedBox(height: 10,),

            buildDisplayField(
              labelKey: "SubscriberView.createdByName".tr(),
              value: logData['createdByName'] ?? '',
              isRequired: true,
            ),
            
            SizedBox(height: 10,),

            buildDisplayField(
              labelKey: "SubscriberView.Actions".tr(),
              value: logData['actions'] != null
                  ? logData['actions']
                  .toString()
                  .split(',')
                  .map((e) => e.trim())
                  .join('\n')
                  : '',
              isRequired: true,
            ),
            SizedBox(height: 10,),
            buildDisplayField(
              labelKey: "SubscriberView.entryDate".tr(),
              value: logData['entryDate'] ?? '',
              isRequired: true,
            ),
            SizedBox(height: 10,),



          ],
          ),
        ),

      ),
    );
  }


  Widget buildDisplayField({
    String labelKey,
    String value,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: labelKey.tr(),
            style: const TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: [],

          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: const BoxConstraints(
            minHeight: 48,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD1D7E0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value.isNotEmpty ? value : '--',
            style: const TextStyle(
              color: Color(0xFF5A6F84),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
