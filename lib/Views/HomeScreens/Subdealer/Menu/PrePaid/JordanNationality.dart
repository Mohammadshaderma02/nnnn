import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/PendingContracts/PendingContracts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:math';
import 'package:mime/mime.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/LineDocumentation.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/SelectNationlaity.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/UpdateLine.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/UpgradePackage/UpgradePackage_Bulk.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/JordainaianLookUp/LokkUpList_state.dart';
import 'package:sales_app/blocs/JordainaianLookUp/LookUpList_bloc.dart';
import 'package:sales_app/blocs/JordainaianLookUp/LookUpList_events.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_state.dart';
import 'package:sales_app/blocs/LookUpList/LokkUpList_state.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_bloc.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_events.dart';

import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


import '../../CustomBottomNavigationBar.dart';
class JordanianNotionality extends StatefulWidget {
  String msisdn;
  String kitCode;
  String ICCID;
  bool  isSahamah;
  bool displayReference;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  /****************New for Bulk********************/
  List bulkNumbers;
  bool Bulk_Activat;
  /***********************************************/
  JordanianNotionality(this.Permessions,this.role,this.outDoorUserName,this.msisdn,this.kitCode,this.ICCID,this.isSahamah,this.displayReference,
      this.bulkNumbers,
      this.Bulk_Activat);
  @override
  _JoranianNotionalityState createState() => _JoranianNotionalityState(this.Permessions,this.role,this.outDoorUserName,this.msisdn,this.kitCode,this.ICCID,this.isSahamah,this.displayReference,
      this.bulkNumbers,
      this.Bulk_Activat);
}

class Item {
  const Item(this.value, this.textEn, this.textAr);
  final String value;
  final String textEn;
  final String textAr;
}

List<Item> ARMY_TYPES = <Item>[];
List<Item> ARMY_REGISTERATION_TYPES = <Item>[];
List<Item> ARMY_RANKS= <Item>[Item('1', '1','RANKED')];
//List<Item> ARMY_RANKS= <Item>[];

class _JoranianNotionalityState  extends State<JordanianNotionality> {
  APP_URLS urls = new APP_URLS();
  String msisdn;
  String kitCode;
  String ICCID;
  bool isSahamah ;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  bool displayReference  ;
  /****************New for Bulk********************/
  List bulkNumbers;
  bool Bulk_Activat;
  String message;
  String messageAr;
  bool isLoading=false;
  /***********************************************/
  _JoranianNotionalityState(this.Permessions,this.role,this.outDoorUserName,this.msisdn,this.kitCode,this.ICCID,this.isSahamah,this.displayReference,
      this.bulkNumbers,
      this.Bulk_Activat);
  GetJordainainLookUpListBloc getLookUpListBloc;
  SubmitLineDocumentationRqBloc submitLineDocumentationRqBloc;
  TextEditingController NationalNumber = TextEditingController();
  TextEditingController IdNumber = TextEditingController();
  TextEditingController ReferenceNumber = TextEditingController();
  TextEditingController SecondReferenceNumber = TextEditingController();
  TextEditingController MilitaryId = TextEditingController();
  ////NEW API///////
  VerifyOTPSCheckMSISDNBloc verifyOTPSCheckMSISDNBloc;
  SendOTPSCheckMSISDNBloc sendOTPSCheckMSISDNBloc;
  TextEditingController otp = TextEditingController();
  bool showCircular = false;
  /////////////////
  bool emptyNationalNumber = false;
  bool errorNationalNumber =false;
  bool emptyIdNumber  = false;
  bool errorIdNumber = false;
  bool emptyReferenceNumber = false;
  bool emptySecondReferenceNumber=false;
  bool emptyMilitaryId = false;
  bool emptyArmyType = false;
  bool errorReferenceNumber =false;
  bool errorSecondReferenceNumber =false;
  bool emptyArmyRegisterationType = false;
  bool emptyArmyRank=false;
  String armyType;
  String armyRegistrationType;
  String armyRank="1";
  bool imageIDRequired = false;
  bool imageContractRequired = false;
  bool successFlag = false;
  bool successFlagSecondeReferancenumber=false;
  bool isDisabled=false;
  var entryDate ;
  /*...........................................Document Expiry Date.........................................*/
  bool emptyDocumentExpiryDate=false;
  TextEditingController documentExpiryDate = TextEditingController();
  DateTime Expiry_Date = DateTime.now();

  @override
  void initState() {
    getLookUpListBloc = BlocProvider.of<GetJordainainLookUpListBloc>(context);
    submitLineDocumentationRqBloc = BlocProvider.of<SubmitLineDocumentationRqBloc>(context);
    getLookUpListBloc.add(GetJordainainLookUpListFetchEvent());
    ARMY_RANKS.add(Item('1', '1','Ranked'));
    ///////NEW API///////
    verifyOTPSCheckMSISDNBloc = BlocProvider.of<VerifyOTPSCheckMSISDNBloc>(context);
    sendOTPSCheckMSISDNBloc = BlocProvider.of<SendOTPSCheckMSISDNBloc>(context);
    /////////////////////
    super.initState();
  }
  /*.................................................New 30/6/2023...............................................................*/

  void bulk_submit_API () async{
    setState(() {
      isLoading =true;

    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("i am here");


    Map test = {
      "bulkNumbers": bulkNumbers,
      "idImageBase64": img64,
      "contractImageBase64": img64Contract,
      "customerFirstName": '',
      "customerSecondName":'',
      "customerThirdName": '',
      "customerLastName":'',
      "customerHomeTel": ReferenceNumber.text,
      "customerHomeTel2": SecondReferenceNumber.text,
      "customerBirthDate": '',
      "customerNationality": '108',
      "customerNationalNumber": NationalNumber.text,
      "customerIdNumber": IdNumber.text
    };
    print(json.encode(test));
    String body = json.encode(test);
    var apiArea = urls.BASE_URL +'/LineDocumentation/bulk/submit';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if(statusCode==401 ){
      print('401  error ');
      setState(() {
        isLoading =false;
      });
    }
    if (statusCode == 200) {
      setState(() {
        isLoading =false;
      });

      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('----------------HAYA HAZAIMEH---------------');
      print(result["data"]);
      if(result["data"]==null){

      }
      if( result["status"]==0){
        print(result["data"]);
        showAlertDialogSubmitBulk(context);
        setState(() {
          isDisabled=false;
        });


      }else{
        setState(() {
          isLoading =false;
        });
        setState(() {
          message=result["message"];
          messageAr=result["messageAr"];
          isDisabled=false;
        });
        showAlertDialogErroreBulk(context);
      }


      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL +'/LineDocumentation/bulk/submit');

      return result;
    }else{
      setState(() {
        isLoading =false;

      });

    }





  }

  /*void bulk_submit_API () async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map test = {
      "bulkNumbers": [
        First_KitCode,Second_KitCode,Third_KitCode
      ],
      "idImageBase64": img64,
      "contractImageBase64": img64Contract,
      "customerFirstName": '',
      "customerSecondName":'',
      "customerThirdName": '',
      "customerLastName":'',
      "customerHomeTel": ReferenceNumber.text,
      "customerHomeTel2": SecondReferenceNumber.text,
      "customerBirthDate": '',
      "customerNationality": '108',
      "customerNationalNumber": NationalNumber.text,
      "customerIdNumber": IdNumber.text
    };
    print(json.encode(test));
    String body = json.encode(test);
    var apiArea = urls.BASE_URL +'/LineDocumentation/bulk/submit';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if(statusCode==401 ){
      print('401  error ');
    }
    if (statusCode == 200) {

      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('----------------HAYA HAZAIMEH---------------');
      print(result["data"]);
      if(result["data"]==null){

      }
      if( result["status"]==0){
        print(result["data"]);
        showAlertDialogSubmitBulk(context);
        setState(() {
          isDisabled=false;
        });


      }else{

        setState(() {
          message=result["message"];
          messageAr=result["messageAr"];
          isDisabled=false;
        });
        showAlertDialogErroreBulk(context);
      }


      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL +'/LineDocumentation/bulk/submit');

      return result;
    }else{


    }


  }*/

  showAlertDialogSubmitBulk(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Lines was documented successfully!"
            : "تم توثيق الخطوط بنجاح!",
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),

      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Do you want to change its package?"
            : "هل تريد تغيير الباقه؟",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomBottomNavigationBar(Permessions: Permessions,role:role,outDoorUserName: outDoorUserName,),
              ),
            );
          },
          child: Text(
            "alert.NoFinish".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Permessions.contains('05.01.01.01.03')?Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdatePackage_Bulk(Permessions,role,outDoorUserName,bulkNumbers),
              ),
            ):null;
          },
          child: Text(
            "alert.YesUpdate".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogErroreBulk(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Warning"
            : "تحذير",
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? message
            : messageAr,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  /*............................................................................................................................*/


  showAlertDialogSubmit(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Line was Documented Successfully!"
            : "تم توثيق الخط بنجاح!",
        style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
      ),
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Do you want to recharge your line or change its package?"
            : "هل تريد إعادة شحن خطك أو تغيير باقته؟",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomBottomNavigationBar(Permessions: Permessions,role:role,outDoorUserName: outDoorUserName,),
              ),
            );
          },
          child: Text(
            "alert.NoFinish".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(

          onPressed: () {
            setState(() {
              NationalNumber.text = '';
              ReferenceNumber.text = '';
              SecondReferenceNumber.text='';
              IdNumber.text = '';
              armyType = null;
              armyRegistrationType=null;
              armyRank = null;
              imageFileID=null;
              imageFileContract=null;

            });
            //  Navigator.pop(context);
            Permessions.contains('05.01.01.01.03')?Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateLine(Permessions,role,outDoorUserName,msisdn),
              ),
            ):null;
          },
          child: Text(
            "alert.YesUpdate".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        )
      ],
    );
    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String img64;
  String img64Contract;
  final _picker = ImagePicker();

  File imageFileID ;
  bool _loadId = false;
  var pickedFileId;


  File imageFileContract ;
  bool _loadContract = false;
  var pickedFileContract;

  int imageWidth=200;
  int imageHeight=200;


  void calculateImageSize (String path){
    Completer<Size> completer = Completer();
    Image image = Image.file(File(path));
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
          print("size = ${size}");
          print(size.height);
          print(size.width);
          print(size.aspectRatio);
          double ratio=0;
          if(size.height>size.width){
            ratio= (size.height / 1024);
          }else{
            ratio= (size.width / 1024);
          }


          setState(() {
            imageHeight= (size.height /ratio).toInt()  ;
            imageWidth=(size.width/ ratio).toInt() ;
          });
          print('ratio ${ratio}');
        },
      ),
    );
  }
  void pickImageCamera() async {
    pickedFileId = await _picker.pickImage(source: ImageSource.camera,

    );

    if(pickedFileId!=null){
      imageFileID = File(pickedFileId.path);
      _loadId = true;
      var imageName = pickedFileId.path
          .split('/')
          .last;
      print(pickedFileId);

      calculateImageSize(pickedFileId.path);
      if (pickedFileId != null) {
        _cropImage(File(pickedFileId.path));
      }
    }
  }
  void pickImageGallery() async {
    pickedFileId = await _picker.pickImage(source: ImageSource.gallery,

    );
    if(pickedFileId!=null) {
      imageFileID = File(pickedFileId.path);
      _loadId = true;
      var imageName = pickedFileId.path
          .split('/')
          .last;
      print(pickedFileId);

      print(pickedFileId.path);
      final bytes = File(pickedFileId.path)
          .readAsBytesSync()
          .lengthInBytes;
      calculateImageSize(pickedFileId.path);
      if (pickedFileId != null) {
        _cropImage(File(pickedFileId.path));
      }

    }
  }

  _cropImage(File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
        sourcePath: picture.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],
        compressQuality: 100,
        compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),
        maxWidth: imageWidth,
        maxHeight: imageHeight);
    if (cropped != null) {

      final File innerFile = File(cropped.path);
      final bytes = innerFile
          .readAsBytesSync()
          .lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {

            _loadId=false;
            pickedFileId=null;


          });
        }
        else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64 = base64Encode(base64Image);
          print('img64Crop: ${img64}');
          imageFileID= File(cropped.path);
        }
      });

    }
    else{
      this.setState(() {

        _loadId=false;
        pickedFileId=null;

        ///here
      });

    }
  }
  void clearImageID() {
    /* this.setState(()=>
    imageFileID = null );*/


    this.setState(() {

      _loadId=false;
      pickedFileId=null;

      ///here
    });
  }
  /////////////End ImageID Functions/////////////
  //** Pick & Crop & Clear --> "ImageContract"  Camera/Gallery  **//

  void pickImageContractCamera() async {

    pickedFileContract = await _picker.pickImage(source: ImageSource.camera,

    );


    if(pickedFileContract!=null) {
      imageFileContract = File(pickedFileContract.path);
      _loadContract = true;
      var imageName = pickedFileContract.path
          .split('/')
          .last;
      print(pickedFileContract);

      print(pickedFileContract.path);
      final bytes = File(pickedFileContract.path)
          .readAsBytesSync()
          .lengthInBytes;
      calculateImageSize(pickedFileContract.path);
      if (pickedFileContract != null) {
        _cropImageContract(File(pickedFileContract.path));
      }

    }
  }
  void pickImageContractGallery() async {
    pickedFileContract = await _picker.pickImage(source: ImageSource.gallery,

    );


    if(pickedFileContract!=null) {
      imageFileContract = File(pickedFileContract.path);
      _loadContract = true;
      var imageName = pickedFileContract.path
          .split('/')
          .last;
      print(pickedFileContract);

      print(pickedFileContract.path);
      final bytes = File(pickedFileContract.path)
          .readAsBytesSync()
          .lengthInBytes;
      calculateImageSize(pickedFileContract.path);
      if (pickedFileContract != null) {
        _cropImageContract(File(pickedFileContract.path));
      }

    }
  }

  _cropImageContract(File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
        sourcePath: picture.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],
        compressQuality: 100,
        compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),
        maxWidth:imageWidth,
        maxHeight: imageHeight);
    if (cropped != null) {

      final File innerFile = File(cropped.path);
      final bytes = innerFile
          .readAsBytesSync()
          .lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {

            _loadContract=false;
            pickedFileContract=null;


          });
        }
        else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Contract = base64Encode(base64Image);
          print('img64Crop: ${img64Contract}');
          imageFileContract= File(cropped.path);
        }
      });

    }
    else{
      this.setState(() {

        _loadContract=false;
        pickedFileContract=null;

        ///here
      });

    }
  }
  void clearImageContract() {
    this.setState(() {

      _loadContract=false;
      pickedFileContract=null;

      ///here
    });

  }
  void clearField() {
    setState(() {
      IdNumber.text='';
    });
  }

  /////////////End ImageContract Functions/////////////
  _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Make a Choice!',
                style: TextStyle(
                    color: Color(0xff11120e),
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
            content: SingleChildScrollView(
              child: Column(children: [
                Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: new Text(
                            "Jordan_Nationality.open_camera".tr().toString(),
                            style:
                            TextStyle(color: Color(0xff11120e), fontSize: 14),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_size_select_actual_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: new Text(
                            "Jordan_Nationality.Choose_photos".tr().toString(),
                            style:
                            TextStyle(color: Color(0xff11120e), fontSize: 14),
                          ),
                        ),
                      ],
                    )),
              ]),
            ),
          );
        });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: new ListTile(
                      leading: new Text(
                        "Jordan_Nationality.select_option".tr().toString(),
                        style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: new IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Color(0xFF747E8D),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageCamera();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.open_camera".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageGallery();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.photo_size_select_actual_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.Choose_photos".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
        });
  }
  void _showPickerContarct(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: new ListTile(
                      leading: new Text(
                        "Jordan_Nationality.select_option".tr().toString(),
                        style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: new IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Color(0xFF747E8D),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageContractCamera();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.open_camera".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageContractGallery();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.photo_size_select_actual_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.Choose_photos".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
        });
  }

  SendOtp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(urls.BASE_URL+"/OTP/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode( {"msisdn": ReferenceNumber.text}), );

    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200 ) {
      print("haya");
      var result = json.decode(res.body);
      if(result['status']==0){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("CustomerService.verify_code".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 16,
              ),
            ),
            content: Container(
              width: double.maxFinite,
              height:  showCircular ? 170 :110,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        child: ListView(
                          // shrinkWrap: false,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [

                              SizedBox(
                                width: double.maxFinite,
                                height: 50,
                                child: ListTile(
                                  contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  title: Text("CustomerService.enter_OTP".tr().toString(),
                                    style: TextStyle(
                                      color: Color(0xff11120e),
                                      fontSize: 16,
                                    ),
                                  ),

                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: ListTile(
                                  contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 4),
                                  title:
                                  TextField(
                                    controller: otp,
                                    keyboardType: TextInputType.phone,
                                    decoration:InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: const BorderSide(
                                            color: Color(0xFFD1D7E0), width: 1.0),
                                      ),
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Color(0xFF4F2565), width: 1.0),
                                      ),
                                      contentPadding: EdgeInsets.all(16),
                                      hintText: "CustomerService.verify_hint".tr().toString(),
                                      hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),

                                    ),
                                  ),


                                ),
                              ),
                              msgTwo
                            ]
                        )
                    )
                  ]
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  ReferenceNumber.clear();
                  // Navigator.of(context).pop();
                  Navigator.pop(context, true);

                },
                child:  Text("CustomerService.Cancel".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFF4f2565),
                    fontSize: 16,
                  ),
                ),

              ),
              BlocListener<VerifyOTPSCheckMSISDNBloc, VerifyOTPSCheckMSISDNState>(
                listener: (context,state){
                  if(state is VerifyOTPSCheckMSISDNLoadingState){
                    setState(() {
                      showCircular=true;
                    });
                  }
                  if (state is VerifyOTPSCheckMSISDNErrorState) {
                    setState(() {
                      showCircular=false;
                    });
                    setState(() {
                      otp.text='';
                    });
                    showAlertDialogVerify(context, state.arabicMessage, state.englishMessage);
                    // Navigator.of(context).pop();
                  }
                  if (state is VerifyOTPSCheckMSISDNSuccessState) {
                    setState(() {
                      showCircular=false;
                    });
                    //Navigator.of(context).pop();
                    setState(() {
                      otp.text='';
                      successFlag=true;
                    });
                    Navigator.pop(context, true);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ActiveAndEligiblePackages(
                    //         EasyLocalization.of(context).locale == Locale("en", "US")
                    //             ? arabicName
                    //             : englishName,msisdn.text,enableMsisdn),
                    //   ),
                    // );
                    //  getCurrentPackageBloc.add(GetCurrentPackageButtonPressed(msisdn.text));

                    // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Service(numberService)));
                  }
                },
                child:TextButton(
                  onPressed: () {
                    // Navigator.of(ctx).pop();
                    verifyOTPSCheckMSISDNBloc.add(VerifyOTPSCheckMSISDNPressed(msisdn:ReferenceNumber.text, otp: otp.text));
                    //Navigator.of(ctx).pop();

                  },
                  child:  Text("CustomerService.verify".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      fontSize: 16,
                    ),
                  ),

                ),
              ),
            ],
          ),
        );
      }
    }
  }

  SendOtpSecondReferenceNumber() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(urls.BASE_URL+"/OTP/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode( {"msisdn": SecondReferenceNumber.text}), );

    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200 ) {
      var result = json.decode(res.body);
      if(result['status']==0){
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("CustomerService.verify_code".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 16,
              ),
            ),
            content: Container(
              width: double.maxFinite,
              height:  showCircular ? 170 :110,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        child: ListView(
                          // shrinkWrap: false,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [

                              SizedBox(
                                width: double.maxFinite,
                                height: 50,
                                child: ListTile(
                                  contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  title: Text("CustomerService.enter_OTP".tr().toString(),
                                    style: TextStyle(
                                      color: Color(0xff11120e),
                                      fontSize: 16,
                                    ),
                                  ),

                                ),
                              ),
                              SizedBox(
                                height: 50,
                                child: ListTile(
                                  contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 4),
                                  title:
                                  TextField(
                                    controller: otp,
                                    keyboardType: TextInputType.phone,
                                    decoration:InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                        borderSide: const BorderSide(
                                            color: Color(0xFFD1D7E0), width: 1.0),
                                      ),
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Color(0xFF4F2565), width: 1.0),
                                      ),
                                      contentPadding: EdgeInsets.all(16),
                                      hintText: "CustomerService.verify_hint".tr().toString(),
                                      hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),

                                    ),
                                  ),


                                ),
                              ),
                              msgTwo
                            ]
                        )
                    )
                  ]
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  SecondReferenceNumber.clear();
                  // Navigator.of(context).pop();
                  Navigator.pop(context, true);

                },
                child:  Text("CustomerService.Cancel".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFF4f2565),
                    fontSize: 16,
                  ),
                ),

              ),
              BlocListener<VerifyOTPSCheckMSISDNBloc, VerifyOTPSCheckMSISDNState>(
                listener: (context,state){
                  if(state is VerifyOTPSCheckMSISDNLoadingState){
                    setState(() {
                      showCircular=true;
                    });
                  }
                  if (state is VerifyOTPSCheckMSISDNErrorState) {
                    setState(() {
                      showCircular=false;
                    });
                    setState(() {
                      otp.text='';
                    });
                    showAlertDialogVerify(context, state.arabicMessage, state.englishMessage);
                    // Navigator.of(context).pop();
                  }
                  if (state is VerifyOTPSCheckMSISDNSuccessState) {
                    setState(() {
                      showCircular=false;
                    });
                    //Navigator.of(context).pop();
                    setState(() {
                      otp.text='';
                      successFlagSecondeReferancenumber=true;
                    });
                    Navigator.pop(context, true);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ActiveAndEligiblePackages(
                    //         EasyLocalization.of(context).locale == Locale("en", "US")
                    //             ? arabicName
                    //             : englishName,msisdn.text,enableMsisdn),
                    //   ),
                    // );
                    //  getCurrentPackageBloc.add(GetCurrentPackageButtonPressed(msisdn.text));

                    // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Service(numberService)));
                  }
                },
                child:TextButton(
                  onPressed: () {
                    // Navigator.of(ctx).pop();
                    //jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
                    verifyOTPSCheckMSISDNBloc.add(VerifyOTPSCheckMSISDNPressed(msisdn:SecondReferenceNumber.text, otp: otp.text));
                    //Navigator.of(ctx).pop();

                  },
                  child:  Text("CustomerService.verify".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      fontSize: 16,
                    ),
                  ),

                ),
              ),
            ],
          ),
        );
      }
    }
  }
  showAlertDialogVerify(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.pop(context, true);
        // Navigator.pop(context, true);
        otp.clear();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        tryAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  final msgTwo = BlocBuilder<VerifyOTPSCheckMSISDNBloc, VerifyOTPSCheckMSISDNState>(builder: (context, state) {
    if (state is VerifyOTPSCheckMSISDNLoadingState ) {
      return Center(child: Container(
        padding: EdgeInsets.only(bottom: 0,top: 20),
        child: Container(
          child: CircularProgressIndicator(
            valueColor:AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
          ),
        ),
      ));
    } else {
      return Container();
    }
  });
  final msg = BlocBuilder<SubmitLineDocumentationRqBloc, SubmitLineDocumentationRqState>(builder: (context, state) {
    if (state is SubmitLineDocumentationRqLoadingState   ) {
      return Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
            ),
          ));
    } else {
      return Container();
    }
  });
  Widget buildDashedBorder({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

  /*.................................................Document Expiry .........................................................*/
  Widget buildDocumentExpiryDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? "Document Expiry Date"
                : "تاريخ انتهاء الوثيقة",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Color(0xFFB10000),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            controller: documentExpiryDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder: emptyDocumentExpiryDate == true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              )
                  : const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/icon-calendar.png"),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        // firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 60),
                        initialDate: DateTime.now(),
                        lastDate:DateTime(DateTime.now().year+20,
                        ),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF4f2565), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary:
                                  Color(0xFF4f2565), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((fromData) => {
                        setState(() {
                          Expiry_Date = fromData;
                          documentExpiryDate.text =
                          "${fromData.day.toString().padLeft(2, '0')}/${fromData.month.toString().padLeft(2, '0')}/${fromData.year.toString()}";
                        }),
                      });
                    }),
              ),
              hintText:  EasyLocalization.of(context).locale ==
                  Locale("en", "US")
                  ? "dd/mm/yyyy":"يوم/شهر/سنة",
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
    return BlocListener<SubmitLineDocumentationRqBloc,SubmitLineDocumentationRqState>(
      listener: (context, state) {
        if (state is SubmitLineDocumentationRqErrorState) {
          setState(() {
            isDisabled=false;
            isLoading=false;
          });
          showAlertDialogError(
              context, state.arabicMessage, state.englishMessage);
        }
        if (state is SubmitLineDocumentationRqSuccessState) {
          showAlertDialogSubmit(context);
          setState(() {
            isDisabled=false;
            isLoading=false;
          });

        }
      },
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //tooltip: 'Menu Icon',
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => SelectNationality(msisdn,kitCode,isSahamah,displayReference),
                //   ),
                // );
              },
            ),
            title: Text("Jordan_Nationality.jordan_nationality".tr().toString()),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left:16,right:16,top: 16,bottom: 16),
              child: Center(
                child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: [

                      SizedBox(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: "Jordan_Nationality.national_number".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' * ',
                                    style: TextStyle(
                                      color: Color(0xFFB10000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),

                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 58,
                              child: TextField(
                                controller: NationalNumber,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Color(0xff11120e)),
                                decoration: InputDecoration(
                                  enabledBorder: emptyNationalNumber == true || errorNationalNumber==true
                                      ? const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB10000), width: 1.0),
                                  )
                                      : const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D7E0), width: 1.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Color(0xFF4F2565), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  hintText: "Jordan_Nationality.enter_national_number".tr().toString(),
                                  hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      emptyNationalNumber==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      errorNationalNumber==true
                          ? ReusableRequiredText(
                          text:  EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "Your National number shoud be 10 digit"
                              : "الرقم الوطني يجب أن يتكون من 10 خانات ")
                          : Container(),
                      SizedBox(height: 20,),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: "Jordan_Nationality.id_number".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' * ',
                                    style: TextStyle(
                                      color: Color(0xFFB10000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 58,
                              child: TextField(
                                controller: IdNumber,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Color(0xff11120e)),
                                decoration: InputDecoration(
                                  enabledBorder: emptyIdNumber == true || errorIdNumber==true
                                      ? const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB10000), width: 1.0),
                                  )
                                      : const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D7E0), width: 1.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Color(0xFF4F2565), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  hintText: "Jordan_Nationality.enter_id_number".tr().toString(),
                                  hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                                  suffixIcon: IconButton(
                                    onPressed: clearField,
                                    icon: Icon(
                                        Icons.close
                                    ),
                                    color: Color(0xFFA4B0C1),
                                  ),
                                ),

                              ),
                            )
                          ],
                        ),

                      ),
                      emptyIdNumber==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      errorIdNumber == true
                          ? ReusableRequiredText(
                          text:  EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "Your ID number should be less than or equal 8 digit"
                              : "رقم الهويه يجب أن يتكون من 8 خانات أو أقل ")
                          : Container(),
                      displayReference==true?  SizedBox(height: 20,):Container(),
                      displayReference==true? SizedBox(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text:  "Jordan_Nationality.reference_number".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' * ',
                                    style: TextStyle(
                                      color: Color(0xFFB10000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 58,
                              child:  TextField(
                                controller: ReferenceNumber,
                                maxLength: 10,
                                /*onChanged:(text) {
                                  text.length == 10 ?
                                  SendOtp() : null;

                                },*/
                                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                                keyboardType: TextInputType.phone,
                                /*    inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp('[a-z A-Z á-ú Á-Ú]')),
                                ],*/
                                style: TextStyle(color: Color(0xff11120e)),
                                decoration: InputDecoration(
                                  enabledBorder: emptyReferenceNumber == true || errorReferenceNumber==true
                                      ? const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB10000), width: 1.0),
                                  )
                                      : const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D7E0), width: 1.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Color(0xFF4F2565), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  hintText: "Jordan_Nationality.enter_reference_number".tr().toString(),
                                  hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ):Container(),

                      displayReference ==true && emptyReferenceNumber==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      displayReference == true && errorReferenceNumber==true
                          ? ReusableRequiredText(
                          text:  EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "Your MSISID shoud be 10 digit and start with 079"
                              : "رقم الهاتف يجب أن يتكون من 10 خانات ويبدأ ب 079")
                          : Container(),

                      /*   successFlag == true?  SizedBox(
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child:
                                        new Icon(
                                          Icons.assignment_turned_in, size: 14,
                                          color: Color(0xFF4BB543),
                                        ),
                                      ),
                                      TextSpan(
                                        text:"Jordan_Nationality.Verify_Number_Successfully".tr().toString(),
                                        style: TextStyle(
                                          color: Color(0xFF4BB543),
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]
                          )):Container(),
                      // reference number 2
                      SizedBox(height: 10),
                      displayReference==true? SizedBox(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text:  "Jordan_Nationality.Secondreference_number".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),

                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 58,
                              child:  TextField(
                                controller: SecondReferenceNumber,
                                maxLength: 10,
                                onChanged:(text) {
                                  text.length == 10 ?
                                  SendOtpSecondReferenceNumber() : null;

                                },
                                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                                keyboardType: TextInputType.phone,
                                *//*    inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp('[a-z A-Z á-ú Á-Ú]')),
                                ],*//*
                                style: TextStyle(color: Color(0xff11120e)),
                                decoration: InputDecoration(
                                  enabledBorder: emptySecondReferenceNumber == true || errorSecondReferenceNumber==true
                                      ? const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB10000), width: 1.0),
                                  )
                                      : const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D7E0), width: 1.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Color(0xFF4F2565), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  hintText: "Jordan_Nationality.enter_reference_number".tr().toString(),
                                  hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ):Container(),

                      displayReference == true && errorSecondReferenceNumber==true
                          ? ReusableRequiredText(
                          text:  EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "Your MSISID shoud be 10 digit and start with 079"
                              : "رقم الهاتف يجب أن يتكون من 10 خانات ويبدأ ب 079")
                          : Container(),
                      successFlagSecondeReferancenumber == true?  SizedBox(
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child:
                                        new Icon(
                                          Icons.assignment_turned_in, size: 14,
                                          color: Color(0xFF4BB543),
                                        ),
                                      ),
                                      TextSpan(
                                        text:"Jordan_Nationality.Verify_Number_Successfully".tr().toString(),
                                        style: TextStyle(
                                          color: Color(0xFF4BB543),
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]
                          )):Container(),*/

                      ///////


                      isSahamah==true ?SizedBox(height: 20,):Container(),
                      isSahamah==true? SizedBox(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text:  "Jordan_Nationality.militaryId".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' * ',
                                    style: TextStyle(
                                      color: Color(0xFFB10000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),

                            Container(
                              alignment: Alignment.centerLeft,
                              height: 58,
                              child:  TextField(
                                controller: MilitaryId,
                                keyboardType: TextInputType.name,
                                style: TextStyle(color: Color(0xff11120e)),
                                decoration: InputDecoration(
                                  enabledBorder: emptyMilitaryId == true
                                      ? const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB10000), width: 1.0),
                                  )
                                      : const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D7E0), width: 1.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    const BorderSide(color: Color(0xFF4F2565), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  hintText: "Jordan_Nationality.enter_militaryId".tr().toString(),
                                  hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ):Container(),
                      isSahamah ==true && emptyMilitaryId==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      isSahamah==true? SizedBox(height: 20,):Container(),
                      isSahamah==true? SizedBox(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text:  "Jordan_Nationality.army_types".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' * ',
                                    style: TextStyle(
                                      color: Color(0xFFB10000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            BlocBuilder<GetJordainainLookUpListBloc, GetJordainainLookUpListState>(
                                builder: (context, state) {
                                  if (state is GetJordainainLookUpListSuccessState ||
                                      state is GetJordainainLookUpListLoadingState ||
                                      state is GetJordainainLookUpListListErrorState) {
                                    ARMY_TYPES = [];
                                    if (state is GetJordainainLookUpListSuccessState) {
                                      ARMY_TYPES = [];
                                      for (var obj in state.data[0]['value']['data']) {
                                        ARMY_TYPES.add(Item(obj['key'], obj['value'].toString(),
                                            obj['valueAr'].toString()));
                                      }

                                    }
                                    return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            //color: Color(0xFFB10000), red color
                                            color: emptyArmyType == true
                                                ? Color(0xFFB10000)
                                                : Color(0xFFD1D7E0),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              disabledHint:Text(
                                                "Jordan_Nationality.select_option".tr().toString(),
                                                style: TextStyle(
                                                  color: Color(0xFFA4B0C1),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              hint: Text(
                                                "Jordan_Nationality.select_option".tr().toString(),
                                                style: TextStyle(
                                                  color: Color(0xFFA4B0C1),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              dropdownColor: Colors.white,
                                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                                              iconSize: 30,
                                              iconEnabledColor: Colors.grey,
                                              underline: SizedBox(),
                                              isExpanded: true,
                                              style: TextStyle(
                                                color: Color(0xFF11120e),
                                                fontSize: 14,
                                              ),
                                              value: armyType,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  armyType = newValue;
                                                });
                                              },
                                              items: ARMY_TYPES.map((valueItem) {
                                                return DropdownMenuItem<String>(
                                                  value: valueItem.value,
                                                  child: EasyLocalization.of(context).locale ==
                                                      Locale("en", "US")
                                                      ? Text(valueItem.textEn)
                                                      : Text(valueItem.textAr),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ));
                                  } else {
                                    return Container();
                                  }
                                }),
                            SizedBox(height: 5),
                          ],
                        ),
                      ):Container(),
                      isSahamah==true && emptyArmyType==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      isSahamah==true? SizedBox(height: 20,):Container(),
                      isSahamah==true?SizedBox(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text:  "Jordan_Nationality.army_registeration_types".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' * ',
                                    style: TextStyle(
                                      color: Color(0xFFB10000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),

                            BlocBuilder<GetJordainainLookUpListBloc, GetJordainainLookUpListState>(
                                builder: (context, state) {
                                  if (state is GetJordainainLookUpListSuccessState ||
                                      state is GetJordainainLookUpListLoadingState ||
                                      state is GetJordainainLookUpListListErrorState) {
                                    ARMY_REGISTERATION_TYPES = [];
                                    if (state is GetJordainainLookUpListSuccessState) {
                                      ARMY_REGISTERATION_TYPES = [];
                                      for (var obj in state.data[1]['value']['data']) {
                                        ARMY_REGISTERATION_TYPES.add(Item(obj['key'], obj['value'].toString(),
                                            obj['valueAr'].toString()));
                                      }

                                    }
                                    return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            //color: Color(0xFFB10000), red color
                                            color: emptyArmyRegisterationType == true
                                                ? Color(0xFFB10000)
                                                : Color(0xFFD1D7E0),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              disabledHint:Text(
                                                "Jordan_Nationality.select_option".tr().toString(),
                                                style: TextStyle(
                                                  color: Color(0xFFA4B0C1),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              hint: Text(
                                                "Jordan_Nationality.select_option".tr().toString(),
                                                style: TextStyle(
                                                  color: Color(0xFFA4B0C1),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              dropdownColor: Colors.white,
                                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                                              iconSize: 30,
                                              iconEnabledColor: Colors.grey,
                                              underline: SizedBox(),
                                              isExpanded: true,
                                              style: TextStyle(
                                                color: Color(0xFF11120e),
                                                fontSize: 14,
                                              ),
                                              value: armyRegistrationType,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  armyRegistrationType = newValue;
                                                });
                                              },
                                              items: ARMY_REGISTERATION_TYPES.map((valueItem) {
                                                return DropdownMenuItem<String>(
                                                  value: valueItem.value,
                                                  child: EasyLocalization.of(context).locale ==
                                                      Locale("en", "US")
                                                      ? Text(valueItem.textEn)
                                                      : Text(valueItem.textAr),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ));
                                  } else {
                                    return Container();
                                  }
                                }),
                            SizedBox(height: 5),
                          ],
                        ),
                      ):Container(),
                      isSahamah==true && emptyArmyRegisterationType==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      isSahamah==true? SizedBox(height: 20,):Container(),
                      isSahamah==true? SizedBox(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text:  "Jordan_Nationality.army_ranks".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' * ',
                                    style: TextStyle(
                                      color: Color(0xFFB10000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            BlocBuilder<GetJordainainLookUpListBloc, GetJordainainLookUpListState>(
                                builder: (context, state) {
                                  if (state is GetJordainainLookUpListSuccessState ||
                                      state is GetJordainainLookUpListLoadingState ||
                                      state is GetJordainainLookUpListListErrorState) {
                                    ARMY_RANKS= [];
                                    if (state is GetJordainainLookUpListSuccessState) {
                                      ARMY_RANKS = [];
                                      for (var obj in state.data[2]['value']['data']) {
                                        ARMY_RANKS.add(Item(obj['key'], obj['value'].toString(),
                                            obj['valueAr'].toString()));
                                      }

                                    }
                                    return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            //color: Color(0xFFB10000), red color
                                            color: emptyArmyRank == true
                                                ? Color(0xFFB10000)
                                                : Color(0xFFD1D7E0),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              disabledHint:Text(
                                                "Jordan_Nationality.select_option".tr().toString(),
                                                style: TextStyle(
                                                  color: Color(0xFFA4B0C1),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              hint: Text(
                                                "Jordan_Nationality.select_option".tr().toString(),
                                                style: TextStyle(
                                                  color: Color(0xFFA4B0C1),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              dropdownColor: Colors.white,
                                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                                              iconSize: 30,
                                              iconEnabledColor: Colors.grey,
                                              underline: SizedBox(),
                                              isExpanded: true,
                                              style: TextStyle(
                                                color: Color(0xFF11120e),
                                                fontSize: 14,
                                              ),
                                              value:armyRank,
                                              // value:  ARMY_RANKS[0].value,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  armyRank = newValue;
                                                });
                                              },
                                              items:[
                                                DropdownMenuItem(
                                                  child: Text( 'Ranked'),
                                                  value: '1',
                                                ),
                                                DropdownMenuItem(
                                                    child: Text( "Non Ranked"),
                                                    value: '2'
                                                )
                                              ],
                                              // items: ARMY_RANKS.map((valueItem) {
                                              //   return DropdownMenuItem<String>(
                                              //     value: valueItem.value,
                                              //     child: EasyLocalization.of(context).locale ==
                                              //         Locale("en", "US")
                                              //         ? Text(valueItem.textEn)
                                              //         : Text(valueItem.textAr),
                                              //   );
                                              // }).toList(),
                                            ),
                                          ),
                                        ));
                                  } else {
                                    return Container();
                                  }
                                }),
                            SizedBox(height: 5),
                          ],
                        ),
                      ):Container(),
                      isSahamah==true && emptyArmyRank==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      SizedBox(height: 20,),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildDocumentExpiryDate(),
                          ],
                        ),
                      )
                    ]),
              ),
            ),
            Container(
              height: 60,
              padding: EdgeInsets.only(top: 8),
              child: ListTile(
                leading: Container(
                  width: 280,
                  child: Text(
                    "Jordan_Nationality.id_photo".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF11120e),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing: _loadId == true
                    ? Container(
                  child: IconButton(
                      icon: Icon(Icons.delete),
                      color: Color(0xff0070c9),
                      onPressed: () => {clearImageID()}),
                )
                    : null,
              ),
            ),
            Container(
              color: Colors.white,
              height: 188,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Center(
                child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        // color: Colors.amber,
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: _loadId == true
                            ? Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 170,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                        image: FileImage(imageFileID),
                                        fit: BoxFit.cover,
                                      )),
                                  child: new Row(children: <Widget>[
                                    Center(
                                      child: new Column(
                                        children: <Widget>[
                                          new Container(
                                            padding: EdgeInsets.only(
                                                top: 25, left: 70, right: 70),
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/images/iconCheck.png'),
                                              fit: BoxFit.cover,
                                              height: 24.0,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          new Container(
                                            child: GestureDetector(
                                              onTap: () async {
                                                FocusScope.of(context).unfocus();
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => Center(
                                                      // Aligns the container to center
                                                        child: Container(
                                                          //color: Colors.deepOrange.withOpacity(0.5),
                                                          child: PhotoView(
                                                            enableRotation:
                                                            true,
                                                            backgroundDecoration:
                                                            BoxDecoration(),
                                                            imageProvider:
                                                            FileImage(
                                                                imageFileID),
                                                          ),
                                                          // A simplified version of dialog.
                                                          width: 300.0,
                                                          height: 350.0,
                                                        )));
                                              },
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Jordan_Nationality.preview_photo"
                                                      .tr()
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFFffffff),
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  width: 170,
                                  padding: EdgeInsets.only(top: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      _showPicker(context);
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Jordan_Nationality.re_take_photo"
                                            .tr()
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF0070c9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                            : buildDashedBorder(
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _showPicker(context);
                            },
                            child: Container(
                              width: 170,
                              height: 110,
                              child: GestureDetector(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: EasyLocalization.of(context)
                                      .locale ==
                                      Locale("en", "US")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Jordan_Nationality.take_photo1"
                                            .tr()
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF0070c9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Jordan_Nationality.take_photo2"
                                            .tr()
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF0070c9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  )
                                      : Text(
                                    "Jordan_Nationality.take_photo1"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(width: 10),
                    ],
                  ),
                  imageIDRequired == true
                      ? ReusableRequiredText(
                      text: "Jordan_Nationality.this_feild_is_required".tr().toString())
                      : Container(),
                ]),
              ),
            ),
            //contractPhoto
            Container(
              height: 60,
              padding: EdgeInsets.only(top: 8),
              child: ListTile(
                leading: Container(
                  width: 280,
                  child: Text(
                    "Jordan_Nationality.contract_photo".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF11120e),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing: _loadContract == true
                    ? Container(
                  child: IconButton(
                      icon: Icon(Icons.delete),
                      color: Color(0xff0070c9),
                      onPressed: () => {clearImageContract()}),
                )
                    : null,
              ),
            ),
            Container(
              color: Colors.white,
              height: 313,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Center(
                child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        // color: Colors.amber,
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: _loadContract == true
                            ? Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 180,
                                  height: 235,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                        image: FileImage(imageFileContract),
                                        fit: BoxFit.cover,
                                      )),
                                  child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: new Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              new Container(
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/images/iconCheck.png'),
                                                  fit: BoxFit.cover,
                                                  height: 24.0,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              new Container(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    FocusScope.of(context).unfocus();
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            Center(
                                                              // Aligns the container to center
                                                                child:
                                                                Container(
                                                                  child:
                                                                  PhotoView(
                                                                    enableRotation:
                                                                    true,
                                                                    backgroundDecoration:
                                                                    BoxDecoration(
                                                                        color:
                                                                        Colors.transparent),
                                                                    imageProvider:
                                                                    FileImage(
                                                                        imageFileContract),
                                                                  ),
                                                                  // A simplified version of dialog.
                                                                  width: 310.0,
                                                                  height: 500.0,
                                                                )));
                                                  },
                                                  child: Align(
                                                    alignment:
                                                    Alignment.center,
                                                    child: Text(
                                                      "Jordan_Nationality.preview_photo"
                                                          .tr()
                                                          .toString(),
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                        Color(0xFFffffff),
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  width: 170,
                                  padding: EdgeInsets.only(top: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      _showPickerContarct(context);
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Jordan_Nationality.re_take_photo"
                                            .tr()
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF0070c9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                            : buildDashedBorder(
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _showPickerContarct(context);
                            },
                            child: Container(
                              width: 180,
                              height: 235,
                              child: GestureDetector(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: EasyLocalization.of(context)
                                        .locale ==
                                        Locale("en", "US")
                                        ? Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Jordan_Nationality.take_photo1"
                                              .tr()
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF0070c9),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Jordan_Nationality.take_photo2"
                                              .tr()
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF0070c9),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    )
                                        : Text(
                                      "Jordan_Nationality.take_photo1"
                                          .tr()
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0070c9),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      //SizedBox(width: 10),
                    ],
                  ),
                  imageContractRequired == true
                      ? ReusableRequiredText(
                      text: "Jordan_Nationality.this_feild_is_required".tr().toString())
                      : Container(),
                ]),
              ),
            ),
            SizedBox(height: 30),
            msg,
            Container(
                height: 48,
                width: 300,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color:isLoading?Colors.transparent: Color(0xFF4f2565),
                ),
                child: TextButton(

                  onPressed:isLoading==true?null: () async {
                   /* setState(() {
                      isLoading =true;
                    });*/
                    print(armyRank);
                    if(NationalNumber.text==''){
                      setState(() {
                        emptyNationalNumber=true;
                      });
                    }
                    if(NationalNumber.text!=''){
                      setState(() {
                        emptyNationalNumber=false;
                      });
                      if(NationalNumber.text.length!=10
                      ){
                        setState(() {
                          errorNationalNumber = true;
                        });
                      }
                    }
                    if(IdNumber.text==''){
                      setState(() {
                        emptyIdNumber=true;
                      });
                    }
                    if(IdNumber.text!=''){
                      setState(() {
                        emptyIdNumber=false;
                      });
                      if(IdNumber.text.length>8
                      ){
                        setState(() {
                          errorIdNumber = true;
                        });
                      }
                    }
                    if(displayReference==true){
                      /* if(ReferenceNumber.text==''){
                        setState(() {
                          emptyReferenceNumber=true;
                        });
                      }*/
                      if(ReferenceNumber.text!=''){
                        setState(() {
                          emptyReferenceNumber=false;
                        });
                        if(ReferenceNumber.text.length!=10  || ReferenceNumber.text.substring(0,3)!='079'
                        ){
                          setState(() {
                            errorReferenceNumber = true;
                          });
                        }else {
                          setState(() {
                            errorReferenceNumber = false;
                          });
                        }
                      }
//new
                      if(SecondReferenceNumber.text != ''){
                        if(SecondReferenceNumber.text.length!=10  || SecondReferenceNumber.text.substring(0,3)!='079'
                        ){
                          setState(() {
                            errorSecondReferenceNumber = true;
                          });
                        }else {
                          setState(() {
                            errorSecondReferenceNumber = false;
                          });
                        }
                      }


                    }

                    if(isSahamah==true){
                      if(MilitaryId.text==''){
                        setState(() {
                          emptyMilitaryId=true;
                        });
                      }
                      if(MilitaryId.text!=''){
                        setState(() {
                          emptyMilitaryId=false;
                        });
                      }
                      if(armyType==null){
                        setState(() {
                          emptyArmyType=true;
                        });
                      }
                      if(armyType!=null){
                        setState(() {
                          emptyArmyType=false;
                        });
                      }
                      if(armyRegistrationType==null){
                        setState(() {
                          emptyArmyRegisterationType=true;
                        });
                      }
                      if(armyRegistrationType!=null){
                        setState(() {
                          emptyArmyRegisterationType=false;
                        });
                      }
                      if(armyRank==null){
                        setState(() {
                          emptyArmyRank=true;
                        });
                      }
                      if(armyRank!=null){
                        setState(() {
                          emptyArmyRank=false;
                        });
                      }
                    }
                    if ( img64Contract== null) {
                      setState(() {
                        imageContractRequired = true;
                      });
                    }
                    if( img64Contract!= null){
                      setState(() {
                        imageContractRequired = false;
                      });
                    }
                    if (img64 == null) {
                      setState(() {
                        imageIDRequired = true;
                      });
                    }
                    if (img64 != null) {
                      setState(() {
                        imageIDRequired = false;
                      });
                    }

                    if(isSahamah==true){
                      if(displayReference==true){
                        if (img64 != null && img64Contract != null && NationalNumber.text!='' && IdNumber.text!=''
                            &&  MilitaryId.text!=''  && ReferenceNumber.text!='' && armyType!='' && armyRegistrationType!=''&& armyRank!='' && documentExpiryDate.text !=''
                        ) {
                          setState(() {
                            isDisabled=true;
                          });
                          if(Bulk_Activat==true){
                            bulk_submit_API();

                          }else{
                            submitLineDocumentationRqBloc.add(SubmitLineDocumentationRqButtonPressed(msisdn:msisdn,kitCode:kitCode,iccid:ICCID,listed:'',remark:'',idImageBase64: img64,
                                contractImageBase64:img64Contract, indCompany:'',customerTitle:'',customerProfession:'',customerFirstName:'',customerSecondName:'',customerThirdName:''
                                ,customerLastName:'',customerMaritalStatus:'',customerLanguage:'',customerAddressType:'',customerHomeTel:ReferenceNumber.text,customerHomeTel2:SecondReferenceNumber.text ,customerBirthDate:'',customerGender:'',
                                customerGovernorate:'',customerNationality:'108',customerNationalNumber:NationalNumber.text,customerIdType:'',customerIdNumber:IdNumber.text,customerBusinessType:'',
                                customerArea:'',customerCity:'',customerTrade:'',customerPF:'',customerDepartment:'',militaryId:MilitaryId.text,armyRegisterationTypeId: armyRegistrationType,
                                armyTypeId: armyType, armyRankId: armyRank,documentExpiryDate:documentExpiryDate.text
                            ));
                          }

                        }
                      }
                      else{
                        if (img64 != null && img64Contract != null&& NationalNumber.text!='' && IdNumber.text!=''
                            &&  MilitaryId.text!='' && armyType!='' && armyRegistrationType!=''&& armyRank!='' && documentExpiryDate.text !=''
                        ) {
                          setState(() {
                            isDisabled=true;
                          });
                          if(Bulk_Activat==true){
                            bulk_submit_API();

                          }else{
                            submitLineDocumentationRqBloc.add(SubmitLineDocumentationRqButtonPressed(msisdn:msisdn,kitCode:kitCode,iccid:ICCID,listed:'',remark:'',idImageBase64: img64,
                                contractImageBase64:img64Contract, indCompany:'',customerTitle:'',customerProfession:'',customerFirstName:'',customerSecondName:'',customerThirdName:''
                                ,customerLastName:'',customerMaritalStatus:'',customerLanguage:'',customerAddressType:'',customerHomeTel:ReferenceNumber.text,customerHomeTel2:SecondReferenceNumber.text, customerBirthDate:'',customerGender:'',
                                customerGovernorate:'',customerNationality:'108',customerNationalNumber:NationalNumber.text,customerIdType:'',customerIdNumber:IdNumber.text,customerBusinessType:'',
                                customerArea:'',customerCity:'',customerTrade:'',customerPF:'',customerDepartment:'',militaryId:MilitaryId.text,armyRegisterationTypeId: armyRegistrationType,
                                armyTypeId: armyType, armyRankId: armyRank,documentExpiryDate:documentExpiryDate.text
                            ));}
                        }
                      }

                    }
                    else if(isSahamah==false){
                      if(displayReference==true){

                        if (img64 != null && img64Contract != null && NationalNumber.text!='' && IdNumber.text!=''
                            && ReferenceNumber.text!=''&& documentExpiryDate.text !=''
                        ) {
                          setState(() {
                            isDisabled=true;
                          });
                          if(Bulk_Activat==true){
                            bulk_submit_API();

                          }else{
                            submitLineDocumentationRqBloc.add(SubmitLineDocumentationRqButtonPressed(msisdn:msisdn,kitCode:kitCode,iccid:ICCID,listed:'',remark:'',idImageBase64: img64,
                                contractImageBase64:img64Contract, indCompany:'',customerTitle:'',customerProfession:'',customerFirstName:'',customerSecondName:'',customerThirdName:''
                                ,customerLastName:'',customerMaritalStatus:'',customerLanguage:'',customerAddressType:'',customerHomeTel:ReferenceNumber.text,customerHomeTel2:SecondReferenceNumber.text, customerBirthDate:'',customerGender:'',
                                customerGovernorate:'',customerNationality:'108',customerNationalNumber:NationalNumber.text,customerIdType:'',customerIdNumber:IdNumber.text,customerBusinessType:'',
                                customerArea:'',customerCity:'',customerTrade:'',customerPF:'',customerDepartment:'',militaryId:'',armyRegisterationTypeId: '',
                                armyTypeId: '', armyRankId:'',documentExpiryDate:documentExpiryDate.text
                            ));}
                        }
                      }
                      else{
                        if (img64 != null && img64Contract != null && NationalNumber.text!='' && IdNumber.text!=''&& documentExpiryDate.text !=''
                        ) {
                          setState(() {
                            isDisabled=true;
                          });
                          if(Bulk_Activat==true){
                            bulk_submit_API();

                          }else{
                            submitLineDocumentationRqBloc.add(SubmitLineDocumentationRqButtonPressed(msisdn:msisdn,kitCode:kitCode,iccid:ICCID,listed:'',remark:'',idImageBase64: img64,
                                contractImageBase64:img64Contract, indCompany:'',customerTitle:'',customerProfession:'',customerFirstName:'',customerSecondName:'',customerThirdName:''
                                ,customerLastName:'',customerMaritalStatus:'',customerLanguage:'',customerAddressType:'',customerHomeTel:'', customerHomeTel2:'',customerBirthDate:'',customerGender:'',
                                customerGovernorate:'',customerNationality:'108',customerNationalNumber:NationalNumber.text,customerIdType:'',customerIdNumber:IdNumber.text,customerBusinessType:'',
                                customerArea:'',customerCity:'',customerTrade:'',customerPF:'',customerDepartment:'',militaryId:'',armyRegisterationTypeId: '',
                                armyTypeId: '', armyRankId: '',documentExpiryDate:documentExpiryDate.text
                            ));}
                        }
                      }
                    }

                    if(documentExpiryDate.text ==""){
                      setState(() {
                        emptyDocumentExpiryDate = true;
                      });
                    }
                    if(documentExpiryDate.text !=""){
                      setState(() {
                        emptyDocumentExpiryDate = false;
                      });
                    }
                  },
                  style: isLoading? TextButton.styleFrom(
                    backgroundColor:Colors.transparent,
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ):TextButton.styleFrom(
                    backgroundColor:Color(0xFF4f2565),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  child: isLoading?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color:Color(0xFF4f2565)),
                      const SizedBox(width: 24),
                      Text("corporetUser.PleaseWait".tr().toString(),style: TextStyle( color: Color(0xFF4f2565),

                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',))
                    ],
                  ):Text(
                    "Jordan_Nationality.submit".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )
            ),
            SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }
}
