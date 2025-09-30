package com.sales_app

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

@AndroidEntryPoint
class SampleActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("SampleActivity.kt", "13 May 2024 SampleActivity.kt")

        super.onCreate(savedInstanceState)

        // https://arkadiuszchmura.com/posts/how-to-draw-content-behind-system-bars-in-jetpack-compose/
        // This will lay out our app behind the system bars
        WindowCompat.setDecorFitsSystemWindows(window, false)

        setContent {
            ENVisionMobileSampleTheme {
                SampleScreenContainer()
            }
        }

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R && ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(
                this@SampleActivity,
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE),
                100
            )
        }
    }
}