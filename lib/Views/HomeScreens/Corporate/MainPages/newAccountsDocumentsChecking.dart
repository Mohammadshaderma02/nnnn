import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/PendingContracts/PendingContracts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mime/mime.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Settings/Settings.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/CreateTicket/createTicket_bloc.dart';
import 'package:sales_app/blocs/CreateTicket/createTicket_events.dart';
import 'package:sales_app/blocs/CreateTicket/createTicket_state.dart';

import 'package:sales_app/blocs/LookUpList/LokkUpList_state.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_bloc.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_events.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ReusableComponents/UnotherizedError.dart';
import '../../DeliveryEShop/CompletedOrders.dart';

import 'package:path/path.dart' as path;


class NewAccountDocumnetChecking extends StatefulWidget {
  final List<dynamic> PermessionCorporate;
  String role;

  NewAccountDocumnetChecking(this.PermessionCorporate, this.role);

  @override
  _NewAccountDocumnetCheckingState createState() =>
      _NewAccountDocumnetCheckingState(this.PermessionCorporate, this.role);
}

class Item {
  const Item(this.value, this.textEn, this.textAr);

  final String value;
  final String textEn;
  final String textAr;
}

final List<Item> COMPANIES_TYPE = [
  Item("NationalNumber_200", "National number 200 companies",
      "الرقم الوطني 200 شركة"),
  Item("NationalNumber_100", "National number 100 companies",
      "الرقم الوطني 100 شركة"),
  Item("MUC_MUC", "MUC new accounts", "حسابات جديدة MUC"),
];

class _NewAccountDocumnetCheckingState
    extends State<NewAccountDocumnetChecking> {
  final List<dynamic> PermessionCorporate;
  String role;

  _NewAccountDocumnetCheckingState(this.PermessionCorporate, this.role);

  GetLookUpListBloc getLookUpListBloc;
  CreateTicketBloc createTicketBloc;
  TextEditingController Message = TextEditingController();
  int maxLines = 2;
  bool emptyMessage = false;
  bool emptyComplainType = false;
  bool emptyOCRForm = false;
  String ocrFormType;

  @override
  void initState() {
    super.initState();
    print("role");
    print(role);
  }

  final _picker = ImagePicker();
  int imageWidth = 200;
  int imageHeight = 200;

  String img64RegistrationCertificate = "";
  bool imageRegistrationCertificate = false;
  bool imageRegistrationCertificateRequired = null;
  File imageFileRegistrationCertificate = File('');
  bool _loadRegistrationCertificate = false;
  bool isFileRegistrationCertificateFile = false;
  var pickedFileRegistrationCertificate;
  String pickedFileRegistrationCertificateName = "";
  bool pickedRegistrationCertificateExtentionError=false;
  bool pickedRegistrationCertificateFileExtentionError=false;


  String img64CarrierLicenseCertificate = "";
  bool imageCarrierLicenseCertificate = false;
  bool imageCarrierLicenseCertificateRequired = null;
  File imageFileCarrierLicenseCertificate = File('');
  bool _loadCarrierLicenseCertificate = false;
  bool isFileCarrierLicenseCertificateFile = false;
  var pickedFileCarrierLicenseCertificate;
  String pickedFileCarrierLicenseCertificateName = '';
  bool pickedCarrierLicenseCertificateExtentionError=false;
  bool pickedCarrierLicenseCertificateFileExtentionError=false;

  String img64ZainAuthorizationLetter = "";
  bool imageZainAuthorizationLetter = false;
  bool imageZainAuthorizationLetterRequired = null;
  File imageFileZainAuthorizationLetter = File('');
  bool _loadZainAuthorizationLetter = false;
  bool isFileZainAuthorizationLetterFile = false;
  var pickedFileZainAuthorizationLetter;
  String pickedFileZainAuthorizationLetterName = '';
  bool pickedZainAuthorizationExtentionError=false;
  bool pickedZainAuthorizationFileExtentionError=false;


  String img64ZainSignatureForm = "";
  bool imageZainSignatureForm = false;
  bool imageZainSignatureFormRequired = null;
  File imageFileZainSignatureForm = File('');
  bool _loadZainSignatureForm = false;
  bool isFileZainSignatureFormFile = false;
  var pickedFileZainSignatureForm;
  String pickedFileZainSignatureFormName = "";
  bool pickedZainSignatureFormExtentionError=false;
  bool pickedZainSignatureFormFileExtentionError=false;

  String img64ZainContract = "";
  bool imageZainContract = false;
  bool imageZainContractRequired = null;
  File imageFileZainContract = File('');
  bool _loadZainContract = false;
  bool isFileZainContractFile = false;
  var pickedFileZainContract;
  String pickedFileZainContractName = '';
  bool pickedZainContractExtentionError=false;
  bool pickedZainContractFileExtentionError=false;

  String img64PersonalID = "";
  bool imagePersonalID = false;
  bool imagePersonalIDRequired = null;
  File imageFilePersonalID = File('');
  bool _loadPersonalID = false;
  bool isFilePersonalIDFile = false;
  var pickedFilePersonalID;
  String pickedFilePersonalIDName = '';
  bool pickedPersonalIDExtentionError=false;
  bool pickedPersonalIDFileExtentionError=false;

  String img64MUCForm = "";
  bool imageMUCForm = false;
  bool imageMUCFormRequired = null;
  File imageFileMUCForm = File('');
  bool _loadMUCForm = false;
  bool isFileMUCFormFile = false;
  var pickedFileMUCForm;
  String pickedFileMUCFormName = '';
  bool pickedMUCFormExtentionError=false;
  bool pickedMUCFormFileExtentionError=false;

  String img64ProofofEmployment = "";
  bool imageProofofEmployment = false;
  bool imageProofofEmploymentRequired = null;
  File imageFileProofofEmployment = File('');
  bool _loadProofofEmployment = false;
  bool isFileProofofEmploymentFile = false;
  var pickedFileProofofEmployment;
  String pickedFileProofofEmploymentName = "";
  bool pickedProofofEmploymentExtentionError=false;
  bool pickedProofofEmploymentFileExtentionError=false;

  bool showloading = false;
  bool isLoading =false;

  void calculateImageSize(String path) {
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
          double ratio = 0;
          if (size.height > size.width) {
            ratio = (size.height / 1024);
          } else {
            ratio = (size.width / 1024);
          }

          setState(() {
            imageHeight = (size.height / ratio).toInt();
            imageWidth = (size.width / ratio).toInt();
          });
          print('ratio ${ratio}');
        },
      ),
    );
  }

  Future<void> openFile(String filePath) async {

    await OpenFile.open(filePath); // Opens PDF with default viewer
  }

  Widget msg() {
    return Center(
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
          ),
        ));
  }

  Widget buildDashedBorder({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

  Widget buildOCRFormType() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: Center(
        child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: "NewAccountDocumentsChecking.OCR_Form_Type"
                            .tr()
                            .toString(),
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            //color: Color(0xFFB10000), red color
                            color: emptyOCRForm == true
                                ? Color(0xFFB10000)
                                : Color(0xFFD1D7E0),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              disabledHint: Text(
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
                              value: ocrFormType,
                              onChanged: (String newValue) {
                                clearImageRegistrationCertificate();
                                clearImageCarrierLicenseCertificate();
                                clearImageZainAuthorizationLetter();
                                clearImageZainSignatureForm();
                                clearImageZainContract();
                                clearImagePersonalID();
                                clearImageMUCForm();clearImageProofofEmployment();
                                setState(() {
                                  imageRegistrationCertificateRequired = false;
                                  imageCarrierLicenseCertificateRequired = false;
                                  imageZainAuthorizationLetterRequired = false;
                                  imageZainSignatureFormRequired = false;
                                  imageZainContractRequired = false;
                                  imagePersonalIDRequired = false;
                                  imageMUCFormRequired = false;
                                  imageProofofEmploymentRequired = false;






                                  ocrFormType = newValue;

                                });
                              },
                              items: COMPANIES_TYPE.map((valueItem) {
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
                        )),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  Widget buildImageRegistrationCertificate() {
    return Container(
      color: Colors.white,
      height: imageRegistrationCertificateRequired == true ? 390 : isFileRegistrationCertificateFile? 396:368,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.Corporate_Registration_Certificate"
                      .tr()
                      .toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadRegistrationCertificate == true
                  ? Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Color(0xff0070c9),
                    onPressed: () =>
                    {clearImageRegistrationCertificate()}),
              )
                  : null,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                margin: EdgeInsets.only(top: 30),
                //padding: EdgeInsets.only(top:30),
                child: _loadRegistrationCertificate == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        isFileRegistrationCertificateFile == false
                            ? Container(
                          width: 180,
                          height: 206,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(
                                    imageFileRegistrationCertificate),
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
                                              FocusScope.of(context)
                                                  .unfocus();
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
                                                                  imageFileRegistrationCertificate),
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
                                          )),
                                    ],
                                  ),
                                ),
                              ]),
                        )
                            : buildDashedBorder(
                          child: Container(
                            width: 180,
                            height: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
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

                                            child: Icon(Icons
                                                .file_open_outlined,
                                              color: Colors.grey,
                                            )
                                        ),
                                        SizedBox(height: 10),
                                        new Container(
                                            width:140,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await openFile(
                                                    imageFileRegistrationCertificate
                                                        .path);
                                              },
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  pickedFileRegistrationCertificateName,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color:  Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                  maxLines: 1, // Ensures it's on a single line
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
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
                              _showPickerRegistrationCertificate(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "NewAccountDocumentsChecking.re_attach"
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
                      _showPickerRegistrationCertificate(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "NewAccountDocumentsChecking.add_attachment1"
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
                                  "NewAccountDocumentsChecking.add_attachment2"
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
                              "NewAccountDocumentsChecking.add_attachment1"
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
            ],
          ),
          imageRegistrationCertificateRequired == true || pickedRegistrationCertificateExtentionError==true || pickedRegistrationCertificateFileExtentionError==true
              ? SizedBox(
            height: 5,
          )
              : SizedBox(),
          imageRegistrationCertificateRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
          pickedRegistrationCertificateExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                  .tr()
                  .toString())
              : Container(),
          pickedRegistrationCertificateFileExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_PDF_files_are_allowed"
                  .tr()
                  .toString())
              : Container(),
          imageRegistrationCertificateRequired == true||pickedRegistrationCertificateExtentionError==true || pickedRegistrationCertificateFileExtentionError==true
              ? SizedBox()
              : SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }

  void _showPickerRegistrationCertificate(context) {
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
                      pickImageCameraRegistrationCertificate();
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
                      pickImageGalleryRegistrationCertificate();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFileRegistrationCertificate();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File".tr().toString(),
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

  void pickImageCameraRegistrationCertificate() async {
    pickedFileRegistrationCertificate = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileRegistrationCertificate != null) {
      imageFileRegistrationCertificate =
          File(pickedFileRegistrationCertificate.path);
      String mimeType = lookupMimeType(pickedFileRegistrationCertificate.path);
      if (mimeType == 'image/jpeg') {
        _loadRegistrationCertificate = true;

        final bytes = File(pickedFileRegistrationCertificate.path)
            .readAsBytesSync()
            .lengthInBytes;

        calculateImageSize(pickedFileRegistrationCertificate.path);

        this.setState(() {
          isFileRegistrationCertificateFile = false;
          pickedRegistrationCertificateExtentionError=false;
          pickedRegistrationCertificateFileExtentionError=false;
        });
        _cropImageRegistrationCertificate(
            File(pickedFileRegistrationCertificate.path));

      }else{
        this.setState(() {
          pickedRegistrationCertificateExtentionError=true;
          pickedRegistrationCertificateFileExtentionError=false;
        });

      }
    }
  }

  void pickImageGalleryRegistrationCertificate() async {
    pickedFileRegistrationCertificate = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileRegistrationCertificate != null) {
      imageFileRegistrationCertificate =File(pickedFileRegistrationCertificate.path);
      String mimeType = lookupMimeType(pickedFileRegistrationCertificate.path);
      if (mimeType == 'image/jpeg') {
        _loadRegistrationCertificate = true;
        calculateImageSize(pickedFileRegistrationCertificate.path);

        this.setState(() {
          isFileRegistrationCertificateFile = false;
          pickedRegistrationCertificateExtentionError=false;
          pickedRegistrationCertificateFileExtentionError=false;
        });
        _cropImageRegistrationCertificate(
            File(pickedFileRegistrationCertificate.path));

      }else{
        this.setState(() {
          pickedRegistrationCertificateExtentionError=true;
          pickedRegistrationCertificateFileExtentionError=false;
        });

      }
    }
  }

  void pickFileRegistrationCertificate() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      File selectedFile = File(result);
      int fileSize = selectedFile.lengthSync(); // Get file size in bytes
      imageFileRegistrationCertificate = selectedFile;
      String fileName = path.basename(selectedFile.path);

      if (selectedFile.path.endsWith('.pdf')) {
        List<int> fileBytes = await selectedFile.readAsBytes();
        String base64File = base64Encode(fileBytes);

        this.setState(() {
          pickedRegistrationCertificateFileExtentionError=false;
          isFileRegistrationCertificateFile = true;
          _loadRegistrationCertificate = true;
          pickedFileRegistrationCertificateName = fileName;
          img64RegistrationCertificate = "data:application/pdf;base64," + base64File;
        });
      } else {
        this.setState(() {
          pickedRegistrationCertificateFileExtentionError=true;
        });
      }
    }
  }

  void clearImageRegistrationCertificate() {
    this.setState(() {
      _loadRegistrationCertificate = false;
      pickedFileRegistrationCertificate = null;
      pickedFileRegistrationCertificateName = '';
      img64RegistrationCertificate='';
      pickedRegistrationCertificateExtentionError=false;
      pickedRegistrationCertificateFileExtentionError=false;
    });
  }

  _cropImageRegistrationCertificate(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /* compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadRegistrationCertificate = false;
            pickedFileRegistrationCertificate = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64RegistrationCertificate = "data:image/jpg;base64,"+base64Encode(base64Image);
          imageFileRegistrationCertificate = File(cropped.path);
          upload_RegistrationCertificate_API();
        }
      });
    } else {
      this.setState(() {
        _loadRegistrationCertificate = false;
        pickedFileRegistrationCertificate = null;
      });
    }
  }


  Widget buildImageCarrierLicenseCertificate() {
    return Container(
      color: Colors.white,
      height: imageCarrierLicenseCertificateRequired == true ? 390 : isFileCarrierLicenseCertificateFile?396:368,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.Carrier_License_Certificate"
                      .tr()
                      .toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadCarrierLicenseCertificate == true
                  ? Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Color(0xff0070c9),
                    onPressed: () =>
                    {clearImageCarrierLicenseCertificate()}),
              )
                  : null,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                margin: EdgeInsets.only(top: 30),
                //padding: EdgeInsets.only(top:30),
                child: _loadCarrierLicenseCertificate == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        isFileCarrierLicenseCertificateFile == false
                            ? Container(
                          width: 180,
                          height: 206,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(
                                    imageFileCarrierLicenseCertificate),
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
                                            FocusScope.of(context)
                                                .unfocus();
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
                                                                imageFileCarrierLicenseCertificate),
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
                                                color: Color(
                                                    0xFFffffff),
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
                        )
                            : buildDashedBorder(
                          child: Container(
                            width: 180,
                            height: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
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
                                            child: Icon(Icons
                                                .file_open_outlined,
                                              color: Colors.grey,
                                            )),
                                        SizedBox(height: 10),
                                        new Container(
                                            width:140,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await openFile(
                                                    imageFileCarrierLicenseCertificate
                                                        .path);
                                              },
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  pickedFileCarrierLicenseCertificateName,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                  maxLines: 1, // Ensures it's on a single line
                                                  overflow: TextOverflow.ellipsis, //
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
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
                              _showPickerCarrierLicenseCertificate(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "NewAccountDocumentsChecking.re_attach"
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
                      _showPickerCarrierLicenseCertificate(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "NewAccountDocumentsChecking.add_attachment1"
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
                                  "NewAccountDocumentsChecking.add_attachment2"
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
                              "NewAccountDocumentsChecking.add_attachment2"
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
            ],
          ),
          imageCarrierLicenseCertificateRequired == true||pickedCarrierLicenseCertificateExtentionError==true || pickedCarrierLicenseCertificateFileExtentionError==true
              ? SizedBox(
            height: 5,
          )
              : SizedBox(),
          imageCarrierLicenseCertificateRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
          pickedCarrierLicenseCertificateExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                  .tr()
                  .toString())
              : Container(),
          pickedCarrierLicenseCertificateFileExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_PDF_files_are_allowed"
                  .tr()
                  .toString())
              : Container(),

          imageCarrierLicenseCertificateRequired == true||pickedCarrierLicenseCertificateExtentionError==true ||
              pickedCarrierLicenseCertificateFileExtentionError==true
              ? SizedBox()
              : SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }

  void _showPickerCarrierLicenseCertificate(context) {
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
                      pickImageCameraCarrierLicenseCertificate();
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
                      pickImageGalleryCarrierLicenseCertificate();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFileCarrierLicenseCertificate();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File"
                              .tr()
                              .toString(),
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

  void pickImageCameraCarrierLicenseCertificate() async {
    pickedFileCarrierLicenseCertificate = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileCarrierLicenseCertificate != null) {
      String mimeType = lookupMimeType(pickedFileCarrierLicenseCertificate.path);
      if (mimeType == 'image/jpeg') {
        imageFileCarrierLicenseCertificate =File(pickedFileCarrierLicenseCertificate.path);
        _loadCarrierLicenseCertificate = true;
        calculateImageSize(pickedFileCarrierLicenseCertificate.path);

        this.setState(() {
          isFileCarrierLicenseCertificateFile = false;
          pickedCarrierLicenseCertificateExtentionError=false;
          pickedCarrierLicenseCertificateFileExtentionError=false;
        });
        _cropImageCarrierLicenseCertificate(File(pickedFileCarrierLicenseCertificate.path));


      }else{
        setState(() {
          pickedCarrierLicenseCertificateExtentionError=true;
          pickedCarrierLicenseCertificateFileExtentionError=false;
        });
      }
    }
  }

  void pickImageGalleryCarrierLicenseCertificate() async {
    pickedFileCarrierLicenseCertificate = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileCarrierLicenseCertificate != null) {
      imageFileCarrierLicenseCertificate = File(pickedFileCarrierLicenseCertificate.path);
      String mimeType = lookupMimeType(pickedFileCarrierLicenseCertificate.path);
      if (mimeType == 'image/jpeg') {
        _loadCarrierLicenseCertificate = true;

        calculateImageSize(pickedFileCarrierLicenseCertificate.path);

        this.setState(() {
          isFileCarrierLicenseCertificateFile = false;
          pickedCarrierLicenseCertificateExtentionError=false;
          pickedCarrierLicenseCertificateFileExtentionError=false;
        });
        _cropImageCarrierLicenseCertificate(
            File(pickedFileCarrierLicenseCertificate.path));
      }else{
        setState(() {
          pickedCarrierLicenseCertificateExtentionError=true;
          pickedCarrierLicenseCertificateFileExtentionError=false;
        });
      }
    }
  }

  void pickFileCarrierLicenseCertificate() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      File selectedFile = File(result);
      int fileSize = selectedFile.lengthSync(); // Get file size in bytes
      imageFileCarrierLicenseCertificate = selectedFile;
      String fileName = path.basename(selectedFile.path);
      List<int> fileBytes = await selectedFile.readAsBytes();
      String base64File = base64Encode(fileBytes);

      if (selectedFile.path.endsWith('.pdf')) {
        this.setState(() {
          isFileCarrierLicenseCertificateFile = true;
          pickedCarrierLicenseCertificateFileExtentionError=false;
          _loadCarrierLicenseCertificate = true;
          pickedFileCarrierLicenseCertificateName = fileName;
          img64CarrierLicenseCertificate = "data:application/pdf;base64," + base64File;
        });
      } else {
        setState(() {
          pickedCarrierLicenseCertificateFileExtentionError=true;
        });
      }
    }
  }

  void clearImageCarrierLicenseCertificate() {
    this.setState(() {
      _loadCarrierLicenseCertificate = false;
      pickedFileCarrierLicenseCertificate = null;
      pickedFileCarrierLicenseCertificateName = '';
      img64CarrierLicenseCertificate='';
      pickedCarrierLicenseCertificateExtentionError=false;
      pickedCarrierLicenseCertificateFileExtentionError=false;
    });
  }

  _cropImageCarrierLicenseCertificate(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /* compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadCarrierLicenseCertificate = false;
            pickedFileCarrierLicenseCertificate = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64CarrierLicenseCertificate = "data:image/jpg;base64,"+base64Encode(base64Image);
          print('img64Crop: ${img64CarrierLicenseCertificate}');
          imageFileCarrierLicenseCertificate = File(cropped.path);
          upload_CarrierLicenseCertificate_API();
        }
      });
    } else {
      this.setState(() {
        _loadCarrierLicenseCertificate = false;
        pickedFileCarrierLicenseCertificate = null;

        ///here
      });
    }
  }

  Widget buildImageZainAuthorizationLetter() {
    return Container(
      color: Colors.white,
      height: imageZainAuthorizationLetterRequired == true ?  390 : isFileZainAuthorizationLetterFile==true? 396:368 ,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.Zain_Authorization_Letter"
                      .tr()
                      .toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadZainAuthorizationLetter == true
                  ? Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Color(0xff0070c9),
                    onPressed: () => {clearImageZainAuthorizationLetter()}),
              )
                  : null,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                margin: EdgeInsets.only(top: 30),
                //padding: EdgeInsets.only(top:30),
                child: _loadZainAuthorizationLetter == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        isFileZainAuthorizationLetterFile == false
                            ? Container(
                          width: 180,
                          height: 206,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(
                                    imageFileZainAuthorizationLetter),
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
                                            FocusScope.of(context)
                                                .unfocus();
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
                                                                imageFileZainAuthorizationLetter),
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
                                                color: Color(
                                                    0xFFffffff),
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
                        )
                            : buildDashedBorder(
                          child: Container(
                            width: 180,
                            height: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
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
                                            child: Icon(Icons
                                                .file_open_outlined,
                                              color: Colors.grey,
                                            )),
                                        SizedBox(height: 10),
                                        new Container(
                                            width:140,

                                            child: GestureDetector(
                                              onTap: () async {
                                                await openFile(
                                                    imageFileZainAuthorizationLetter
                                                        .path);
                                              },
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  pickedFileZainAuthorizationLetterName,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                  maxLines: 1, // Ensures it's on a single line
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
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
                              _showPickerZainAuthorizationLetter(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "NewAccountDocumentsChecking.re_attach"
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
                      _showPickerZainAuthorizationLetter(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "NewAccountDocumentsChecking.add_attachment1"
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
                                  "NewAccountDocumentsChecking.add_attachment2"
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
                              "NewAccountDocumentsChecking.add_attachment2"
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
            ],
          ),
          imageZainAuthorizationLetterRequired == true||pickedZainAuthorizationExtentionError==true || pickedZainAuthorizationFileExtentionError==true
              ? SizedBox(
            height: 5,
          )
              : SizedBox(),
          imageZainAuthorizationLetterRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
          pickedZainAuthorizationExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                  .tr()
                  .toString())
              : Container(),
          pickedZainAuthorizationFileExtentionError==true ?

          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_PDF_files_are_allowed"
                  .tr()
                  .toString())
              : Container(),

          imageZainAuthorizationLetterRequired == true ||pickedZainAuthorizationExtentionError==true ||pickedZainAuthorizationFileExtentionError==true
              ? SizedBox()
              : SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }

  void _showPickerZainAuthorizationLetter(context) {
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
                      pickImageCameraZainAuthorizationLetter();
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
                      pickImageGalleryZainAuthorizationLetter();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFileZainAuthorizationLetter();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File"
                              .tr()
                              .toString(),
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

  void pickImageCameraZainAuthorizationLetter() async {
    pickedFileZainAuthorizationLetter = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileZainAuthorizationLetter != null) {
      imageFileZainAuthorizationLetter = File(pickedFileZainAuthorizationLetter.path);
      String mimeType = lookupMimeType(pickedFileZainAuthorizationLetter.path);
      if (mimeType == 'image/jpeg') {
        _loadZainAuthorizationLetter = true;

        calculateImageSize(pickedFileZainAuthorizationLetter.path);

        this.setState(() {
          isFileZainAuthorizationLetterFile = false;
          pickedZainAuthorizationExtentionError = false;
          pickedZainAuthorizationFileExtentionError=false;
        });
        _cropImageZainAuthorizationLetter(
            File(pickedFileZainAuthorizationLetter.path));

      }else{
        setState(() {
          pickedZainAuthorizationExtentionError=true;
          pickedZainAuthorizationFileExtentionError=false;
        });
      }
    }

    print('img64ZainAuthorizationLetter');
    print(pickedFileZainAuthorizationLetter.path);
  }

  void pickImageGalleryZainAuthorizationLetter() async {
    pickedFileZainAuthorizationLetter = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileZainAuthorizationLetter != null) {
      imageFileZainAuthorizationLetter = File(pickedFileZainAuthorizationLetter.path);
      String mimeType = lookupMimeType(pickedFileZainAuthorizationLetter.path);
      if (mimeType == 'image/jpeg') {
        _loadZainAuthorizationLetter = true;

        calculateImageSize(pickedFileZainAuthorizationLetter.path);

        this.setState(() {
          isFileZainAuthorizationLetterFile = false;
          pickedZainAuthorizationExtentionError=false;
          pickedZainAuthorizationFileExtentionError=false;
        });
        _cropImageZainAuthorizationLetter(File(pickedFileZainAuthorizationLetter.path));

      }else{
        setState(() {
          pickedZainAuthorizationExtentionError=true;
          pickedZainAuthorizationFileExtentionError=false;
        });
      }
    }
  }

  void pickFileZainAuthorizationLetter() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      File selectedFile = File(result);
      int fileSize = selectedFile.lengthSync(); // Get file size in bytes
      imageFileZainAuthorizationLetter = selectedFile;
      String fileName = path.basename(selectedFile.path);

      if (selectedFile.path.endsWith('.pdf')) {
        List<int> fileBytes = await selectedFile.readAsBytes();
        String base64File = base64Encode(fileBytes);
        this.setState(() {
          isFileZainAuthorizationLetterFile = true;
          pickedZainAuthorizationFileExtentionError=false;
          _loadZainAuthorizationLetter = true;
          pickedFileZainAuthorizationLetterName = fileName;
          img64ZainAuthorizationLetter = "data:application/pdf;base64," + base64File;
        });
      } else {
        setState(() {
          pickedZainAuthorizationFileExtentionError=true;
        });
      }
    }
  }

  void clearImageZainAuthorizationLetter() {
    this.setState(() {
      _loadZainAuthorizationLetter = false;
      pickedFileZainAuthorizationLetter = null;
      pickedFileZainAuthorizationLetterName = '';
      img64ZainAuthorizationLetter='';
      pickedZainAuthorizationExtentionError=false;
      pickedZainAuthorizationFileExtentionError=false;
    });
  }

  _cropImageZainAuthorizationLetter(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /* compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadZainAuthorizationLetter = false;
            pickedFileZainAuthorizationLetter = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64ZainAuthorizationLetter = "data:image/jpg;base64,"+base64Encode(base64Image);
          print('img64Crop: ${img64ZainAuthorizationLetter}');
          imageFileZainAuthorizationLetter = File(cropped.path);
          upload_ZainAuthorizationLetter_API();
        }
      });
    } else {
      this.setState(() {
        _loadZainAuthorizationLetter = false;
        pickedFileZainAuthorizationLetter = null;

        ///here
      });
    }
  }

  /*Widget buildImageZainAuthorizationLetter() {
    return Container(
      color: Colors.white,
      height: imageZainAuthorizationLetterRequired == true ? 390 : isFileZainAuthorizationLetterFile==true? 396:368 ,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.Zain_Authorization_Letter"
                      .tr()
                      .toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadZainAuthorizationLetter == true
                  ? Container(
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Color(0xff0070c9),
                          onPressed: () =>
                              {clearImageZainAuthorizationLetter()}),
                    )
                  : null,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                margin: EdgeInsets.only(top: 30),
                //padding: EdgeInsets.only(top:30),
                child: _loadZainAuthorizationLetter == true
                    ? Column(
                        children: [
                          Row(
                            children: [
                              isFileZainAuthorizationLetterFile == false
                                  ? Container(
                                      width: 180,
                                      height: 206,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            colorFilter: new ColorFilter.mode(
                                                Colors.black.withOpacity(0.5),
                                                BlendMode.dstATop),
                                            image: FileImage(
                                                imageFileZainAuthorizationLetter),
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
                                                        FocusScope.of(context)
                                                            .unfocus();
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
                                                                            imageFileZainAuthorizationLetter),
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
                                                            color: Color(
                                                                0xFFffffff),
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
                                    )
                                  : buildDashedBorder(
                                      child: Container(
                                        width: 180,
                                        height: 230,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
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
                                                        child: Icon(Icons
                                                            .file_open_outlined,
                                                          color: Colors.grey,
                                                        )),
                                                    SizedBox(height: 10),
                                                    new Container(
                                                        width:140,

                                                        child: GestureDetector(
                                                      onTap: () async {
                                                        await openFile(
                                                            imageFileZainAuthorizationLetter
                                                                .path);
                                                      },
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          pickedFileZainAuthorizationLetterName,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          maxLines: 1, // Ensures it's on a single line
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
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
                                    _showPickerZainAuthorizationLetter(context);
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "NewAccountDocumentsChecking.re_attach"
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
                            _showPickerZainAuthorizationLetter(context);
                          },
                          child: Container(
                            width: 180,
                            height: 235,
                            child: GestureDetector(
                              child: Align(
                                alignment: Alignment.center,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: EasyLocalization.of(context).locale ==
                                          Locale("en", "US")
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "NewAccountDocumentsChecking.add_attachment1"
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
                                              "NewAccountDocumentsChecking.add_attachment2"
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
                                          "NewAccountDocumentsChecking.add_attachment2"
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
            ],
          ),
          imageZainAuthorizationLetterRequired == true||pickedZainAuthorizationExtentionError==true
              ? SizedBox(
                  height: 5,
                )
              : SizedBox(),
          imageZainAuthorizationLetterRequired == true
              ? ReusableRequiredText(
                  text: "Jordan_Nationality.this_feild_is_required"
                      .tr()
                      .toString())
              : Container(),
          pickedZainAuthorizationExtentionError==true
         ? ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                  .tr()
                  .toString())
              : Container(),

          imageZainAuthorizationLetterRequired == true||pickedZainAuthorizationExtentionError==true
              ? SizedBox()
              : SizedBox(
                  height: 30,
                )
        ]),
      ),
    );
  }

  void _showPickerZainAuthorizationLetter(context) {
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
                      pickImageCameraZainAuthorizationLetter();
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
                      pickImageGalleryZainAuthorizationLetter();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFileZainAuthorizationLetter();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File"
                              .tr()
                              .toString(),
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

  void pickImageCameraZainAuthorizationLetter() async {
    pickedFileZainAuthorizationLetter = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileZainAuthorizationLetter != null) {
      imageFileZainAuthorizationLetter =     File(imageFileZainAuthorizationLetter.path);

      String mimeType = lookupMimeType(imageFileZainAuthorizationLetter.path);
      if (mimeType == 'image/jpeg') {
        _loadZainAuthorizationLetter = true;
        calculateImageSize(pickedFileZainAuthorizationLetter.path);

          this.setState(() {
            isFileZainAuthorizationLetterFile = false;
            pickedZainAuthorizationExtentionError=false;
          });
          _cropImageZainAuthorizationLetter(
              File(pickedFileZainAuthorizationLetter.path));

      }
      else{

        setState(() {
          pickedZainAuthorizationExtentionError=true;
        });
      }
    }
  }

  void pickImageGalleryZainAuthorizationLetter() async {
    pickedFileZainAuthorizationLetter = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileZainAuthorizationLetter != null) {
      imageFileZainAuthorizationLetter =File(pickedFileZainAuthorizationLetter.path);

      String mimeType = lookupMimeType(imageFileZainAuthorizationLetter.path);
      if (mimeType == 'image/jpeg') {
        _loadZainAuthorizationLetter = true;

        calculateImageSize(pickedFileZainAuthorizationLetter.path);

          this.setState(() {
            isFileZainAuthorizationLetterFile = false;
            pickedZainAuthorizationExtentionError=false;
          });
          _cropImageZainAuthorizationLetter(
              File(pickedFileZainAuthorizationLetter.path));

      }else{
        setState(() {
          pickedZainAuthorizationExtentionError=true;
        });
      }
    }
  }

  void pickFileZainAuthorizationLetter() async {
    FilePickerResult pickedZainAuthorizationLetterFile =
        await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    File selectedFile =
        File(pickedZainAuthorizationLetterFile.files.single.path);
    int fileSize = selectedFile.lengthSync(); // Get file size in bytes
    imageFileZainAuthorizationLetter = File(selectedFile.path);
    String fileName = path.basename(selectedFile.path);

    if (selectedFile.path.endsWith('.pdf')) {
      List<int> fileBytes = await selectedFile.readAsBytes();
      String base64File = base64Encode(fileBytes);
      this.setState(() {
        isFileZainAuthorizationLetterFile = true;
        _loadZainAuthorizationLetter = true;
        pickedFileZainAuthorizationLetterName = fileName;
        img64ZainAuthorizationLetter="data:application/pdf;base64,"+base64File;
      });
    } else {
      print("No file selected");
    }
  }

  void clearImageZainAuthorizationLetter() {
    this.setState(() {
      _loadZainAuthorizationLetter = false;
      pickedFileZainAuthorizationLetter = null;
      pickedFileZainAuthorizationLetterName = '';
      img64ZainAuthorizationLetter='';
      pickedZainAuthorizationExtentionError=false;
    });
  }

  _cropImageZainAuthorizationLetter(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,

      compressQuality: 100,

      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadZainAuthorizationLetter = false;
            pickedFileZainAuthorizationLetter = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64ZainAuthorizationLetter = "data:image/jpg;base64,"+base64Encode(base64Image);
          print('img64Crop: ${img64ZainAuthorizationLetter}');
          imageFileZainAuthorizationLetter = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadZainAuthorizationLetter = false;
        pickedFileZainAuthorizationLetter = null;

        ///here
      });
    }
  }*/


  Widget buildImageZainSignatureForm() {
    return Container(
      color: Colors.white,
      height: imageZainSignatureFormRequired == true ?  390 : isFileZainSignatureFormFile==true? 396:368 ,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.Zain_Signature_Form"
                      .tr()
                      .toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadZainSignatureForm == true
                  ? Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Color(0xff0070c9),
                    onPressed: () => {clearImageZainSignatureForm()}),
              )
                  : null,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                margin: EdgeInsets.only(top: 30),
                //padding: EdgeInsets.only(top:30),
                child: _loadZainSignatureForm == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        isFileZainSignatureFormFile == false
                            ? Container(
                          width: 180,
                          height: 206,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(
                                    imageFileZainSignatureForm),
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
                                            FocusScope.of(context)
                                                .unfocus();
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
                                                                imageFileZainSignatureForm),
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
                                                color: Color(
                                                    0xFFffffff),
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
                        )
                            : buildDashedBorder(
                          child: Container(
                            width: 180,
                            height: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
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
                                            child: Icon(Icons
                                                .file_open_outlined,
                                              color: Colors.grey,
                                            )),
                                        SizedBox(height: 10),
                                        new Container(
                                            width:140,

                                            child: GestureDetector(
                                              onTap: () async {
                                                await openFile(
                                                    imageFileZainSignatureForm
                                                        .path);
                                              },
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  pickedFileZainSignatureFormName,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                  maxLines: 1, // Ensures it's on a single line
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
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
                              _showPickerZainSignatureForm(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "NewAccountDocumentsChecking.re_attach"
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
                      _showPickerZainSignatureForm(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "NewAccountDocumentsChecking.add_attachment1"
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
                                  "NewAccountDocumentsChecking.add_attachment2"
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
                              "NewAccountDocumentsChecking.add_attachment2"
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
            ],
          ),
          imageZainSignatureFormRequired == true||pickedZainSignatureFormExtentionError==true || pickedZainSignatureFormFileExtentionError==true
              ? SizedBox(
            height: 5,
          )
              : SizedBox(),
          imageZainSignatureFormRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
          pickedZainSignatureFormExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                  .tr()
                  .toString())
              : Container(),

          pickedZainSignatureFormFileExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_PDF_files_are_allowed"
                  .tr()
                  .toString())
              : Container(),

          imageZainSignatureFormRequired == true ||pickedZainSignatureFormExtentionError==true ||pickedZainSignatureFormFileExtentionError==true
              ? SizedBox()
              : SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }

  void _showPickerZainSignatureForm(context) {
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
                      pickImageCameraZainSignatureForm();
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
                      pickImageGalleryZainSignatureForm();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFileZainSignatureForm();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File"
                              .tr()
                              .toString(),
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

  void pickImageCameraZainSignatureForm() async {
    pickedFileZainSignatureForm = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileZainSignatureForm != null) {
      imageFileZainSignatureForm = File(pickedFileZainSignatureForm.path);
      String mimeType = lookupMimeType(pickedFileZainSignatureForm.path);
      if (mimeType == 'image/jpeg') {
        _loadZainSignatureForm = true;

        calculateImageSize(pickedFileZainSignatureForm.path);

        this.setState(() {
          isFileZainSignatureFormFile = false;
          pickedZainSignatureFormExtentionError = false;
          pickedZainSignatureFormFileExtentionError=false;
        });
        _cropImageZainSignatureForm(
            File(pickedFileZainSignatureForm.path));

      }else{
        setState(() {
          pickedZainSignatureFormExtentionError=true;
          pickedZainSignatureFormFileExtentionError=false;

        });
      }
    }

    print('img64ZainSignatureForm');
    print(pickedFileZainSignatureForm.path);
  }

  void pickImageGalleryZainSignatureForm() async {
    pickedFileZainSignatureForm = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileZainSignatureForm != null) {
      imageFileZainSignatureForm = File(pickedFileZainSignatureForm.path);
      String mimeType = lookupMimeType(pickedFileZainSignatureForm.path);
      if (mimeType == 'image/jpeg') {
        _loadZainSignatureForm = true;

        calculateImageSize(pickedFileZainSignatureForm.path);

        this.setState(() {
          isFileZainSignatureFormFile = false;
          pickedZainSignatureFormExtentionError=false;
          pickedZainSignatureFormFileExtentionError=false;
        });
        _cropImageZainSignatureForm(File(pickedFileZainSignatureForm.path));

      }else{
        setState(() {
          pickedZainSignatureFormExtentionError=true;
          pickedZainSignatureFormFileExtentionError=false;
        });
      }
    }
  }

  void pickFileZainSignatureForm() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      File selectedFile = File(result);
      int fileSize = selectedFile.lengthSync(); // Get file size in bytes
      imageFileZainSignatureForm = selectedFile;
      String fileName = path.basename(selectedFile.path);

      if (selectedFile.path.endsWith('.pdf')) {
        List<int> fileBytes = await selectedFile.readAsBytes();
        String base64File = base64Encode(fileBytes);
        this.setState(() {
          isFileZainSignatureFormFile = true;
          pickedZainSignatureFormFileExtentionError=false;
          _loadZainSignatureForm = true;
          pickedFileZainSignatureFormName = fileName;
          img64ZainSignatureForm = "data:application/pdf;base64," + base64File;
        });
      } else {
        setState(() {
          pickedZainSignatureFormFileExtentionError=true;
        });
      }
    }
  }

  void clearImageZainSignatureForm() {
    this.setState(() {
      _loadZainSignatureForm = false;
      pickedFileZainSignatureForm = null;
      pickedFileZainSignatureFormName = '';
      img64ZainSignatureForm='';
      pickedZainSignatureFormExtentionError=false;
      pickedZainSignatureFormFileExtentionError=false;
    });
  }

  _cropImageZainSignatureForm(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /* compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadZainSignatureForm = false;
            pickedFileZainSignatureForm = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64ZainSignatureForm = "data:image/jpg;base64,"+base64Encode(base64Image);
          print('img64Crop: ${img64ZainSignatureForm}');
          imageFileZainSignatureForm = File(cropped.path);
          upload_ZainSignatureForm_API();
        }
      });
    } else {
      this.setState(() {
        _loadZainSignatureForm = false;
        pickedFileZainSignatureForm = null;

        ///here
      });
    }
  }


  Widget buildImageZainContract() {
    return Container(
      color: Colors.white,
      height: imageZainContractRequired == true ? 390 :isFileZainContractFile==true? 396:368 ,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.Zain_Contract".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadZainContract == true
                  ? Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Color(0xff0070c9),
                    onPressed: () => {clearImageZainContract()}),
              )
                  : null,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                margin: EdgeInsets.only(top: 30),
                //padding: EdgeInsets.only(top:30),
                child: _loadZainContract == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        isFileZainContractFile == false
                            ? Container(
                          width: 180,
                          height: 206,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(
                                    imageFileZainContract),
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
                                            FocusScope.of(context)
                                                .unfocus();
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
                                                                imageFileZainContract),
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
                                                color: Color(
                                                    0xFFffffff),
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
                        )
                            : buildDashedBorder(
                          child: Container(
                            width: 180,
                            height: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
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
                                            child: Icon(Icons
                                                .file_open_outlined,
                                              color: Colors.grey,
                                            )),
                                        SizedBox(height: 10),
                                        new Container(
                                            width:140,

                                            child: GestureDetector(
                                              onTap: () async {
                                                await openFile(
                                                    imageFileZainContract
                                                        .path);
                                              },
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  pickedFileZainContractName,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                  maxLines: 1, // Ensures it's on a single line
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
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
                              _showPickerZainContract(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "NewAccountDocumentsChecking.re_attach"
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
                      _showPickerZainContract(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "NewAccountDocumentsChecking.add_attachment1"
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
                                  "NewAccountDocumentsChecking.add_attachment2"
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
                              "NewAccountDocumentsChecking.add_attachment2"
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
            ],
          ),
          imageZainContractRequired == true||pickedZainContractExtentionError==true || pickedZainContractFileExtentionError==true
              ? SizedBox(
            height: 5,
          )
              : SizedBox(),
          imageZainContractRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
          pickedZainContractExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                  .tr()
                  .toString())
              : Container(),

          pickedZainContractFileExtentionError==true ?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_PDF_files_are_allowed"
                  .tr()
                  .toString())
              : Container(),

          imageZainContractRequired == true||pickedZainContractExtentionError==true || pickedZainContractFileExtentionError==true
              ? SizedBox()
              : SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }

  void _showPickerZainContract(context) {
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
                      pickImageCameraZainContract();
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
                      pickImageGalleryZainContract();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFileZainContract();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File"
                              .tr()
                              .toString(),
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

  void pickImageCameraZainContract() async {
    pickedFileZainContract = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileZainContract != null) {
      imageFileZainContract = File(pickedFileZainContract.path);
      String mimeType = lookupMimeType(pickedFileZainContract.path);
      if (mimeType == 'image/jpeg') {
        _loadZainContract = true;

        calculateImageSize(pickedFileZainContract.path);

        this.setState(() {
          isFileZainContractFile = false;
          pickedZainContractExtentionError=false;
          pickedZainContractFileExtentionError=false;
        });
        _cropImageZainContract(File(pickedFileZainContract.path));

      }else{
        setState(() {
          pickedZainContractExtentionError=true;
          pickedZainContractFileExtentionError=false;
        });
      }
    }
  }

  void pickImageGalleryZainContract() async {
    pickedFileZainContract = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileZainContract != null) {
      imageFileZainContract = File(pickedFileZainContract.path);
      String mimeType = lookupMimeType(pickedFileZainContract.path);
      if (mimeType == 'image/jpeg') {
        _loadZainContract = true;

        calculateImageSize(pickedFileZainContract.path);

        this.setState(() {
          isFileZainContractFile = false;
          pickedZainContractExtentionError=false;
          pickedZainContractFileExtentionError=false;
        });
        _cropImageZainContract(File(pickedFileZainContract.path));

      }else{
        setState(() {
          pickedZainContractExtentionError=true;
          pickedZainContractFileExtentionError=false;
        });
      }
    }
  }

  void pickFileZainContract() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      File selectedFile = File(result);
      int fileSize = selectedFile.lengthSync(); // Get file size in bytes
      imageFileZainContract = selectedFile;
      String fileName = path.basename(selectedFile.path);

      if (selectedFile.path.endsWith('.pdf')) {
        List<int> fileBytes = await selectedFile.readAsBytes();
        String base64File = base64Encode(fileBytes);
        this.setState(() {
          isFileZainContractFile = true;
          pickedZainContractFileExtentionError=false;
          _loadZainContract = true;
          pickedFileZainContractName = fileName;
          img64ZainContract = "data:application/pdf;base64," + base64File;
        });
      } else {
        setState(() {
          pickedZainContractFileExtentionError=true;
        });
      }
    }
  }

  void clearImageZainContract() {
    this.setState(() {
      _loadZainContract = false;
      pickedFileZainContract = null;
      pickedFileZainContractName = '';
      img64ZainContract='';
      pickedZainContractExtentionError=false;
      pickedZainContractFileExtentionError=false;
    });
  }

  _cropImageZainContract(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /* compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadZainContract = false;
            pickedFileZainContract = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64ZainContract = "data:image/jpg;base64,"+base64Encode(base64Image);
          print('img64Crop: ${img64ZainContract}');
          imageFileZainContract = File(cropped.path);
          upload_ZainContract_API();
        }
      });
    } else {
      this.setState(() {
        _loadZainContract = false;
        pickedFileZainContract = null;

        ///here
      });
    }
  }



  Widget buildImageImagePersonalID() {
    return Container(
      //color: Colors.blue,
      height: imagePersonalIDRequired == true ? 265 : 263,

      width: MediaQuery.of(context).size.width,

      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.Personal_ID".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadPersonalID == true
                  ? Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Color(0xff0070c9),
                    onPressed: () => {clearImagePersonalID()}),
              )
                  : null,
            ),
          ),
          Container(
            color: Colors.white,
            height: 190,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          // color: Colors.amber,
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: _loadPersonalID == true
                              ? Column(
                            children: [
                              Row(
                                children: [
                                  isFilePersonalIDFile == false
                                      ? Container(
                                    width: 170,
                                    height: 110,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        image: DecorationImage(
                                          colorFilter:
                                          new ColorFilter.mode(
                                              Colors.black
                                                  .withOpacity(
                                                  0.5),
                                              BlendMode
                                                  .dstATop),
                                          image: FileImage(
                                              imageFilePersonalID),
                                          fit: BoxFit.cover,
                                        )),
                                    child:
                                    new Row(children: <Widget>[
                                      Center(
                                        child: new Column(
                                          children: <Widget>[
                                            new Container(
                                              padding:
                                              EdgeInsets.only(
                                                  top: 25,
                                                  left: 70,
                                                  right: 70),
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/images/iconCheck.png'),
                                                fit: BoxFit.cover,
                                                height: 24.0,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            new Container(
                                              child:
                                              GestureDetector(
                                                onTap: () async {
                                                  FocusScope.of(
                                                      context)
                                                      .unfocus();
                                                  showDialog(
                                                      context:
                                                      context,
                                                      builder: (_) =>
                                                          Center(
                                                            // Aligns the container to center
                                                              child:
                                                              Container(
                                                                //color: Colors.deepOrange.withOpacity(0.5),
                                                                child:
                                                                PhotoView(
                                                                  enableRotation:
                                                                  true,
                                                                  backgroundDecoration:
                                                                  BoxDecoration(),
                                                                  imageProvider:
                                                                  FileImage(imageFilePersonalID),
                                                                ),
                                                                // A simplified version of dialog.
                                                                width:
                                                                300.0,
                                                                height:
                                                                350.0,
                                                              )));
                                                },
                                                child: Align(
                                                  alignment:
                                                  Alignment
                                                      .center,
                                                  child: Text(
                                                    "Test.preview_photo"
                                                        .tr()
                                                        .toString(),
                                                    textAlign:
                                                    TextAlign
                                                        .center,
                                                    style:
                                                    TextStyle(
                                                      color: Color(
                                                          0xFFffffff),
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  )
                                      : buildDashedBorder(
                                    child: Container(
                                      width: 170,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: new Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Center(
                                              child: new Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  new Container(
                                                      child: Icon(Icons
                                                          .file_open_outlined,
                                                        color: Colors.grey,
                                                      )),
                                                  SizedBox(
                                                      height: 10),
                                                  new Container(
                                                      width:140,

                                                      child:
                                                      GestureDetector(
                                                        onTap:
                                                            () async {
                                                          await openFile(
                                                              imageFilePersonalID
                                                                  .path);
                                                        },
                                                        child: Align(
                                                          alignment:
                                                          Alignment
                                                              .center,
                                                          child: Text(
                                                            pickedFilePersonalIDName,
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style:
                                                            TextStyle(
                                                              color: Colors.grey,
                                                              fontSize:
                                                              16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                            ),
                                                            maxLines: 1, // Ensures it's on a single line
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                              new Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    width: 170,
                                    padding: EdgeInsets.only(top: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        _showPickerPersonalID(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "NewAccountDocumentsChecking.re_attach"
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
                                _showPickerPersonalID(context);
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
                                          "NewAccountDocumentsChecking.add_attachment1"
                                              .tr()
                                              .toString(),
                                          textAlign:
                                          TextAlign.center,
                                          style: TextStyle(
                                            color:
                                            Color(0xFF0070c9),
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "NewAccountDocumentsChecking.add_attachment2"
                                              .tr()
                                              .toString(),
                                          textAlign:
                                          TextAlign.center,
                                          style: TextStyle(
                                            color:
                                            Color(0xFF0070c9),
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    )
                                        : Text(
                                      "NewAccountDocumentsChecking.add_attachment2"
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
                    imagePersonalIDRequired == true ||pickedPersonalIDExtentionError==true || pickedPersonalIDFileExtentionError==true
                        ? SizedBox(
                      height: 5,
                    )
                        : SizedBox(),
                    imagePersonalIDRequired == true
                        ? ReusableRequiredText(
                        text: "Jordan_Nationality.this_feild_is_required"
                            .tr()
                            .toString())
                        : Container(),
                    pickedPersonalIDExtentionError==true?
                    ReusableRequiredText(
                        text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                            .tr()
                            .toString())
                        : Container(),

                    pickedPersonalIDFileExtentionError==true?
                    ReusableRequiredText(
                        text: "NewAccountDocumentsChecking.Only_PDF_files_are_allowed"
                            .tr()
                            .toString())
                        : Container(),
                    imagePersonalIDRequired == true||pickedPersonalIDExtentionError==true|| pickedPersonalIDFileExtentionError==true
                        ? SizedBox()
                        : SizedBox(
                      height: 10,
                    )
                  ]),
            ),
          ),
        ]),
      ),
    );
  }

  void _showPickerPersonalID(context) {
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
                      pickImageCameraPersonalID();
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
                      pickImageGalleryPersonalID();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFilePersonalID();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File"
                              .tr()
                              .toString(),
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

  void pickImageCameraPersonalID() async {
    pickedFilePersonalID = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFilePersonalID != null) {
      imageFilePersonalID = File(pickedFilePersonalID.path);
      String mimeType = lookupMimeType(pickedFilePersonalID.path);
      if (mimeType == 'image/jpeg') {
        _loadPersonalID = true;


        calculateImageSize(pickedFilePersonalID.path);

        this.setState(() {
          isFilePersonalIDFile = false;
          pickedPersonalIDExtentionError=false;
          pickedPersonalIDFileExtentionError=false;
        });
        _cropImagePersonalID(File(pickedFilePersonalID.path));

      }else{
        setState(() {
          pickedPersonalIDExtentionError=true;
          pickedPersonalIDFileExtentionError=false;
        });
      }
    }
  }

  void pickImageGalleryPersonalID() async {
    pickedFilePersonalID = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFilePersonalID != null) {
      imageFilePersonalID = File(pickedFilePersonalID.path);
      String mimeType = lookupMimeType(pickedFilePersonalID.path);
      if (mimeType == 'image/jpeg') {
        _loadPersonalID = true;

        calculateImageSize(pickedFilePersonalID.path);


        this.setState(() {
          isFilePersonalIDFile = false;
          pickedPersonalIDExtentionError=false;
          pickedPersonalIDFileExtentionError=false;
        });
        _cropImagePersonalID(File(pickedFilePersonalID.path));

      }else{
        setState(() {
          pickedPersonalIDExtentionError=true;
          pickedPersonalIDFileExtentionError=false;
        });
      }
    }
  }

  void pickFilePersonalID() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      File selectedFile = File(result);
      int fileSize = selectedFile.lengthSync(); // Get file size in bytes
      imageFilePersonalID = selectedFile;
      String fileName = path.basename(selectedFile.path);

      if (selectedFile.path.endsWith('.pdf')) {
        List<int> fileBytes = await selectedFile.readAsBytes();
        String base64File = base64Encode(fileBytes);
        this.setState(() {
          isFilePersonalIDFile = true;
          pickedPersonalIDFileExtentionError=false;
          _loadPersonalID = true;
          pickedFilePersonalIDName = fileName;
          img64PersonalID = "data:application/pdf;base64," + base64File;
        });
      } else {
        setState(() {
          pickedPersonalIDFileExtentionError=true;
        });
      }
    }
  }

  void clearImagePersonalID() {
    this.setState(() {
      _loadPersonalID = false;
      pickedFilePersonalID = null;
      pickedFilePersonalIDName = '';
      img64PersonalID='';
      pickedPersonalIDExtentionError=false;
      pickedPersonalIDFileExtentionError=false;

      ///here
    });
  }

  _cropImagePersonalID(File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
        sourcePath: picture.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(
            ratioX: imageWidth.toDouble(), ratioY: imageHeight.toDouble()),
        maxWidth: imageWidth,
        maxHeight: imageHeight);

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadPersonalID = false;
            pickedFilePersonalID = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64PersonalID = "data:image/jpg;base64,"+base64Encode(base64Image);
          print('img64Crop: ${img64PersonalID}');
          imageFilePersonalID = File(cropped.path);
          upload_PersonalID_API();
          //Message.text=img64;
        }
      });
    } else {
      this.setState(() {
        _loadPersonalID = false;
        pickedFilePersonalID = null;

        ///here
      });
    }
  }


  Widget buildImageMUCForm() {
    return Container(
      color: Colors.white,
      height: imageMUCFormRequired == true ? 390 :  isFileMUCFormFile==true? 396:368 ,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.MUC_Form".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadMUCForm == true
                  ? Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Color(0xff0070c9),
                    onPressed: () => {clearImageMUCForm()}),
              )
                  : null,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                margin: EdgeInsets.only(top: 30),
                //padding: EdgeInsets.only(top:30),
                child: _loadMUCForm== true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        isFileMUCFormFile == false
                            ? Container(
                          width: 180,
                          height: 206,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(
                                    imageFileMUCForm),
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
                                            FocusScope.of(context)
                                                .unfocus();
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
                                                                imageFileMUCForm),
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
                                                color: Color(
                                                    0xFFffffff),
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
                        )
                            : buildDashedBorder(
                          child: Container(
                            width: 180,
                            height: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
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
                                            child: Icon(Icons
                                                .file_open_outlined,
                                              color: Colors.grey,
                                            )),
                                        SizedBox(height: 10),
                                        new Container(
                                            width:140,

                                            child: GestureDetector(
                                              onTap: () async {
                                                await openFile(
                                                    imageFileMUCForm
                                                        .path);
                                              },
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  pickedFileMUCFormName,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                  maxLines: 1, // Ensures it's on a single line
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
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
                           //   pickFileMUCForm();
                              _showPickerMUCForm(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "NewAccountDocumentsChecking.re_attach"
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
                      // pickFileMUCForm(); NEW update on 24 Apr 2025
                      _showPickerMUCForm(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "NewAccountDocumentsChecking.add_attachment1"
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
                                  "NewAccountDocumentsChecking.add_attachment2"
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
                              "NewAccountDocumentsChecking.add_attachment2"
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
            ],
          ),
          imageMUCFormRequired == true||pickedMUCFormExtentionError==true || pickedMUCFormFileExtentionError==true
              ? SizedBox(
            height: 5,
          )
              : SizedBox(),
          imageMUCFormRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
          pickedMUCFormExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                  .tr()
                  .toString())
              : Container(),
          pickedMUCFormFileExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_DOC_files_are_allowed"
                  .tr()
                  .toString())
              : Container(),
          imageMUCFormRequired == true||pickedMUCFormExtentionError==true|| pickedMUCFormFileExtentionError==true
              ? SizedBox()
              : SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }

  void _showPickerMUCForm(context) {
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
                      pickImageCameraMUCForm();
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
                      pickImageGalleryMUCForm();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFileMUCForm();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File"
                              .tr()
                              .toString(),
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

  void pickImageCameraMUCForm() async {
    pickedFileMUCForm = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileMUCForm != null) {
      imageFileMUCForm= File(pickedFileMUCForm.path);
      String mimeType = lookupMimeType(pickedFileMUCForm.path);
      if (mimeType == 'image/jpeg') {
        _loadMUCForm = true;

        final bytes =
            File(pickedFileMUCForm.path)
                .readAsBytesSync()
                .lengthInBytes;

        calculateImageSize(pickedFileMUCForm.path);

        this.setState(() {
          isFileMUCFormFile = false;
          pickedMUCFormExtentionError=false;
          pickedMUCFormFileExtentionError=false;
        });
        _cropImageMUCForm(File(pickedFileMUCForm.path));

      }else{
        setState(() {
          pickedMUCFormExtentionError=true;
          pickedMUCFormFileExtentionError=false;
        });
      }
    }
  }

  void pickImageGalleryMUCForm() async {
    pickedFileMUCForm = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileMUCForm != null) {
      imageFileMUCForm = File(pickedFileMUCForm.path);
      String mimeType = lookupMimeType(pickedFileMUCForm.path);
      if (mimeType == 'image/jpeg') {
        _loadMUCForm = true;
        calculateImageSize(pickedFileMUCForm.path);

        this.setState(() {
          isFileMUCFormFile = false;
          pickedMUCFormExtentionError=false;
          pickedMUCFormFileExtentionError=false;

        });
        _cropImageMUCForm(File(pickedFileMUCForm.path));
      }else{
        setState(() {
          pickedMUCFormExtentionError=true;
          pickedMUCFormFileExtentionError=false;
        });
      }
    }
  }

  void pickFileMUCForm() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      File selectedFile = File(result);
      int fileSize = selectedFile.lengthSync(); // Get file size in bytes
      imageFileMUCForm = selectedFile;
      String fileName = path.basename(selectedFile.path);

      if (selectedFile.path.endsWith('.doc') || selectedFile.path.endsWith('.docx')) {
        List<int> fileBytes = await selectedFile.readAsBytes();
        String base64File = base64Encode(fileBytes);
        this.setState(() {
          isFileMUCFormFile = true;
          pickedMUCFormFileExtentionError=false;
          _loadMUCForm = true;
          pickedFileMUCFormName = fileName;
          img64MUCForm = selectedFile.path.endsWith('.doc')
              ? "data:application/msword;base64," + base64File
              : "data:application/vnd.openxmlformats-officedocument.wordprocessingml.document;base64," + base64File;
        });
      } else {
        setState(() {
          pickedMUCFormFileExtentionError=true;
        });
      }
    }
  }

  void clearImageMUCForm() {
    this.setState(() {
      _loadMUCForm = false;
      pickedFileMUCForm= null;
      pickedFileMUCFormName = '';
      img64MUCForm='';
      pickedMUCFormExtentionError=false;
      pickedMUCFormFileExtentionError=false;
    });
  }

  _cropImageMUCForm(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /* compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadMUCForm = false;
            pickedFileMUCForm = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64MUCForm = "data:image/jpg;base64,"+base64Encode(base64Image);
          print('img64Crop: ${img64MUCForm}');
          imageFileMUCForm = File(cropped.path);

          upload_MUCForm_API();
        }
      });
    } else {
      this.setState(() {
        _loadMUCForm = false;
        pickedFileMUCForm = null;

        ///here
      });
    }
  }



  Widget buildImageProofofEmployment() {
    return Container(
      color: Colors.white,
      height: imageProofofEmploymentRequired == true ? 390: isFileProofofEmploymentFile==true? 396:368 ,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Container(
            height: 60,
            color: Color(0xFFEBECF1),
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Container(
                width: 280,
                child: Text(
                  "NewAccountDocumentsChecking.Proof_of_Employment"
                      .tr()
                      .toString(),
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              trailing: _loadProofofEmployment == true
                  ? Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Color(0xff0070c9),
                    onPressed: () => {clearImageProofofEmployment()}),
              )
                  : null,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                margin: EdgeInsets.only(top: 30),
                //padding: EdgeInsets.only(top:30),
                child: _loadProofofEmployment == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        isFileProofofEmploymentFile == false
                            ? Container(
                          width: 180,
                          height: 206,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(
                                    imageFileProofofEmployment),
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
                                            FocusScope.of(context)
                                                .unfocus();
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
                                                                imageFileProofofEmployment),
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
                                                color: Color(
                                                    0xFFffffff),
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
                        )
                            : buildDashedBorder(
                          child: Container(
                            width: 180,
                            height: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
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

                                            child: Icon(Icons
                                                .file_open_outlined,
                                              color: Colors.grey,
                                            )),
                                        SizedBox(height: 10),
                                        new Container(
                                            width:140,

                                            child: GestureDetector(
                                              onTap: () async {
                                                await openFile(
                                                    imageFileProofofEmployment
                                                        .path);
                                              },
                                              child: Align(
                                                alignment:
                                                Alignment.center,
                                                child: Text(
                                                  pickedFileProofofEmploymentName,
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                  ),
                                                  maxLines: 1, // Ensures it's on a single line
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
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
                              _showPickerProofofEmployment(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "NewAccountDocumentsChecking.re_attach"
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
                      _showPickerProofofEmployment(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "NewAccountDocumentsChecking.add_attachment1"
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
                                  "NewAccountDocumentsChecking.add_attachment2"
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
                              "NewAccountDocumentsChecking.add_attachment2"
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
            ],
          ),
          imageProofofEmploymentRequired == true||pickedProofofEmploymentExtentionError==true || pickedProofofEmploymentFileExtentionError==true
              ? SizedBox(
            height: 5,
          )
              : SizedBox(),
          imageProofofEmploymentRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
          pickedProofofEmploymentExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_JPG_images_are_allowed"
                  .tr()
                  .toString())
              : Container(),

          pickedProofofEmploymentFileExtentionError==true?
          ReusableRequiredText(
              text: "NewAccountDocumentsChecking.Only_PDF_files_are_allowed"
                  .tr()
                  .toString())
              : Container(),
          imageProofofEmploymentRequired == true||pickedProofofEmploymentExtentionError==true || pickedProofofEmploymentFileExtentionError==true
              ? SizedBox()
              : SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }

  void _showPickerProofofEmployment(context) {
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
                      pickImageCameraProofofEmployment();
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
                      pickImageGalleryProofofEmployment();
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
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickFileProofofEmployment();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.drive_folder_upload,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "NewAccountDocumentsChecking.Choose_File"
                              .tr()
                              .toString(),
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

  void pickImageCameraProofofEmployment() async {
    pickedFileProofofEmployment = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileProofofEmployment != null) {
      imageFileProofofEmployment = File(pickedFileProofofEmployment.path);
      String mimeType = lookupMimeType(pickedFileProofofEmployment.path);
      if (mimeType == 'image/jpeg') {
        _loadProofofEmployment = true;



        calculateImageSize(pickedFileProofofEmployment.path);

        this.setState(() {
          isFileProofofEmploymentFile = false;
          pickedProofofEmploymentExtentionError=false;
          pickedProofofEmploymentFileExtentionError=false;
        });
        _cropImageProofofEmployment(File(pickedFileProofofEmployment.path));
      }else{
        setState(() {
          pickedProofofEmploymentExtentionError=true;
          pickedProofofEmploymentFileExtentionError=false;
        });
      }
    }
  }

  void pickImageGalleryProofofEmployment() async {
    pickedFileProofofEmployment = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileProofofEmployment != null) {
      imageFileProofofEmployment = File(pickedFileProofofEmployment.path);
      String mimeType = lookupMimeType(pickedFileProofofEmployment.path);
      if (mimeType == 'image/jpeg') {
        _loadProofofEmployment = true;
        calculateImageSize(pickedFileProofofEmployment.path);

        this.setState(() {
          isFileProofofEmploymentFile = false;
          pickedProofofEmploymentExtentionError=false;
          pickedProofofEmploymentFileExtentionError=false;
        });
        _cropImageProofofEmployment(File(pickedFileProofofEmployment.path));
      }else{
        setState(() {
          pickedProofofEmploymentExtentionError=true;
          pickedProofofEmploymentFileExtentionError=false;
        });
      }
    }
  }

  void pickFileProofofEmployment() async {
    final result = await FlutterDocumentPicker.openDocument();

    if (result != null) {
      File selectedFile = File(result);
      int fileSize = selectedFile.lengthSync(); // Get file size in bytes
      imageFileProofofEmployment = selectedFile;
      String fileName = path.basename(selectedFile.path);

      if (selectedFile.path.endsWith('.pdf')) {
        List<int> fileBytes = await selectedFile.readAsBytes();
        String base64File = base64Encode(fileBytes);
        this.setState(() {
          isFileProofofEmploymentFile = true;
          pickedProofofEmploymentFileExtentionError=false;
          _loadProofofEmployment = true;
          pickedFileProofofEmploymentName = fileName;
          img64ProofofEmployment = "data:application/pdf;base64," + base64File;
        });
      } else {
        setState(() {
          pickedProofofEmploymentFileExtentionError=true;
        });
      }
    }
  }

  void clearImageProofofEmployment() {
    this.setState(() {
      _loadProofofEmployment = false;
      pickedFileProofofEmployment = null;
      pickedFileProofofEmploymentName= '';
      img64ProofofEmployment='';
      pickedProofofEmploymentExtentionError=false;
      pickedProofofEmploymentFileExtentionError=false;



    });
  }

  _cropImageProofofEmployment(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /* compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadProofofEmployment = false;
            pickedFileProofofEmployment = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64ProofofEmployment = "data:image/jpg;base64,"+base64Encode(base64Image);

          imageFileProofofEmployment = File(cropped.path);
          upload_ProofofEmployment_API();
        }
      });
    } else {
      this.setState(() {
        _loadProofofEmployment = false;
        pickedFileProofofEmployment = null;

        ///here
      });
    }
  }

  void printLongText(String text) {
    final pattern = RegExp('.{1,800}'); // Splitting into chunks of 800 chars
    for (var match in pattern.allMatches(text)) {
      print(match.group(0)); // Print each chunk separately
    }
  }

  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
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
            setState(() {
              // disableContinue=false;
              //errorICCID = false;
              //errormsisdn=false;
            });
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
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogSuccess(BuildContext context, arabicMessage, englishMessage) {
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

            if(role=="Reseller"){
              Navigator.of(context).pop();
              setState(() {
                ocrFormType='';
                ocrFormType=null;
              });

            }else{

              Navigator.of(context).pop();
              setState(() {});
            }

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
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Update_OCR_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/uploadV2';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "campaingType": ocrFormType,
      "corporate_Registration_Certificate": img64RegistrationCertificate,
      "carrier_License_Certificate": img64CarrierLicenseCertificate,
      "zain_Authorization_Letter": img64ZainAuthorizationLetter,
      "zain_Signature_Form": img64ZainSignatureForm,
      "zain_Contract": img64ZainContract,
      "personal_ID": img64PersonalID,
      "muC_Form": img64MUCForm,
      "proof_of_Employment": img64ProofofEmployment
    };

    print("..........Body /OCR/uploadV2...............");
    print(body);
    print("..........Body /OCR/uploadV2...............");

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));

    printLongText(jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogSuccess(
              context, result["messageAr"], result["message"]);
        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  upload_RegistrationCertificate_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/UploadFragment';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "fileContent": img64RegistrationCertificate,
      "fileName": "Corporate Registration Certificate",

    };

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));

    printLongText(jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
            img64RegistrationCertificate=result["data"];
          });

        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  upload_CarrierLicenseCertificate_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/UploadFragment';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "fileContent": img64CarrierLicenseCertificate,
      "fileName": "Carrier License Certificate",

    };

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));

    printLongText(jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
            img64CarrierLicenseCertificate=result["data"];
          });

        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  upload_ZainAuthorizationLetter_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/UploadFragment';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "fileContent": img64ZainAuthorizationLetter,
      "fileName": "Zain Authorization Letter",

    };

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));

    printLongText(jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
            img64ZainAuthorizationLetter=result["data"];
          });

        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  upload_ZainSignatureForm_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/UploadFragment';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "fileContent": img64ZainSignatureForm,
      "fileName": "Zain Signature Form",

    };

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));

    printLongText(jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
            img64ZainSignatureForm=result["data"];
          });

        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  upload_ZainContract_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/UploadFragment';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "fileContent": img64ZainContract,
      "fileName": "Zain Contract",


    };

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));

    printLongText(jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
            img64ZainContract=result["data"];
          });

        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  upload_PersonalID_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/UploadFragment';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "fileContent": img64PersonalID,
      "fileName": "Personal ID",

    };

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));

    printLongText(jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
            img64PersonalID=result["data"];
          });

        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  upload_MUCForm_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/UploadFragment';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "fileContent": img64MUCForm,
      "fileName": "MUC Form",

    };

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));

    printLongText(jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
            img64MUCForm=result["data"];
          });

        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  upload_ProofofEmployment_API() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/OCR/UploadFragment';
    final Uri url = Uri.parse(apiArea);
    print(url);

    Map body = {
      "fileContent": img64ProofofEmployment,
      "fileName": "Proof of Employment",
    };

    final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body));


    int statusCode = response.statusCode;
    print(statusCode);
    if(response.body.isNotEmpty) {
      var result = json.decode(response.body);
      if (statusCode == 401) {
        print('401  error ');
        this.setState(() {
          isLoading = false;
        });
        UnotherizedError();
      } else if (statusCode == 200) {
        if (result['status'] == 0) {
          this.setState(() {
            isLoading = false;
            img64ProofofEmployment=result["data"];
          });

        } else {
          this.setState(() {
            isLoading = false;
          });
          showAlertDialogError(context, result["messageAr"], result["message"]);
        }
        print('result');
        print(result);
      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        this.setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTicketBloc, CreateTicketState>(
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                leading:role=="Corporate"?
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  //tooltip: 'Menu Icon',
                  onPressed: () {
                    Navigator.pop(context);

                  },
                ):null,
                centerTitle: false,
                title: Text(
                    "NewAccountDocumentsChecking.newAccountDocumentsChecking"
                        .tr()
                        .toString()),
                actions: <Widget>[
                  /*********************************************************************New 27-2-2025********************************************************************/
                  /*****************************************************************New Account Documents Checking screen******************************************************************/
                  role=="Reseller"?   IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () =>
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Settings(PermessionCorporate,role)


                            )
                        )
                      } ):SizedBox()


                ],
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body: ListView(padding: EdgeInsets.only(top: 0), children: <Widget>[
                buildOCRFormType(),
                (ocrFormType == "NationalNumber_200" ||
                    ocrFormType == "NationalNumber_100") ==
                    true
                    ? buildImageRegistrationCertificate()
                    : SizedBox(),
                (ocrFormType == "NationalNumber_200" ||
                    ocrFormType == "NationalNumber_100") ==
                    true
                    ? buildImageCarrierLicenseCertificate()
                    : SizedBox(),
                (ocrFormType == "NationalNumber_200" ||
                    ocrFormType == "NationalNumber_100") ==
                    true
                    ? buildImageZainAuthorizationLetter()
                    : SizedBox(),
                (ocrFormType == "NationalNumber_200" ||
                    ocrFormType == "NationalNumber_100") ==
                    true
                    ? buildImageZainSignatureForm()
                    : SizedBox(),
                ocrFormType == "MUC_MUC" ? buildImageMUCForm() : SizedBox(),
                ocrFormType == "MUC_MUC"
                    ? buildImageProofofEmployment()
                    : SizedBox(),
                (ocrFormType == "NationalNumber_200" ||
                    ocrFormType == "NationalNumber_100" ||
                    ocrFormType == "MUC_MUC") ==
                    true
                    ? buildImageZainContract()
                    : SizedBox(),
                (ocrFormType == "NationalNumber_200" ||
                    ocrFormType == "NationalNumber_100" ||
                    ocrFormType == "MUC_MUC") ==
                    true
                    ? buildImageImagePersonalID()
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                showloading == true ? msg() : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                (ocrFormType != '' && ocrFormType != null)
                    ? Container(
                    height: 48,
                    width: 300,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: showloading == true ? Color(0xFF4f2565).withOpacity(0.5): Color(0xFF4f2565),
                    ),
                    child: TextButton(

                      style: TextButton.styleFrom(
                        //backgroundColor: showloading == true ? Color(0xFF4f2565): Color(0xFF4f2565),
                        shape: const BeveledRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(24))),
                      ),
                      onPressed: showloading == true?null: () async {
                        if (ocrFormType == null) {
                          setState(() {
                            emptyOCRForm = true;
                          });
                        }
                        if (ocrFormType != null) {
                          setState(() {
                            emptyOCRForm = false;
                          });
                        }


                        print("img64ZainSignatureForm");
                        print(img64ZainSignatureForm);
                        if (ocrFormType == "NationalNumber_200" ||
                            ocrFormType == "NationalNumber_100") {
                          if (pickedFileRegistrationCertificate == '' ||
                              img64CarrierLicenseCertificate == "" ||
                              img64ZainAuthorizationLetter == "" ||
                              img64ZainSignatureForm == "" ||
                              img64ZainContract == '' ||
                              img64PersonalID == '') {
                            if (img64RegistrationCertificate == '') {
                              setState(() {
                                imageRegistrationCertificateRequired = true;
                              });
                            } else {
                              setState(() {
                                imageRegistrationCertificateRequired = false;
                              });
                            }

                            if (img64CarrierLicenseCertificate == '') {
                              setState(() {
                                imageCarrierLicenseCertificateRequired = true;
                              });
                            } else {
                              setState(() {
                                imageCarrierLicenseCertificateRequired = false;
                              });
                            }

                            if (img64ZainAuthorizationLetter == '') {
                              setState(() {
                                imageZainAuthorizationLetterRequired = true;
                              });
                            } else {
                              setState(() {
                                imageZainAuthorizationLetterRequired = false;
                              });
                            }

                            if (img64ZainSignatureForm == '') {
                              setState(() {
                                imageZainSignatureFormRequired = true;
                              });
                            } else {
                              setState(() {
                                imageZainSignatureFormRequired = false;
                              });
                            }

                            if (img64ZainContract == '') {
                              setState(() {
                                imageZainContractRequired = true;
                              });
                            } else {
                              setState(() {
                                imageZainContractRequired = false;
                              });
                            }

                            if (img64PersonalID == '') {
                              setState(() {
                                imagePersonalIDRequired = true;
                              });
                            } else {
                              setState(() {
                                imagePersonalIDRequired = false;
                              });
                            }
                          } else {
                            print(" ///// calling api");
                            Update_OCR_API();
                          }
                        } else if (ocrFormType == "MUC_MUC") {
                          if (img64MUCForm == '' ||
                              img64ProofofEmployment == "" ||
                              img64ZainContract == '' ||
                              img64PersonalID == '') {
                            if (img64MUCForm == '') {
                              setState(() {
                                imageMUCFormRequired = true;
                              });
                            } else {
                              setState(() {
                                imageMUCFormRequired = false;
                              });
                            }

                            if (img64ProofofEmployment == '') {
                              setState(() {
                                imageProofofEmploymentRequired = true;
                              });
                            } else {
                              setState(() {
                                imageProofofEmploymentRequired = false;
                              });
                            }

                            if (img64ZainContract == '') {
                              setState(() {
                                imageZainContractRequired = true;
                              });
                            } else {
                              setState(() {
                                imageZainContractRequired = false;
                              });
                            }

                            if (img64PersonalID == '') {
                              setState(() {
                                imagePersonalIDRequired = true;
                              });
                            } else {
                              setState(() {
                                imagePersonalIDRequired = false;
                              });
                            }
                          } else {
                            print(" ///// calling api");
                            Update_OCR_API();
                          }
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
                    ))
                    : SizedBox(),
                (ocrFormType != '' && ocrFormType != null)
                    ? SizedBox(height: 30)
                    : SizedBox(),
              ]),
            ),
            // ✅ Loading overlay
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CupertinoColors.lightBackgroundGray,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
