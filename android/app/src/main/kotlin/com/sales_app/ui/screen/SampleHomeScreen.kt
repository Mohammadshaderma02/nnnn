package com.sales_app.ui.screen

//package com.euronovate.mobile.ocrvision.sample.ui.screen

import android.app.Activity
import android.widget.Toast
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
//import com.euronovate.mobile.ocrvision.sample.R
//import com.euronovate.mobile.ocrvision.sample.ui.screen.widgets.ButtonStyle
//import com.euronovate.mobile.ocrvision.sample.ui.screen.widgets.SampleButton
//import com.euronovate.mobile.ocrvision.sample.ui.theme.ENPrimaryOrange
//import com.euronovate.mobile.ocrvision.sample.ui.theme.LocalTypography
//import com.sales_app.R;
import com.sales_app_zainjo.R
import com.sales_app.ui.screen.widgets.ButtonStyle;
import com.sales_app.ui.screen.widgets.SampleButton;
import com.sales_app.ui.theme.ENPrimaryOrange;
import com.sales_app.ui.theme.LocalTypography;
import androidx.compose.runtime.setValue
import android.util.Log
@Composable
fun SampleHomeScreen(
    paddingValues: PaddingValues,
    viewModel: SampleHomeViewModel = hiltViewModel(),
    goToOcrMrz: () -> Unit,
    goToLivenessConfig: () -> Unit,
) {


    val context = LocalContext.current

    val state by viewModel.state.collectAsState()





    Box(Modifier.fillMaxSize()) {
        // background
        /*Image(
            painter = painterResource(R.drawable.sfondo),
            contentDescription = null,
            modifier = Modifier
                .fillMaxSize(),
            alpha = 0.5F,
            contentScale = ContentScale.Crop
        )*/

        // Content
        // NOTE: use Column with .verticalScroll because LazyColumn has a weird top padding
        Column(
            Modifier
                .padding(10.dp)
                .fillMaxWidth()
                .fillMaxHeight()
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(10.dp, Alignment.CenterVertically),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {

            Text(
                text = stringResource(id = R.string.setup),
                style = LocalTypography.current.sampleTextStyleTitle
            )

            SampleButton(
                modifier = Modifier
                    .height(80.dp)
                    .width(350.dp),
                style = ButtonStyle.Orange,
                onClick = {
                    viewModel.initSdk(context = context)
                    Log.d("SampleHomeScreen", "Button clicked: Init SDK")


                },
                text = stringResource(id = R.string.init_sdk),
            )

            Text(
                text = stringResource(id = R.string.ocr),
                style = LocalTypography.current.sampleTextStyleTitle
            )

            SampleButton(
                modifier = Modifier
                    .height(80.dp)
                    .width(350.dp),
                style = ButtonStyle.Orange,
                onClick = goToOcrMrz,
                text = stringResource(id = R.string.go_to_mrz),
            )

            Text(
                text = stringResource(id = R.string.liveness_facematch),
                style = LocalTypography.current.sampleTextStyleTitle
            )

            SampleButton(
                modifier = Modifier
                    .height(80.dp)
                    .width(350.dp),
                style = ButtonStyle.Orange,
                onClick = goToLivenessConfig,
                text = stringResource(id = R.string.go_to_liveness),
            )

            SampleButton(
                modifier = Modifier
                    .height(80.dp)
                    .width(350.dp),
                style = ButtonStyle.Orange,
                onClick = {
                    viewModel.createLogsZipFile(context = context)
                },
                text = stringResource(id = R.string.create_log),
            )


            Spacer(
                modifier = Modifier.height(paddingValues.calculateBottomPadding())
            )

        }



        // toast
        val localContext = LocalContext.current

        LaunchedEffect(viewModel) {
            viewModel.toastMessage.collect { operationsState ->
                when (operationsState) {
                    is SampleHomeViewModel.OperationsState.InitializationKo -> {
                        Toast.makeText(localContext, "SDK init KO: ${operationsState.message}", Toast.LENGTH_SHORT).show()
                        Log.d("SDK init KO", "${operationsState.message}")

                    }

                    SampleHomeViewModel.OperationsState.InitializationOk -> {

                        Toast.makeText(localContext, "SDK init", Toast.LENGTH_SHORT).show()
                    }

                    is SampleHomeViewModel.OperationsState.GenericOperation -> {

                        Toast.makeText(localContext, operationsState.message, Toast.LENGTH_SHORT).show()
                    }

                    SampleHomeViewModel.OperationsState.Unknown -> Unit // nothing to do
                }
            }
        }

        // loader
        AnimatedVisibility(
            visible = state.showLoading,
            enter = fadeIn(),
            exit = fadeOut(),
            modifier = Modifier
                .wrapContentHeight(Alignment.Bottom)
        ) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color(0x77000000))
                    .clickable(
                        interactionSource = MutableInteractionSource(),
                        indication = null,
                        onClick = {}
                    )
            ) {
                CircularProgressIndicator(
                    modifier = Modifier
                        .width(100.dp)
                        .height(100.dp)
                        .align(Alignment.Center),
                    strokeWidth = 10.dp,
                    color = ENPrimaryOrange,
                )
            }
        }
    }
}
