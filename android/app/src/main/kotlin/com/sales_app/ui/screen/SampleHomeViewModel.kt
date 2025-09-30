package com.sales_app.ui.screen

//package com.euronovate.mobile.ocrvision.sample.ui.screen

import android.content.Context
import android.util.Log
import android.view.Window
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.euronovate.mobile.ocr.ENMobileOcrSDK
import com.euronovate.mobile.ocrvision.LogLevel
//import com.euronovate.mobile.ocrvision.sample.BuildConfig
//import com.euronovate.mobile.ocrvision.sample.utils.copyInDownloads
import com.sales_app.utils.copyInDownloads;
//import com.sales_app.BuildConfig;
import com.sales_app_zainjo.BuildConfig



import com.euronovate.mobile.vision.ENMobileVisionSDK



import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject


@HiltViewModel
class SampleHomeViewModel @Inject constructor(
    private val ocrSdk: ENMobileOcrSDK?,
    private val visionSdk: ENMobileVisionSDK?,
): ViewModel() {
    fun yourFunction() {
        // Your function implementation here
        Log.d("SampleHomeViewModel", "Your function was called")
    }

    companion object {
        const val CHANNEL = "NativeChannel"
    }
    private val tag = "ENMobileOcrVisionSDK-SampleScreenContainerViewModel"

    private val enStrings = mapOf(
        "OK" to "OK",
        "ErrorTitle" to "Error",
        "ErrorText" to "Something wen wrong please retry",
        "CountDownExpiredErrorText" to "Countdown expired please retry",
        "ReadBarcodeHint" to "Frame the document and press the button",
        "ReadMrzHint" to "Frame the document and press the button",
        "DocumentNotSupported" to "Document not supported",
        "CannotGetSupportedDocuments" to "Cannot get supported documents",
        "ReadDocumentFrontHint" to "Frame the front side and press the button",
        "ReadDocumentBackHint" to "Frame the back side and press the button",
        "DocumentSummaryHint" to "Process completed, press the button or go back to redo.",
        "LivenessHint" to "Frame the face and press the button",
        "LivenessSentenceHint" to "Please say the following sentence",
    )

    private val arStrings = mapOf(
        "OK" to "OK",
        "ErrorTitle" to "Error",
        "ErrorText" to "Something wen wrong please retry",
        "CountDownExpiredErrorText" to "Countdown expired please retry",
        "ReadBarcodeHint" to "Frame the document and press the button",
        "ReadMrzHint" to "Frame the document and press the button",
        "DocumentNotSupported" to "Document not supported",
        "CannotGetSupportedDocuments" to "Cannot get supported documents",
        "ReadDocumentFrontHint" to "Frame the front side and press the button",
        "ReadDocumentBackHint" to "Frame the back side and press the button",
        "DocumentSummaryHint" to "Process completed, press the button or go back to redo.",
        "LivenessHint" to "Frame the face and press the button",
        "LivenessSentenceHint" to "Please say the following sentence",
    )

    private val itStrings = mapOf(
        "OK" to "OK",
        "ErrorTitle" to "Errore",
        "ErrorText" to "Qualcosa è andato storto. Per favore riprova",
        "CountDownExpiredErrorText" to "Countdown scaduto, per favore riprova",
        "ReadBarcodeHint" to "Inquadra il documento e premi il bottone",
        "ReadMrzHint" to "Inquadra il documento e premi il bottone",
        "DocumentNotSupported" to "Documento non supportato",
        "CannotGetSupportedDocuments" to "Impossibile recuperare i documenti supportati",
        "ReadDocumentFrontHint" to "Inquadra il fronte e premi il bottone",
        "ReadDocumentBackHint" to "Inquadra il retro e premi il bottone",
        "DocumentSummaryHint" to "Processo completato, premi il bottone o torna indietro.",
        "LivenessHint" to "Inquadra il viso e premi il bottone",
        "LivenessSentenceHint" to "Pronuncia le seguenti frasi",
    )

    private val colors = mapOf(
        "CameraButtonBackground" to "FF646363",
        "CameraButtonIcon" to "#FF392156",
        "CameraOverlay" to "#FF392156",
    )

    private val _state = MutableStateFlow(SampleHomeState())
    val state: StateFlow<SampleHomeState>
        get() = _state

    private val _toastMessage = MutableSharedFlow<OperationsState>()
    val toastMessage = _toastMessage.asSharedFlow()

    // go fullscreen to test if ocrvision SDK behave well in fullscreen or non fullscreen apps
    fun toggleFullscreen(window: Window, enableFullscreen: Boolean) {
        val windowInsetsController = WindowCompat.getInsetsController(window, window.decorView)
        windowInsetsController.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        if (enableFullscreen) {
            windowInsetsController.hide(WindowInsetsCompat.Type.systemBars())
        } else {
            windowInsetsController.show(WindowInsetsCompat.Type.systemBars())
        }

    }

    fun initSdk(context: Context) {
        Log.d("SampleHomeViewModel", "Haya hazaimeh")

        viewModelScope.launch {
            _state.update {
                it.copy(showLoading = true)
            }

            // init ocr sdk
            val initOcrSdkResult = ocrSdk?.init(
                context = context,
                ocrServiceUrl =  BuildConfig.OCR_URL_EN_PREPROD,
                authenticationUrl = BuildConfig.AUTH_OCR_URL,
                authenticationTenant = BuildConfig.AUTH_OCR_TENANT,
                authenticationUser = BuildConfig.AUTH_OCR_USER,
                authenticationPassword = BuildConfig.AUTH_OCR_PASSWORD,
                customizedColors = colors,
                customizedStrings = enStrings,
                localization = null,
                logLevel = LogLevel.INFO,
                enAuthServerUrl = "",
                enAuthLicenseKey = "",
                enAuthJwt = BuildConfig.ENAUTH_JWT,
            )
            when(initOcrSdkResult) {

                is ENMobileOcrSDK.InitializationResult.Error -> {
                    Log.e(tag, initOcrSdkResult.message)
                    _toastMessage.emit(OperationsState.InitializationKo(message = initOcrSdkResult.message))
                }
                ENMobileOcrSDK.InitializationResult.Ok -> {
                    Log.d(tag, "InitializationResult.Ok.ok")
                    _toastMessage.emit(OperationsState.InitializationOk)
                }
                else -> {
                    Log.d(tag, "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh")

                }
            }

            // init vision sdk
            val initVisionSdkResult = visionSdk?.init(
                context = context,
                visionServiceUrl = BuildConfig.VISION_URL,
                authenticationUrl = BuildConfig.AUTH_VISION_URL,
                authenticationTenant = BuildConfig.AUTH_VISION_TENANT,
                authenticationUser = BuildConfig.AUTH_VISION_USER,
                authenticationPassword = BuildConfig.AUTH_VISION_PASSWORD,
                customizedColors = colors,
                customizedStrings = enStrings,
                localization = null,
                logLevel = LogLevel.INFO,
                enAuthServerUrl = "",
                enAuthLicenseKey = "",
                enAuthJwt = BuildConfig.ENAUTH_JWT,
            )
            when(initVisionSdkResult) {
                is ENMobileVisionSDK.InitializationResult.Error -> {
                    Log.e(tag, initVisionSdkResult.message)
                    _toastMessage.emit(OperationsState.InitializationKo(message = initVisionSdkResult.message))
                }
                ENMobileVisionSDK.InitializationResult.Ok -> {
                    Log.d(tag, "InitializationResult.Ok")
                    _toastMessage.emit(OperationsState.InitializationOk)
                }
                else -> {
                    Log.d("SampleHomeViewModel", "Haya hazaimeh initOcrSdkResult")
                }
            }

            _state.update {
                it.copy(showLoading = false)
            }
        }
    }
    fun createLogsZipFile(context: Context) {

        viewModelScope.launch {
            _state.update {
                it.copy(showLoading = true)
            }

            ocrSdk?.createLogsZipFile(context = context)?.let {
                copyInDownloads(file = it, context = context)
            }

            _state.update {
                it.copy(showLoading = false)
            }

            _toastMessage.emit(OperationsState.GenericOperation("Log file save to download folder"))
        }
    }

    sealed class OperationsState(val message: String) {
        object Unknown: OperationsState(message = "")
        object InitializationOk: OperationsState(message = "")
        class InitializationKo(message: String) : OperationsState(message = message)
        class GenericOperation(message: String) : OperationsState(message = message)
    }
    data class SampleHomeState(
        val showLoading: Boolean = false,
    )
}