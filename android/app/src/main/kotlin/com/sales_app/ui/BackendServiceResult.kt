package com.sales_app.ui

//package com.euronovate.mobile.ocrvision.sample.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
//import com.euronovate.mobile.ocrvision.sample.ui.screen.widgets.TopBar
import com.sales_app.ui.screen.widgets.TopBar;
import org.json.JSONObject
import android.util.Log

@Composable
fun BackendServiceResult(
    jsonResult: String,
    goBack: () -> Unit,
) {

    Column {
        TopBar(
            onClickArrow = goBack,
        )

        Column(
            Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .background(Color(0xFFE8E8E8))
        ) {
            Text(
                modifier = Modifier
                    .padding(30.dp),

                text = getStringToShow(jsonResult)
            )
        }
    }

}

private fun getStringToShow(jsonResult: String) : String {
    Log.d("BackendServiceResult", "13 May 2024 hazaimeh")

    return try {
        val jsonObject = JSONObject(jsonResult)
        jsonObject.toString(4)

    } catch (e: Exception){
        jsonResult

    }
}