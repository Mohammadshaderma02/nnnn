package com.sales_app.ui.screen.widgets

//package com.euronovate.mobile.ocrvision.sample.ui.screen.widgets


import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.width
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Color.Companion.White
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.unit.dp
//import com.euronovate.mobile.ocrvision.sample.ui.theme.ENBackgroundBlack
//import com.euronovate.mobile.ocrvision.sample.ui.theme.ENMediumGray
//import com.euronovate.mobile.ocrvision.sample.ui.theme.ENPrimaryOrange
//import com.euronovate.mobile.ocrvision.sample.ui.theme.ENSoftGray
import com.sales_app.ui.theme.ENBackgroundBlack;
import com.sales_app.ui.theme.ENMediumGray;
import com.sales_app.ui.theme.ENPrimaryOrange;
import com.sales_app.ui.theme.ENSoftGray;

enum class ButtonStyle(
    val background: Color,
    val text: Color
) {
    Orange(
        ENPrimaryOrange,
        White
    ),
    Light(
        ENSoftGray,
        ENPrimaryOrange
    ),
    Ultradark(
        ENBackgroundBlack,
        White
    )

}

@Composable
fun SampleButton(
    modifier: Modifier,
    text: String = "",
    backgroundColor: Color? = null,
    textColor: Color? = null,
    onClick: () -> Unit = {},
    icon: Painter? = null,
    style: ButtonStyle? = null
) {

    val bkgColor = backgroundColor ?: style?.background ?: ENPrimaryOrange
    val txtColor = textColor ?: style?.text ?:ENMediumGray
    Button(
        modifier = modifier.height(40.dp),
        onClick = {
            onClick()
        },
        colors = ButtonDefaults.buttonColors(
            backgroundColor = bkgColor,
            disabledBackgroundColor = White.copy(0.1f)
        ),
        contentPadding = PaddingValues(horizontal = 3.dp)
    ) {

        icon?.let { lIcon ->
            Image(
                modifier = Modifier
                    .width(24.dp)
                    .height(24.dp),
                painter = lIcon,
                contentDescription = null
            )
            Spacer(
                modifier = Modifier.width(8.dp)
            )
        }

        Text(
            text = text,
            color = txtColor
        )
    }
}