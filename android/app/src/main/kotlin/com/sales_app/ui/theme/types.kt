package com.sales_app.ui.theme

//package com.euronovate.mobile.ocrvision.sample.ui.theme

import androidx.compose.material.Colors
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.PlatformTextStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
//import com.euronovate.mobile.ocrvision.sample.R

import com.sales_app_zainjo.R

class SampleTypography(colors: Colors) {
    private val sampleTextStyle: TextStyle = TextStyle(
        color = colors.onPrimary,
        fontFamily = ENFontFamilyCaveat_Medium,
        platformStyle = PlatformTextStyle(
            includeFontPadding = false
        )
    )
    val sampleTextStyleTitle: TextStyle = sampleTextStyle.copy(
        color = ENPrimaryOrange,
        fontWeight = FontWeight.Bold,
        fontSize = 25.sp
    )
    val sampleTextStyleSubtitle: TextStyle = sampleTextStyle.copy(
        color = ENPrimaryOrange,
        fontWeight = FontWeight.Bold,
        fontSize = 22.sp
    )
    val sampleTextBottomBar: TextStyle = sampleTextStyle.copy(
        color = colors.onPrimary,
        fontWeight = FontWeight.Bold,
        fontSize = 18.sp
    )
    val sampleWhiteTextBottomBar: TextStyle = sampleTextStyle.copy(
        color = Color.White,
        fontWeight = FontWeight.Bold,
        fontSize = 18.sp
    )
    val sampleTextField: TextStyle = sampleTextStyle.copy(
        color = Color.Black
    )


}

private val ENFontFamilyCaveat_Medium = FontFamily(
    //Font(R.font.caveat_medium, FontWeight.W500),
    Font(R.font.montserrat_semi_bold, FontWeight.W700),
)