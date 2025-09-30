import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
class Terms_Conditions extends StatefulWidget {
  final Function onStepChanged;
   Terms_Conditions({ this.onStepChanged});

  @override
  State<Terms_Conditions> createState() => _Terms_ConditionsState();
}

class _Terms_ConditionsState extends State<Terms_Conditions> {
  DateTime backButtonPressedTime;



  bool firstSwitch=false;
  bool secondSwitch=false;

  bool _showNativeView = false;

  void changeFirstSwitched(value) async {
    setState(() {

      globalVars.termCondition1 = !globalVars.termCondition1;
    });
  }

  void changeSecondSwitched(value) async {
    setState(() {
      secondSwitch = !secondSwitch;
      globalVars.termCondition2 = !globalVars.termCondition2;
    });
  }

  int getScreen() {
    switch ( globalVars.currentStep) {
      case 1:
        setState(() {
          globalVars.currentScreenIndex = 0;
        });
        /*  if(globalVars.currentStep==1 && globalVars.currentScreen==0){
          setState(() {
            globalVars.currentScreenIndex = 0;
          });
        }
        if(globalVars.currentStep==1 && globalVars.currentScreen==1){
          setState(() {
            globalVars.currentScreenIndex = 1;
          });
        }*/

        return 0;
      case 2:
        setState(() {
          globalVars.currentScreenIndex = 1;
        });
        return 0;

      case 3:
        setState(() {
          globalVars.currentScreenIndex = 2;
        });
        return 0;
      case 4:
        setState(() {
          globalVars.currentScreenIndex = 3;
        });
        return 0;
      case 5:
        setState(() {
          globalVars.currentScreenIndex = 5;
        });
        return 0;
      case 6:
        setState(() {
          globalVars.currentScreenIndex = 6;
        });
        return 0;



    // Add more cases if needed
      default:
        return 8;
    }
  }


  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(

            backgroundColor: Color(0xFFEBECF1),
            body:  ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 25, bottom: 0, left: 0, right: 0),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*............................................................First Terms............................................................*/

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")?
                        "Terms and Conditions of the contracts for the Prepaid and Postpaid subscribers":
                        "الشروط والأحكام لعقود المشتركين في خدمات الدفع المسبق واللاحق",
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),// Set height as per your requirement
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(5.0), // Border radius
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
                          children: [
                            Text( EasyLocalization.of(context).locale == Locale("en", "US")?"\nDefinitions:\n":"\nالتعريفات\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"The following terminology will have the below mentioned meanings unless the context indicates otherwise: \n":"يكون للمصطلحات التالية المعاني المبينة أدناه ما لم تدل القرينة على غير ذلك: \n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Telecommunications Law: Telecommunications Law No. (13) for the year 1995 and related amendments. \n":"قانون الاتصالات: قانون الاتصالات رقم (13) لسنة 1995 وتعديلاته.\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"TRC: Telecommunications Regulatory Commission established according to the Telecommunications Law No. (13) for the year 1995.\n":"الهيئة: هيئة تنظيم قطاع الاتصالات المنشأة بموجب قانون الاتصالات رقم (13) لسنة 1995. \n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Zain: Jordan Mobile Telephone Services Private Shareholding Company Ltd., a company licensed to provide mobile telephone services.Subscriber’s Account: Means storage of information related to subscriber’s subscription status including: \n":"زين: الشركة الأردنية لخدمات الهواتف المتنقلة المساهمة الخاصة المحدودة وهي شركة مرخصة لتزويد خدمات الهواتف المتنقلة. حساب المشترك: تعني خدمة المعلومات المخزن فيها جميع المعلومات الخاصة بوضع الاشتراك الخاص بالمشترك والتي تشمل \n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"1- Outstanding balance.\n":"1- الرصيد المتبقي\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"2- Period in which subscription is valid and in effect \n":"2- فترة السريان والنفاذ\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"3. Period of receiving phone calls. \n":"3- فترة استقبال المكالمات\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"3. Period of receiving phone calls. \n":"3- فترة استقبال المكالمات\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Subscriber: Natural or legal person or his authorized designate who signs the service subscription application form after reading and granting his consent to all the below-mentioned terms and conditions. \n":"المشترك: الشخص الطبيعي او المعنوي او المفوض عنه الذي يوقع على نموذج طلب الاشتراك بالخدمة بعد ان يكون قد قرأ ووافق على جميع الشروط والاحكام المبينة أدناه.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Subscription Contract (Contract): The terms and conditions that regulate the relationship between Zain and the subscriber, which include the following: Service subscription application \n":"عقد الاشتراك (العقد): هو الشروط والاحكام التي تنظم العلاقة بين زين والمشترك وتشمل ما يلي:\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Service subscription application form: Form appended to the contract indicating service applicant particulars and description of service applied for and which is filled by the subscriber to obtain the service to which he/she intends to subscribe \n":"نموذج طلب الاشتراك بالخدمة: هو النموذج الملحق بالعقد والمبين فيه بيانات طالب الخدمة ووصف الخدمة المراد الحصول عليها والذي يتم تعبئته من قبل المشترك للحصول على الخدمة المنوي الاشتراك بها.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"2G: Mobile global telecommunications system of the second generation networks.  \n":"2G: النظام العالمي للاتصالات المتنقلة في شبكات الجيل الثاني.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"3G/HSPA+: High Speed Packet Access.\n":"3G/HSPA: تكنولوجيا حزمة النفاذ عالي السرعة.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"4G/LTE: Long-Term Evolution\n":"4G/LTE: التطور بعيد المدى\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Service: Means gaining access to the Network through a cellular set or mobile modem consistent with “2G” and/or “3G/HSPA++” and/or “4G/LTE”.\n":"الخدمة: تعني الدخول إلى الشبكة عن طريق جهاز خلوي أو جهاز مودم متنقل والذي يتطابق مع2G  و/أو 3G/HSPA+ و/أو 4G/LTE.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Network: Means the whole mobile telephone network “2G” and/or “3G/HSPA+” and/or “4G/LTE” operated by Zain within the boundaries of the Hashemite Kingdom of Jordan.\n":"الشبكة: تعني كامل شبكة الهاتف المتنقلة الـ 2G و/أو 3G/HSPA+ و/أو 4G/LTE المشغلة من قبل زين ضمن حدود المملكة الاردنية الهاشمية.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"License: Permit granted by the TRC or the contract or agreement signed between the TRC and Zain thereby allowing Zain to set up, operate and manage a public telecommunications network or to provide public telecommunications services or to use radio frequencies according to the provisions of the Telecommunications Law and the regulations accordingly issued.\n":"الرخصة: الاذن الممنوح من الهيئة أو العقد أو الاتفاقية الموقع أي منها بين الهيئة وزين للسماح لها بإنشاء وتشغيل وادارة شبكة اتصالات عامة أو تقديم خدمات اتصالات عامة أو استخدام ترددات راديوية، وذلك وفق أحكام قانون الاتصالات والانظمة الصادرة بموجبه.\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"SIM Card: A card whereby the subscriber is identified on the network and which has a very small and precise storage unit along with a processing unit wherein the user’s data are stored.\n":"بطاقة التعريف الشخصية (SIM Card): هي بطاقة يتم بموجبها تعريف المشترك على الشبكة، بها وحدة تخزين صغيرة جداً ودقيقة ووحدة معالجة تخزن بها بيانات المستخدم.\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Charging/Balance charging: Means the different devices available to the subscriber such as charging cards and/or other means for re-charging his/her account balance.\n":"الشحن/ شحن الرصيد: تعني الوسائل المختلفة المتاحة للمشترك من بطاقات شحن و/أو غيرها للقيام بإعادة تعبئة رصيد حسابه.\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Date of Expiry: Means the date on which the charging card becomes invalid.\n":"تاريخ الانتهاء: يعني التاريخ الذي تصبح عنده بطاقة الشحن غير سارية المفعول.\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Effective (Validity Period): Means the period during which the subscriber can use his/her re-charged balance through performing the charging process and whether such period has been written on the pre-paid charging card and/or on other items and during which the subscriber can send and receive phone calls.\n":"فترة السريان (مدة الصلاحية): يعني الفترة التي يملك خلالها المشترك استعمال رصيده الذي أعاد تعبئته من خلال قيامه بعملية الشحن وسواء كانت مدونة على بطاقة الشحن المدفوعة مسبقاً و/أو غير ذلك والتي يمكن للمشترك خلالها إرسال واستقبال المكالمات.\n"),


                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Reception Period: Means the period during which the internet-access service is suspended and during which the subscriber can only receive phone calls, recharge his account, call the Customer Care Center, and make emergency phone calls.\n":"فترة الاستقبال: تعني الفترة التي يتم خلالها تعليق خدمة النفاذ الى الانترنت ويستطيع خلالها المشترك: استقبال المكالمات فقط، اعادة تعبئة حسابه، الاتصال مع خدمات المشتركين واجراء المكالمات الطارئة.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Suspension Period: Means the period during which the subscriber can re-charge the card and benefit from the service after the end of reception period.\n":"فترة التعليق: الفترة التي يمكن للمشترك خلالها إعادة شحن البطاقة والاستفادة من الخدمة بعد انتهاء فترة الاستقبال.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Subscription Day: Means the day on which the contract is signed and the required fees are paid.\n":"يوم الاشتراك: يعني اليوم الذي يتم فيه توقيع العقد ودفع الرسوم المطلوبة.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Subscribers’ Information: For the individual, these include: copy of the civil status identity card, passport, or resident permit of non-residents; and for the companies, establishments or for any other legal entity: copy of the registration certificate, copy of the certificate of authorized signatories, and copy of personality identity documents.\n":"بيانات المشتركين: وتشمل للفرد: صورة عن هوية الأحوال المدنية أو جواز السفر أو تصريح الإقامة لغير المقيمين، وللشركات أو المؤسسات أو أي شخصية اعتبارية أخرى: صورة عن شهادة التسجيل وصورة عن شهادة المفوضين بالتوقيع عنها وصورة عن وثائق اثبات الشخصية.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Force Majeure: Means the extraordinary incident which cannot be anticipated and/or removed and for which compliance therewith becomes impossible so that Zain can no longer meet its proven obligations according to this contract.\n":"القوة القاهرة: هي الحادث الاستثنائي الذي لا يمكن توقعه و/أو دفعه ويجعل تنفيذ الالتزام مستحيلاً بحيث لا تعود زين قادرة على الوفاء بالتزاماتها الثابتة بموجب هذا العقد.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Method of Service Provisioning:\n":"طريقة تقديم الخدمة:\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"As the case requires, it is either:\n":"هي إما حسب الحال:\n"),


                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Pre-paid service: which allows the subscriber to have access to Zain Network for benefiting from Zain’s mobile telecommunications, and also to have access to the Internet Wireless Network using the personal identification card and a cellular set/modem set consistent with Zain Network, and the deductions are, therefore, made out of the subscriber’s account amount recorded on the Network System according to the subscriber’s consumption and within the context of the tariff specified by Zain; or\n":"خدمة الدفع المسبق: والتي تتيح للمشترك النفاذ الى شبكة زين للانتفاع من خدمات زين للاتصالات المتنقلة وكذلك النفاذ الى شبكة الانترنت اللاسلكي باستخدام بطاقة التعريف الشخصية وجهاز خلوي / جهاز مودم متطابق مع شبكة زين، وبالتالي تتم عمليات الخصم من قيمة حساب المشترك المسجل على نظام الشبكة حسب استهلاك المشترك وضمن التعرفة المحددة من قبل زين؛ أو:\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Post-payment Service: This service allows the subscriber to have access to Zain Network for benefiting from Zain’s mobile telecommunication services and to the Internet Wireless Network using the personal identification card and cellular set/modem set consistent with Zain Network provided that the subscriber will be charged for using the service at the end of each month through issuing a monthly invoice payable in (21) days from the date thereof.\n":"خدمة الدفع اللاحق: التي تتيح للمشترك النفاذ إلى شبكة زين للانتفاع من خدمات زين للاتصالات المتنقلة وكذلك النفاذ إلى شبكة الانترنت اللاسلكي باستخدام بطاقة التعريف الشخصية وجهاز خلوي أو جهاز مودم متطابق مع شبكة زين، على أن يتم محاسبة المشترك عن استخدامه للخدمة في نهاية كل شهر بإصدار فاتورة شهرية واجبة الدفع خلال مدة (21) يوم من تاريخها.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Providing service:\n":"تقديم الخدمة\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"On the subscription day and after subscriber’s payment of fees and filling out of the service subscription application form, the subscriber will be provided with a personal identification card and cellular phone number thereby allowing the subscriber to benefit from service without any property right accrued to his/her cellular phone number specified for benefiting there from. Such number will be changed and re-allocated as required by the National Numbering Plan and/or with the approval of the TRC provided that the subscriber will be notified thereof or an announcement to that effect is made via proper methods.\n":"في يوم الاشتراك وبعد دفع المشترك الرسوم وتعبئة نموذج طلب الاشتراك بالخدمة، يتم تزويد المشترك ببطاقة التعريف الشخصية ورقم الهاتف الخلوي والذي سيتيح للمشترك الانتفاع بالخدمة ولا يترتب على ذلك أي حق من حقوق الملكية على رقم هاتفه الخلوي المحدد لانتفاعه والذي يتغير ويعاد تخصيصه في الحالات التي تقتضيها خطة الترقيم الوطنية و/أو بموافقة الهيئة، على ان يتم اشعار المشترك أو الاعلان عن ذلك بالطرق المناسبة.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Zain will verify the extent of coverage in the area where the Customer will mainly use the service, as well as verifying whether he/she is located within the area of coverage of (2G) and/or (3G/HSPA+) and/or (4G/LTE) network related to Zain.\n":"ستقوم زين بالتثبت من مدى التغطية في المنطقة التي سيقوم المشترك باستخدام الخدمة فيها بشكل أساسي وكذلك عن وقوعه ضمن منطقة تغطية شبكة (2G) و/أو (3G/HSPA+) و/أو (4G/LTE) الخاصة بزين.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"When the applicant makes an application for the service, Zain will inform the subscriber of the cellular/modem set conformity conditions with Zain Network along with subscriber’s location within the coverage area of (2G) and/or (3G/HSPA+) and/or (4G/LTE) network related to Zain and as identified on the system according to the network.\n":"عند تقدم طالب الخدمة للحصول على الخدمة، ستقوم زين بتعريف المشترك بشروط مطابقة الجهاز الخلوي أو جهاز المودم مع شبكة زين بالاضافة الى وقوع المشترك ضمن منطقة تغطية شبكة (2G) و/أو (3G/HSPA+) و/أو (4G/LTE) الخاصة بزين، ومعرفاً على النظام حسب الشبكة.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Zain will exert its best efforts to provide the service within five working days from the date of signing the Contract.\n":"ستبذل زين أفضل مساعيها لتزويد الخدمة خلال خمسة أيام عمل من تاريخ التوقيع على العقد.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"With due observance of the terms and conditions of Zain’s license, Zain may request the post-payment service subscriber, either at the time of signing the contract or at any other time during the validity thereof, to make a guaranty or warranty deposit with it, the amount of this guarantee or warranty shall not exceed the amount of the expected invoice of the subscriber for three months and, as the case. Zain shall be entitled to request a guarantee or warranty according to this clause in, but will not be limited to, the following cases:\n":"مع مراعاة شروط الرخصة الممنوحة لزين، يجوز لزين أن تطلب من مشترك خدمات الدفع اللاحق سواء عند توقيع العقد، أو في أي وقت خلال سريانه، إيداع كفالة أو ضمانة لديها على أن لا تتجاوز قيمة الكفالة أو الضمانة الفاتورة المتوقعة للمشترك لثلاثة أشهر وبحسب الحال، وينشأ حق زين بطلب كفالة أو ضمانة بموجب هذه الفقرة في الحالات التالية دونما حصر:\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Perpetration by the subscriber of any action either during the present or previous subscription period indicating his/her inability to pay the due amounts on the proper dates.\n":"صدور أي تصرف عن المشترك سواء خلال مدة الاشتراك الحالية أو مدة الاشتراك السابقة نم عن عدم قدرته أو التزامه بتسديد المبالغ المستحقة عليه في المواعيد المقررة.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"In the event that the subscriber has no permanent address on the Jordanian lands or if Zain has found that the subscriber’s address is not clear enough for receiving invoices or correspondence.\n":"إذا لم يكن للمشترك عنوان ثابت على الأراضي الأردنية أو إذا وجدت زين عنوانه غير واضح لتلقي الفواتير والمراسلات.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"In cases of subscribing to the international calling or roaming service.\n":" في حالات الاشتراك بخدمة التخابر الدولي أو خدمة التجوال الدولي.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Subscriber will pay guaranty or warranty in cash as indicated in Clause (5) at the time of submitting the application, and this guarantee shall be retained throughout the subscription period for paying the amounts owed by the subscriber in return for benefiting from the service. This guarantee shall constitute the basis for the credit permissible to the subscriber which might be increased at the subscriber’s request provided that this will be followed by an increase in the amount paid as a guarantee, at the discretion of Zain. Service shall be subject to suspension at any time the subscriber reaches the credit limit during the subscription period, and Zain should notify the subscriber previously to this effect via proper methods.\n":"يدفع المشترك عند تقديم الطلب الكفالة أو الضمانة النقدية المبينة في الفقرة (5) وتبقى هذه الضمانة قائمة طيلة مدة الاشتراك لسداد المبالغ المستحقة بذمة المشترك مقابل انتفاعه بالخدمة، وتعتبر هذه الضمانة أساسا لحد الائتمان المسموح به للمشترك والذي يجوز أن تتم زيادته بناء على طلب المشترك على أن يتبع ذلك زيادة بالمبلغ المدفوع كضمانة إذا ارتأت زين ذلك. وتكون الخدمة عرضة للوقف في أي وقت يصل فيه المشترك حد الائتمان خلال مدة الاشتراك، على أن تقوم زين بإشعار المشترك مسبقاً بالطرق المناسبة.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"In the event that the contract has expired or has been terminated for any reason whatsoever, any amounts payable by the subscriber shall be paid out of the guaranty or warranty, and any balance shall be returned to subscriber. However, it is agreed that the amounts deposited with Zain will not yield any interest, nor shall Zain be entitled to any interest on the amounts which the subscriber owes to Zain prior to the date of judicial claim for such amounts.\n":"عند انتهاء العقد أو فسخه لأي سبب من الأسباب، يتم سداد أية مبالغ مستحقة على المشترك من الكفالة أو الضمانة وإعادة أي رصيد للمشترك، على أنه من المتفق عليه أنه لا ينتج عن المبالغ المودعة لدى زين أية فوائد كما لا يستحق لزين أية فوائد عن المبالغ المستحقة على المشترك قبل تاريخ المطالبة القضائية بهذه المبالغ.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Zain may deduct any amounts payable by the subscriber owing to this contract or for any other subscription contract out of any amounts deposited with it and may also confiscate any guaranty and returned any balance, if any, to the subscriber.\n":"يجوز لزين أن تقتطع أية مبالغ مستحقة على المشترك بسبب هذا العقد أو بسبب أي عقد اشتراك آخر من أية مبالغ مودعة لديها كما يجوز لها مصادرة أية كفالة ويتم رد أي رصيد، إن وجد، إلى المشترك.\n"),

                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Paying the subscription fees and expenses:\n":"دفع رسوم ونفقات الاشتراك\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"When signing the subscription contract, subscriber will pay the service subscription fees along with the additional services fees selected according to the tariff in effect established by Zain\n":"عند توقيع عقد الاشتراك، يقوم المشترك بدفع رسوم الاشتراك للخدمة ورسوم الخدمات الإضافية التي يختارها وفقاً للتعرفة النافذة من قبل زين.\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"The prepaid subscriber will fill his/her account using the charging methods allowed and/or available at the Sale Centers. However, each charging process will provide the subscriber with a specific number of communication hours as balance and which can be used during the validity period as explained in article (5) below.\n":"يقوم المشترك في حالات الدفع المسبق بتعبئة حسابه باستخدام وسائل الشحن المتاحة و/أو المتوفرة لدى مراكز البيع، هذا مع العلم ان كل عملية شحن توفر للمشترك رصيد محدد من ساعات الاتصال والتي يمكن استخدامها خلال فترة السريان كما هو موضح في المادة (5) أدناه.\n"),
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?"The charging card shall not be used more than once, nor may the subscribe use the charging methods for fraudulent, delusive purposes or that violates the prevailing legislations or morals. In this case, Zain may refrain from re-filling the subscriber’s account, and will reserve its right to terminate the contract or cancel the subscription and suspend service either on a temporary or permanent basis.\n":"لن يتم استعمال بطاقة الشحن لأكثر من مرة واحدة كما لا يجوز للمشترك استخدام وسائل الشحن لغايات احتيالية أو مضللة أو مخالفة للتشريعات النافذة أو الآداب العامة، وفي هذه الحالة فإن لزين الحق بالامتناع عن إعادة تعبئة حساب المشترك وتحتفظ زين بحقها في انهاء العقد أو الغاء الاشتراك وايقاف الخدمة مؤقتاً او بشكل دائم.\n"),








                            Divider(),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 0), // Add margin around the Row
                              child: Row(
                                children: [
                                  Switch(
                                    value: globalVars.termCondition1,
                                    onChanged: (value) {
                                      changeFirstSwitched(value);
                                    },
                                    activeTrackColor: ekycColors.buttonTertiary,
                                    activeColor: ekycColors.buttonPrimary,
                                    inactiveTrackColor: Color(0xFFbcbcbc),
                                  ),

                                  SizedBox(width: 5), // Add some space between the switch and the label
                                  Text("I Agree on contract rules and conditions",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12)), // Label for the switch
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Other child widgets can be added here if needed
                      ),

                    ),
                   /* Container(
                      margin: EdgeInsets.symmetric(horizontal: 10), // Add margin around the Row
                      child: Row(
                        children: [
                          Switch(
                            value: firstSwitch,
                            onChanged: (value) {
                              changeFirstSwitched(value);
                            },
                            activeTrackColor: ekycColors.buttonTertiary,
                            activeColor: ekycColors.buttonPrimary,
                            inactiveTrackColor: Color(0xFFbcbcbc),
                          ),

                          SizedBox(width: 10), // Add some space between the switch and the label
                          Text("I Agree on contract rules and conditions",style: TextStyle(fontWeight: FontWeight.bold)), // Label for the switch
                        ],
                      ),
                    ),*/


                    SizedBox(height: 25),

/*............................................................Second Terms............................................................*/

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")?"Approval on accessing his in formation through approved entites by Telecommunications Regulatory Commission":"الموافقة على التحقق من المعلومات من خلال الجهات الموافق عليها من قبل هيئة تنظيم قطاع الاتصالات",
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),// Set height as per your requirement
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(5.0), // Border radius
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
                          children: [
                            SizedBox(height: 20),
                            Text( EasyLocalization.of(context).locale == Locale("en", "US")?"I hereby my commitment to provide a valid verication ID and consent  to the inquiry and verification of my personal information through approved entities by Telecommunications Regulatory Commission & I know and agree that this agreement is true & follows the Electronic Transaction Law.":
                            "أؤكد بأني ملتزم بتقديم وثيقة تحقق صحة هويتي . و أعطي موافقتي الصريحة للفحص و التحقق من معلوماتي الشخصية من خلال الجهات الموافق عليها من قبل هيئة تنظيم قطاع الاتصالات و أنا اقر بأن هذا العقد صحيح و متوافق مع قوانين المعاملات الإلكترونية."),

                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 0), // Add margin around the Row
                              child: Row(
                                children: [
                                  Switch(
                                    value: globalVars.termCondition2,
                                    onChanged: (value) {
                                      changeSecondSwitched(value);
                                    },
                                    activeTrackColor: ekycColors.buttonTertiary,
                                    activeColor: ekycColors.buttonPrimary,
                                    inactiveTrackColor: Color(0xFFbcbcbc),
                                  ),
                                  SizedBox(width: 5), // Add some space between the switch and the label
                                  Text(EasyLocalization.of(context).locale == Locale("en", "US")?"I have read and agree to proceed":"أؤكد قبول الشروط و الاحكام و أرغب بالمتابعة.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),), // Label for the switch
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Other child widgets can be added here if needed
                      ),

                    ),
                   /* Container(
                      margin: EdgeInsets.symmetric(horizontal: 0), // Add margin around the Row
                      child: Row(
                        children: [
                          Switch(
                            value: secondSwitch,
                            onChanged: (value) {
                              changeSecondSwitched(value);
                            },
                            activeTrackColor: ekycColors.buttonTertiary,
                            activeColor: ekycColors.buttonPrimary,
                            inactiveTrackColor: Color(0xFFbcbcbc),
                          ),
                          SizedBox(width: 10), // Add some space between the switch and the label
                          Text("I Agree on contract rules and conditions",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),), // Label for the switch
                        ],
                      ),
                    ),*/


                  ],
                ),
              ],
            ),
            /*............................................................Next-Back Buttons............................................................*/
            // ✅ Fixed Next - Back Buttons at the Bottom
            bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            // Back Button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: ekycColors.buttonPrimary,
                ),
                onPressed: () {
                  setState(() {
                    if (globalVars.currentStep > 1) {
                      if(globalVars.goToTermCondition == true){
                        globalVars.currentStep -= 2;
                        widget.onStepChanged();
                        globalVars.selectedItemIndex = -1;
                        globalVars.reservedNumber = false;
                        globalVars.numberSelected="";
                        globalVars.referanceNumber = "";
                        globalVars.termCondition1 =false;
                        globalVars.termCondition2 =false;
                      }
                      if(globalVars.goToTermCondition == false){
                        globalVars.currentStep--;
                        widget.onStepChanged();
                        globalVars.selectedItemIndex = -1;
                        globalVars.reservedNumber = false;
                        globalVars.numberSelected="";
                        globalVars.referanceNumber = "";
                        globalVars.termCondition1 =false;
                        globalVars.termCondition2 =false;


                      }

                    } else {

                    }
                    widget.onStepChanged();
                    getScreen();
                    print("Back Step: ${globalVars.currentStep}");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white, size: 15),
                    SizedBox(width: 8),
                    Text(EasyLocalization.of(context).locale == Locale("en", "US")?'Back':"رجوع", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16), // Space between buttons

            // Next Button
            globalVars.termCondition1 &&  globalVars.termCondition2? Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: ekycColors.buttonPrimary,
                ),
                onPressed: () {
                  setState(() {

                    if ( globalVars.currentStep < 6) { // Ensure the last step is 5
                      globalVars.currentStep++;
                      widget.onStepChanged(); // Notify the parent widget to update value
                    }
                    getScreen();

                    print("Next Step: ${globalVars.currentStep}");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(EasyLocalization.of(context).locale == Locale("en", "US")?'Next':"التالي", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 15),
                  ],
                ),
              ),
            ):Expanded(child: Text("-",style: TextStyle(color: Colors.white),)),
          ],
        ),
      ),
        ),
      ),
      onWillPop: onWillPop,
    );
  }
}
