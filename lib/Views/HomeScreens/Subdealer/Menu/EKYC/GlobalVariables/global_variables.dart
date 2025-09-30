class GlobalVariables {
  // Singleton Instance
  static final GlobalVariables _instance = GlobalVariables._internal();
  factory GlobalVariables() => _instance;
  GlobalVariables._internal();
  // Your Variables
  int currentStep = 1; // Set the initial step to 1 (first step will be active), this for step counter in EKYC process (1-6)
  int currentScreen=0; // Set the number of screen inside the step

  int currentScreenIndex=0;//Variable to control which screen to show
  int indexSteper=1;
  bool enterEmail=false;
  bool nationality=true;
  bool isGSMSelected=true;
  bool isDATASelected=false;
  String marketType="GSM";
  String lineType="";
  String numberSelected;
  String simCard;
  String referanceNumber;
  int selectedItemIndex=-1;
  bool reservedNumber=false;
  bool termCondition1= false;
  bool termCondition2= false;
  String referanceNumberPredefined;
  bool goToTermCondition=false;
  var permessionsChangePackage=[];
  String roleChangePackage;
  String outDoorUserNameChangePackage;
  bool sanadValidation = false;
  bool joDocType= false;
  bool activeSimTypeNextStep = false;
  bool activeESimTypeNextStep = false;
  bool isEsimSelected = false;
  bool isPhysicalSimSelected = true;
  bool tackID = false;
  bool tackJordanPassport=false;
  String userEmail="";
  bool isEsim=false;
  bool sanadAuthorization= false;
  String terminalID ="";
  String merchantID="";
  String otp_ekyc="";
  String referanceNumber_otp="";

  String sanadValue="";


  List<String> capturedPaths = [];
  List<String> capturedBase64 = [];
  bool isValidIdentification = false; // if tack id forn and back success

  String capturedPathsMRZ="";
  String capturedBase64MRZ="";
  bool isValidPassportIdentification = false; // if tack passport success


  bool tackTemporary = false;
  bool tackForeign=false;

  String sessionUid = "";
  String tokenID = "";
  String tokenUid = "";
  String eKycUid = "";


  String capturedPathsTemporary="";
  String capturedBase64Temporary="";
  bool isValidTemporaryIdentification = false; // if tack Temporary passport success

  String capturedPathsForeign="";
  String capturedBase64Foreign="";
  bool isValidForeignIdentification = false; // if tack Foreign passport success

  bool showForeignPassport=false;

  String ekycTokenID="";

  String fullNameAr="";
  String fullNameEn="";
  String natinalityNumber="";
  String cardNumber="";
  String birthdate="";
  String expirayDate="";
  String gender="";
  String bloodGroup="";
  String registrationNumber="";

  bool isValidLivness=false;
  bool showPersonalNumber=false;
  String videoPathForUpload="";


  String videoPathUploaded="";






  // Add more variables as needed

}

// Access in any screen
final globalVars = GlobalVariables();
