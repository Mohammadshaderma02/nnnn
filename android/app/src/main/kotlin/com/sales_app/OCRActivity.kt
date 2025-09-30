//Creted By Haya Hazaimeh @ 28 April 2024
package com.sales_app
import androidx.navigation.Navigator
//package com.euronovate.mobile.ocrvision.sample
import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.view.WindowCompat
//import com.euronovate.mobile.ocrvision.sample.ui.theme.ENVisionMobileSampleTheme
import com.sales_app.ui.theme.ENVisionMobileSampleTheme;
import dagger.hilt.android.AndroidEntryPoint
import android.util.Log
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.FlutterEngine
@AndroidEntryPoint
class OCRActivity : ComponentActivity() {
    private lateinit var resultChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("OCRActivity.kt", "13 May 2024 OCRActivity.kt")
        // Initialize the MethodChannel here
        val context = applicationContext
        val flutterEngine = FlutterEngine(context)
        resultChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "NativeChannel")

        super.onCreate(savedInstanceState)

        WindowCompat.setDecorFitsSystemWindows(window, false)

        setContent {
            ENVisionMobileSampleTheme {
                SampleScreenContainerOCR()
            }
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R && ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(
                this@OCRActivity,
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE),
                100
            )
        }
    }


}

