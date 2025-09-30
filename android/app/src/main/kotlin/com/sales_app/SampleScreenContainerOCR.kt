//SampleScreenContainerOCR.
package com.sales_app
import androidx.activity.ComponentActivity
import android.app.Activity
//package com.euronovate.mobile.ocrvision.sample

import android.net.Uri
import android.provider.MediaStore
import android.util.Log
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Scaffold
import androidx.compose.material.ScaffoldState
import androidx.compose.material.Text
import androidx.compose.material.rememberScaffoldState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.euronovate.mobile.ocr.ENMobileOcrSDK
//import com.euronovate.mobile.ocrvision.sample.ui.BackendServiceResult
//import com.euronovate.mobile.ocrvision.sample.ui.screen.SampleHomeScreen
//import com.euronovate.mobile.ocrvision.sample.ui.screen.widgets.TopBar
//import com.euronovate.mobile.ocrvision.sample.ui.theme.ENBackgroundBlack
//import com.euronovate.mobile.ocrvision.sample.ui.theme.LocalColors
//import com.euronovate.mobile.ocrvision.sample.ui.theme.LocalTypography
import com.sales_app.ui.BackendServiceResult
import com.sales_app.ui.screen.SampleHomeScreen
import com.sales_app.ui.screen.widgets.TopBar
import com.sales_app.ui.theme.ENBackgroundBlack
import com.sales_app.ui.theme.LocalColors
import com.sales_app.ui.theme.LocalTypography
import com.euronovate.mobile.vision.ENMobileVisionSDK
import com.sales_app_zainjo.R
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine



import android.content.SharedPreferences;


import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

import android.content.Context
private lateinit var resultChannel: MethodChannel

private const val SAMPLE_SCREEN_CONTAINER_TAG = "ENMobileOcrVisionSDK-SampleScreenContainerOCR"

private val CHANNEL = "NativeChannel"

@Composable
fun SampleScreenContainerOCR(
    sampleScreenContainerViewModel: SampleScreenContainerViewModel = hiltViewModel(),
) {
    // Initialize the MethodChannel
    val context = LocalContext.current
    val flutterEngine = FlutterEngine(context)
    resultChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "MethodChannel initialized successfully")

    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Result: Digital chanel")
    val navController = rememberNavController()
    val scaffoldState: ScaffoldState = rememberScaffoldState()


    val viewState by sampleScreenContainerViewModel.state.collectAsState()

    val navBackStackEntry by navController.currentBackStackEntryAsState()
    navBackStackEntry?.destination?.route?.run(sampleScreenContainerViewModel::onDestinationChanged)

    Scaffold(
        scaffoldState = scaffoldState,
        backgroundColor = LocalColors.current.background,
        topBar = {

            AnimatedVisibility(
                visible = viewState.isTopAppBarVisible,
                exit = slideOutVertically() + shrinkVertically() + fadeOut(),
                enter = slideInVertically() + expandVertically() + fadeIn(),
            ) {

                TopBar()
            }
        },
        /* bottomBar = {

             AnimatedVisibility(
                 visible = viewState.isBottomAppBarVisible,
                 exit = slideOutVertically() + shrinkVertically() + fadeOut(),
                 enter = slideInVertically() + expandVertically() + fadeIn(),
             ) {

                 Box(
                     modifier = Modifier
                         .fillMaxWidth()
                         .background(ENBackgroundBlack)
                         .navigationBarsPadding(),
                     contentAlignment = Alignment.BottomCenter,
                 ) {

                     Text(
                         modifier = Modifier.padding(all = 10.dp),
                         text = stringResource(id = R.string.all_rights_reserved),
                         style = LocalTypography.current.sampleWhiteTextBottomBar
                     )
                 }
             }
         },*/
    ) {
        SampleScreenNavigationConfigurations(viewModel = sampleScreenContainerViewModel, navController = navController, paddingValues = it)
    }
}

@Composable
private fun SampleScreenNavigationConfigurations(
    viewModel: SampleScreenContainerViewModel,
    navController: NavHostController,
    paddingValues: PaddingValues
) {
    //Start from her
    NavHost(navController = navController, startDestination = SampleScreens.SampleOcrMrzScreen.route) {

        composable(SampleScreens.SampleHomeScreen.route) {
            InitHome(paddingValues = paddingValues, navController)
        }

        composable(SampleScreens.SampleOcrMrzScreen.route) {
              InitOcrMrz(viewModel = viewModel, navController,resultChannel)
        }

        composable(SampleScreens.SampleLivenessScreen.route) {
            InitLiveness(facematchImageUri = null, viewModel = viewModel, navController)
        }

        composable(route = SampleScreens.BackendServiceResultScreen.route)
        {
            InitBackendServiceResult(
                result = navController.previousBackStackEntry?.savedStateHandle?.get<String>("result") ?: "",
                navController
            )
        }
    }
}

@Composable
private fun InitHome(paddingValues: PaddingValues, navController: NavHostController) {

    SampleHomeScreen(
        paddingValues = paddingValues,
        goToOcrMrz = { navController.navigate(SampleScreens.SampleOcrMrzScreen.route) },
        goToLivenessConfig = { navController.navigate(SampleScreens.SampleLivenessScreen.route) },
    )
}

@Composable
private fun InitOcrMrz(viewModel: SampleScreenContainerViewModel, navController: NavHostController, resultChannel: MethodChannel) {
    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Result: InitOcrMrz InitOcrMrz InitOcrMrz InitOcrMrz ")
    val context = LocalContext.current
    var result: String? = null

    val activity = context as ComponentActivity



    viewModel.ocrSdk.Read(
        documentCountry = "jor",
        documentType = "idc",
        documentVersion = 1,
        returnAcquiredImage = true,
        onBackPressed = {
            //navController.popBackStack()
            activity.finish()
        },
        onResult = {
            when (it) {
                ENMobileOcrSDK.OcrResult.Cancel -> Unit
                is ENMobileOcrSDK.OcrResult.Error -> {
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Result: ${it.error.message}")
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Result: HAYA HAZAIMEH")

                    result = it.error.message.toString()
                }

                is ENMobileOcrSDK.OcrResult.Ok -> {
                    val json = JSONObject(it.result)
                    val uuid = json.getString("uuid")
                    val documentNumber = json.getString("documentNumber")
                    val documentIssuingCountry = json.getString("documentIssuingCountry")
                    val userGivenNames = json.getString("userGivenNames")
                    val localUserGivenNames = json.getString("localUserGivenNames")
                    val userPicture = json.getString("userPicture")
                    val cropped =json.getString("cropped")
                    var idFront =json.getJSONObject("cropped").getString("front")
                    var idBack =json.getJSONObject("cropped").getString("back")
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "IDBack: $idBack")
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "IDFront: $idFront")
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "UUID: $uuid")
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Result: ${it.result}")
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Result: HAYA  HAZAIMEHHAZAIMEHHAZAIMEH")
                    resultChannel.invokeMethod("getOcrResult", it.result)

                    // Save val to SharedPreferences
                    val sharedPreferences = context.getSharedPreferences("com.sales_app", Context.MODE_PRIVATE)
                    with (sharedPreferences.edit()) {
                        putString("uuid_key", uuid)
                        putString("documentNumber_key", documentNumber)
                        putString("documentIssuingCountry_key", documentIssuingCountry)
                        putString("userGivenNames_key", userGivenNames)
                        putString("localUserGivenNames_key", localUserGivenNames)
                        putString("userPicture_key", userPicture)
                        putString("cropped_key", cropped)
                        putString("IDfront_key", idFront)
                        putString("IDback_key", idBack)

                        apply()
                    }
                    result = it.result


                }

                ENMobileOcrSDK.OcrResult.IssueWithImages -> {
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Error managing images")
                    result = "Error managing images"
                }

                ENMobileOcrSDK.OcrResult.SdkNotInitialized -> {
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "SDK not initialized")
                }

                ENMobileOcrSDK.OcrResult.DocumentNotSupported -> {
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Document not supported")
                }

                ENMobileOcrSDK.OcrResult.CannotGetSupportedDocuments -> {
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Cannot get supported documents")
                }
            }

            result?.let{
                Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Befor Result")

                activity.finish()
                Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "After Result")
            }
            /* result?.let {

                 navController.currentBackStackEntry?.savedStateHandle?.set("result", result)
                 navController.navigate(SampleScreens.BackendServiceResultScreen.parentRoute)
             }*/

        },
    )
}

@Composable
private fun InitLiveness(facematchImageUri: Uri?, viewModel: SampleScreenContainerViewModel, navController: NavHostController) {

    var result: String? = null
    val context = LocalContext.current

    val faceMatchImageAndThreshold = facematchImageUri?.let {
        Pair(MediaStore.Images.Media.getBitmap(context.contentResolver, it), 0.6)
    }


    viewModel.visionSdk.Liveness(
        acquisitionDurationSeconds = 5,
        threshold = 0.8,
        faceMatchImageAndThreshold = faceMatchImageAndThreshold,
        phrases = null,
        onResult = {
            when (it) {
                ENMobileVisionSDK.LivenessResult.Cancel -> Unit
                is ENMobileVisionSDK.LivenessResult.Error -> {
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Result: ${it.error.message}")
                    result = it.error.message.toString()
                }

                is ENMobileVisionSDK.LivenessResult.Ok -> {
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Result: ${it.livenessResult}")
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "Path of the video: ${it.livenessVideoPath}")
                    result = it.livenessResult
                }

                ENMobileVisionSDK.LivenessResult.SdkNotInitialized -> {
                    Log.w(SAMPLE_SCREEN_CONTAINER_TAG, "SDK not initialized")
                }
            }

            facematchImageUri?.let {
                navController.popBackStack()
            } ?: run {
                navController.popBackStack()
            }
            result?.let {
                navController.currentBackStackEntry?.savedStateHandle?.set("result", result)
                navController.navigate(SampleScreens.BackendServiceResultScreen.parentRoute)
            }
        },
    )
}

@Composable
private fun InitBackendServiceResult(result: String, navController: NavHostController) {
    Log.d("InitBackendServiceResultOCR", "InitBackendServiceResultOCR hazaimeh 13 May 2024")

    BackendServiceResult(
        jsonResult = result,
        goBack = {
            navController.popBackStack()
        }

    )
}


