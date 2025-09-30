import 'package:flutter/material.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';

class StepProgressIndicator extends StatefulWidget {
  @override
  _StepProgressIndicatorState createState() => _StepProgressIndicatorState();
}

class _StepProgressIndicatorState extends State<StepProgressIndicator> {

  int _currentStep = 1; // Set the initial step to 1 (first step will be active)

  // Method to get the step text based on the current step
  String getStepText() {
    switch (_currentStep) {
      case 1:
        return "Scan Simcard barcode";
      case 2:
        return "Terms and Conditions";
      case 3:
        return "Check Identity";
      case 4:
        return "Liveness Test";
      case 5:
        return "Documented";
      case 6:
        return "Unknown Step";
    // Add more cases if needed
      default:
        return "Unknown Step";
    }
  }

  // Variable to control which screen to show
  int _currentScreenIndex = 0; // 0 -> ScreenOne, 1 -> ScreenTwo, 2 -> ScreenThree

  int getScreen() {
    switch (_currentStep) {
      case 1:
        setState(() {
          _currentScreenIndex = 0;
        });
        return 0;

    // Add more cases if needed
      default:
        return 1;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back arrow automatically
        title: Row(
          children: [
            Column(
              children: [
                Text('$_currentStep',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
              ],
            ),
            Text('/6',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(width: 8),
            Text( getStepText(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),


          ],
        ),
        elevation: 0,
        backgroundColor: ekycColors.primary, // Remove the shadow from the AppBar
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(0), // Optional padding
            decoration: BoxDecoration(
              color:  ekycColors.primary, // Set your desired background color
              borderRadius: BorderRadius.circular(0), // Optional: rounded corners
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                bool isActive = index < _currentStep; // Mark steps active until the current one
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 6,
                          color: isActive ? ekycColors.buttonSecondary : ekycColors.secondary,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),


          Expanded(
            child: IndexedStack(
              index: _currentScreenIndex, // Show the screen based on the index
              children: [
               /// Terms_Conditions(),

              ],
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.only(left: 16, right: 16,top: 16),
            child: Center(
              child:

              Text('Select sim type',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),*/// This makes the progress indicator take the top space
         // Expanded(child: Container()),
          // Row with two buttons
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 25),
            child: Row(
              children: [
                // First button (Back)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // Remove the shadow
                      primary: ekycColors.buttonPrimary, // Change the button color here
                    ),
                    onPressed: () {
                      setState(() {
                        if (_currentStep > 1) {
                          _currentStep--;
                        } else {
                          // If at step 1, go back to the previous screen
                          Navigator.pop(context);
                        }
                        getScreen();
                        print("Back Step: " + _currentStep.toString());
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.white), // Icon before text
                        SizedBox(width: 8), // Space between icon and text
                        Text('Back', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16), // Space between buttons

                // Second button (Next)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // Remove the shadow
                      primary: ekycColors.buttonPrimary, // Change the button color here
                    ),
                    onPressed: () {
                      setState(() {
                        if (_currentStep < 6) { // Ensure the last step is 6
                          _currentStep++;
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8), // Space between icon and text
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.white), // Icon before text

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
