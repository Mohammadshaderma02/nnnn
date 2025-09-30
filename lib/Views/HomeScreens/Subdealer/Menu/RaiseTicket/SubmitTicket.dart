import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/PendingContracts/PendingContracts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mime/mime.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/CreateTicket/createTicket_bloc.dart';
import 'package:sales_app/blocs/CreateTicket/createTicket_events.dart';
import 'package:sales_app/blocs/CreateTicket/createTicket_state.dart';

import 'package:sales_app/blocs/LookUpList/LokkUpList_state.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_bloc.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_events.dart';
class SubmitTicket extends StatefulWidget {
  List<dynamic> Permessions=[];
  var role;
  var outDoorUserName;
  SubmitTicket({this.Permessions,this.role,this.outDoorUserName});
  @override
  _SubmitTicketState createState() => _SubmitTicketState(this.Permessions,this.role,this.outDoorUserName);
}
class Item {
  const Item(this.value, this.textEn, this.textAr);
  final String value;
  final String textEn;
  final String textAr;
}
List<Item> COMPLAIN_TYPE = <Item>[];
List<Item> LIST_OF_DEALERS = <Item>[];

class _SubmitTicketState  extends State<SubmitTicket> {
  List<dynamic> Permessions=[];
  var role;
  var outDoorUserName;
  _SubmitTicketState(this.Permessions,this.role,this.outDoorUserName);

  GetLookUpListBloc getLookUpListBloc;
  CreateTicketBloc createTicketBloc;
  TextEditingController Message = TextEditingController();
  int maxLines = 2;
  bool emptyMessage= false;
  bool emptyComplainType = false;
  bool emptyDealer= false;
  String complainType ;
  String dealer;
  bool imageRequired = false;
  String imageName ='';
  bool viewDealer = false;

  @override
  void initState() {
    getLookUpListBloc = BlocProvider.of<GetLookUpListBloc>(context);
    createTicketBloc = BlocProvider.of<CreateTicketBloc>(context);
    getLookUpListBloc.add(GetLookUpListFetchEvent());
    super.initState();
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



  String img64 ='';
  final _picker = ImagePicker();
  File imageFile ;
  bool _load= false;
  var pickedFile;

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
    pickedFile = await _picker.pickImage(source: ImageSource.camera,

    );

    if(pickedFile!=null) {
      imageFile = File(pickedFile.path);
      _load = true;
      var imageName = pickedFile.path
          .split('/')
          .last;
      print(pickedFile);

      print(pickedFile.path);
      final bytes = File(pickedFile.path)
          .readAsBytesSync()
          .lengthInBytes;

          calculateImageSize(pickedFile.path);
          if (pickedFile != null) {
            _cropImage(File(pickedFile.path));
          }

    }
  }
  void pickImageGallery() async {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery,

    );

    if(pickedFile!=null) {
      imageFile = File(pickedFile.path);
      _load = true;
      var imageName = pickedFile.path
          .split('/')
          .last;

        calculateImageSize(pickedFile.path);

        if (pickedFile != null) {
                    _cropImage(File(pickedFile.path));
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
            _load=false;
            pickedFile=null;

          });
        }
        else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64 = base64Encode(base64Image);
          print('img64Crop: ${img64}');
          imageFile= File(cropped.path);
          //Message.text=img64;
        }
      });

    }
    else{
      this.setState(() {

        _load=false;
        pickedFile=null;

        ///here
      });

    }
  }
  void clearImageID() {
    /* this.setState(()=>
    imageFileID = null );*/


    this.setState(() {

      _load=false;
      pickedFile=null;

      ///here
    });
  }
  /////////////End ImageID Functions/////////////
  //** Pick & Crop & Clear --> "ImageContract"  Camera/Gallery  **//



  /////////////End ImageID Functions/////////////
  //** Pick & Crop & Clear --> "ImageContract"  Camera/Gallery  **//

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
  final msg = BlocBuilder<CreateTicketBloc, CreateTicketState>(builder: (context, state) {
    if (state is CreateTicketLoadingState   ) {
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
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTicketBloc,CreateTicketState>(
        listener: (context, state) {
          if (state is CreateTicketErrorState) {
            showAlertDialogError(
                context, state.arabicMessage, state.englishMessage);
          }
          if (state is CreateTicketSuccessState) {
            Navigator.pop(context);
            showToast(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? state.englishMessage
                    : state.arabicMessage,
                context: context,
                animation: StyledToastAnimation.scale,
                fullWidth: true);
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
              centerTitle:false,
              title: Text("Test.submit_ticket".tr().toString()),
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
                                text:  "Test.complain_type".tr().toString(),
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
                            BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
                                builder: (context, state) {
                                  if (state is GetLookUpListSuccessState ||
                                      state is GetLookUpListLoadingState ||
                                      state is GetLookUpListListErrorState) {
                                    COMPLAIN_TYPE = [];
                                    if (state is GetLookUpListSuccessState) {
                                      COMPLAIN_TYPE = [];
                                      for (var obj in state.data[11]['value']['data']) {
                                        COMPLAIN_TYPE.add(Item(obj['key'], obj['value'].toString(),
                                            obj['valueAr'].toString()));
                                      }
                                    }
                                    return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            //color: Color(0xFFB10000), red color
                                            color: emptyComplainType == true
                                                ? Color(0xFFB10000)
                                                : Color(0xFFD1D7E0),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              disabledHint:Text(
                                                "Test.select_an_option".tr().toString(),
                                                style: TextStyle(
                                                  color: Color(0xFFA4B0C1),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              hint: Text(
                                                "Test.select_an_option".tr().toString(),
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
                                              value: complainType,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  complainType = newValue;
                                                });
                                              },
                                              items: COMPLAIN_TYPE.map((valueItem) {
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
                      ),
                      emptyComplainType ==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      SizedBox(height: 20,),
                      SizedBox(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text:  "Test.list_of_dealers".tr().toString(),
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
                            BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
                                builder: (context, state) {
                                  if (state is GetLookUpListSuccessState ||
                                      state is GetLookUpListLoadingState ||
                                      state is GetLookUpListListErrorState) {
                                    LIST_OF_DEALERS = [];
                                    if (state is GetLookUpListSuccessState) {
                                      LIST_OF_DEALERS = [];
                                      for (var obj in state.data[12]['value']['data']) {
                                        LIST_OF_DEALERS.add(Item(obj['key'], obj['value'].toString(),
                                            obj['valueAr'].toString()));
                                      }

                                    }
                                    return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            //color: Color(0xFFB10000), red color
                                            color: emptyDealer == true
                                                ? Color(0xFFB10000)
                                                : Color(0xFFD1D7E0),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              disabledHint:Text(
                                                "Test.select_an_option".tr().toString(),
                                                style: TextStyle(
                                                  color: Color(0xFFA4B0C1),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              hint: Text(
                                                "Test.select_an_option".tr().toString(),
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
                                              value: dealer,
                                              onChanged: (  String newValue) {
                                                setState(() {
                                                  dealer = newValue;

                                                });
                                              },
                                              items: LIST_OF_DEALERS.map((valueItem) {
                                                return DropdownMenuItem<String>(
                                                  value: valueItem.value+","+'${EasyLocalization.of(context).locale ==
                                                      Locale("en", "US")
                                                      ? valueItem.textEn
                                                      : valueItem.textAr}',
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
                      ),
                      emptyDealer==true
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
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: "Test.message".tr().toString(),
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
                            SizedBox(height: maxLines>2?0: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: maxLines * 24.0,
                              child: TextField(
                                controller: Message,
                                maxLines: maxLines,
                                onTap: (){
                                  setState(() {
                                    maxLines=10;
                                  });
                                },
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(color: Color(0xff11120e)),
                                decoration: InputDecoration(
                                  enabledBorder: emptyMessage == true
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
                                  hintText: "Test.enter_message".tr().toString(),
                                  hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),

                                ),

                              ),
                            )
                          ],
                        ),

                      ),
                      emptyMessage==true
                          ? ReusableRequiredText(
                          text:
                          "Jordan_Nationality.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),


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
                    "Test.capture_photo".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF11120e),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing: _load == true
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
                            child: _load == true
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
                                            image: FileImage(imageFile),
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
                                                                    imageFile),
                                                              ),
                                                              // A simplified version of dialog.
                                                              width: 300.0,
                                                              height: 350.0,
                                                            )));
                                                  },
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Test.preview_photo"
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
                                            "Test.re_take_photo"
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
                                            "Test.take_photo1"
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
                                            "Test.take_photo2"
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
                                        "Test.take_photo1"
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
                    ]),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding:EdgeInsets.all(5),
                  height: EasyLocalization.of(context).locale == Locale("en", "US") ?  35: 25,
                  child: Row(
                    children: <Widget>[
                      Switch(
                        value: viewDealer,
                        onChanged: (value) {
                    setState(() {
                      viewDealer=value;
                    });
                  },
                  activeTrackColor: Color(0xFFa18cae),
                  activeColor: Color(0xFF4f2565),
                  inactiveTrackColor:Color(0xFFadadad
                  ) ,
                ),
                    Text(
                  "Test.dealer_view".tr().toString(),
                  style: TextStyle(
                      color: Color(0xFF11120e),
                      fontSize: 16
                  ),
                )
              ],
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
                color: Color(0xFF4f2565),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                onPressed: () async {

                  if(Message.text==''){
                    setState(() {
                      emptyMessage=true;
                    });
                  }
                  if(Message.text!=''){
                    setState(() {
                      emptyMessage=false;
                    });
                  }

                  if(complainType==null){
                    setState(() {
                      emptyComplainType=true;
                    });
                  }
                  if(complainType!=null){
                    setState(() {
                      emptyComplainType=false;
                    });
                  }
                  if( dealer==null){
                    setState(() {
                      emptyDealer=true;
                    });
                  }
                  if(dealer!=null){
                    setState(() {
                      emptyDealer=false;
                    });
                  }
                  /* if (img64 == null) {
                      setState(() {
                        imageRequired = true;
                      });
                    }
                    if (img64 != null) {
                      setState(() {
                        imageRequired = false;
                      });
                    }*/
                  if(Message.text!='' && complainType!=null && dealer!=null){
                    var DealerValue = dealer.split(',');
                    String dealerName=DealerValue[1];
                    String dealerId=DealerValue[0];
                    createTicketBloc.add(CreateTicketButtonPressed(categoryID:complainType,ticketMessage:Message.text.trimRight(),
                        attachName:imageName,attachValueBase64:img64,dealerID:dealerId, dealerName:dealerName,visibility:viewDealer
                    ));
                    print([complainType,dealerId,viewDealer,dealerName,Message.text,imageName,img64]);
                  }
                },

                child: Text(
                  "Test.submit".tr().toString(),
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