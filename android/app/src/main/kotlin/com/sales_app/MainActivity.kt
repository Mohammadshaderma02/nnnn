package com.sales_app_zainjo
import androidx.navigation.Navigator

import dagger.hilt.android.AndroidEntryPoint
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.content.Intent
import com.sales_app.ApplicationContext
import com.sales_app.SampleActivity
import com.sales_app.OCRActivity
import com.sales_app.LivenessActivity
import com.sales_app.ui.screen.SampleHomeViewModel
import com.euronovate.mobile.ocr.ENMobileOcrSDK
import com.euronovate.mobile.vision.ENMobileVisionSDK
import android.content.Context
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.activity.viewModels
import com.sales_app.ui.screen.SampleHomeScreen
import androidx.navigation.compose.rememberNavController
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import com.sales_app.SampleScreens
import androidx.hilt.navigation.compose.hiltViewModel
import com.sales_app.SampleScreenContainerOCR
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.runtime.rememberCoroutineScope
import androidx.core.content.ContextCompat
import com.sales_app.SampleScreenContainerViewModel
import com.sales_app_zainjo.R
import kotlinx.coroutines.launch
import org.json.JSONObject
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler



@AndroidEntryPoint
class MainActivity: FlutterFragmentActivity() {

    private val CHANNEL = "NativeChannel"
    private val viewModel: SampleHomeViewModel by viewModels()
    private lateinit var navController: NavHostController



    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val ocrSdk: ENMobileOcrSDK? = null // Initialize or inject your ENMobileOcrSDK instance
        val visionSdk: ENMobileVisionSDK? = null



        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method=="InitSDK"){

                 viewModel.initSdk(getAppContext()) // Call initSdk on injected viewModel
            }
            if(call.method =="OCRSDK"){

                val intent = Intent(this, OCRActivity::class.java)
                val dataToSend = "Data from Android haya hazaimeh Quis"
                startActivity(intent)

                result.success(dataToSend);


            }
           if(call.method=="NativeChannel"){

             //   navController.navigate(SampleScreens.SampleOcrMrzScreen.route)

                val intent = Intent(this, SampleActivity::class.java)
                 startActivity(intent)
                 // viewModel.initSdk(getAppContext()) // Call initSdk on injected viewModel

                // initSdk(context = context)
                // SampleHomeViewModel(ocrSdk, visionSdk).initSdk(this)

                result.success(null);
            }



            if (call.method == "getOcrResult") {
                val sharedPreferences = getSharedPreferences("com.sales_app", Context.MODE_PRIVATE)
                val uuid = sharedPreferences.getString("uuid_key", null)
                val documentNumber = sharedPreferences.getString("documentNumber_key", null)
                val documentIssuingCountry = sharedPreferences.getString("documentIssuingCountry_key", null)
                val userGivenNames = sharedPreferences.getString("userGivenNames_key", null)
                val localUserGivenNames = sharedPreferences.getString("localUserGivenNames_key", null)
                val userPicture = sharedPreferences.getString("userPicture_key", null)
                val cropped = sharedPreferences.getString("cropped_key", null)
                val idFront = sharedPreferences.getString("IDfront_key", null)
                val idBack = sharedPreferences.getString("IDback_key", null)

                val uuidResult =uuid
                if (uuidResult != null) {
                    result.success("$uuid,$documentNumber,$idFront,$idBack")
                } else {
                    result.error("UNAVAILABLE", "OCR result is not available.", null)
                }
               // finish();

            }




            if (call.method == "LivenessSDK") {
                val intent = Intent(this, LivenessActivity::class.java)
                val dataToSend = "Data from Android haya hazaimeh LivenessActivity"
                startActivity(intent)

                result.success(dataToSend);

            }
            // This method is invoked on the main thread.
            // TODO
        }


    }
    private fun getAppContext(): Context {
        return this.applicationContext // Assuming getAppContext() provides the correct context
    }



}

