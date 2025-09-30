package com.sales_app

//package com.euronovate.mobile.ocrvision.sample

import androidx.lifecycle.ViewModel
import com.euronovate.mobile.ocr.ENMobileOcrSDK
import com.euronovate.mobile.vision.ENMobileVisionSDK
import com.euronovate.mobile.vision.ENMobileVisionSDKBuilder
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.update
import javax.inject.Inject

data class ScreenContainerState(
    val isBottomAppBarVisible: Boolean = false,
    val isTopAppBarVisible: Boolean = false,
)

@HiltViewModel
class SampleScreenContainerViewModel @Inject constructor(
    val ocrSdk: ENMobileOcrSDK,
    val visionSdk: ENMobileVisionSDK,
): ViewModel() {


    private val _state = MutableStateFlow(ScreenContainerState())
    val state: StateFlow<ScreenContainerState>
        get() = _state

    fun onDestinationChanged(destination: String) {
        _state.update {
            it.copy(
                isBottomAppBarVisible = barsVisibilityByDestination(destination),
                isTopAppBarVisible = barsVisibilityByDestination(destination),
            )
        }
    }

    private fun barsVisibilityByDestination(destination: String) = when {
        // shows top/bottom bars only in homescreen
        destination.startsWith(DestinationsRoute.SampleHomeScreenRoute) -> true
        else -> false
    }
}