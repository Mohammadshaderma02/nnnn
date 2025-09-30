package com.sales_app.ui.screen.widgets

//package com.euronovate.mobile.ocrvision.sample.ui.screen.widgets

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.material.Icon
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ArrowBackIos
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
//import com.euronovate.mobile.ocrvision.sample.R
//import com.euronovate.mobile.ocrvision.sample.ui.theme.ENBackgroundBlack
import com.sales_app.ui.theme.ENBackgroundBlack;
//import com.sales_app.R;
import com.sales_app_zainjo.R




@Composable
fun TopBar(
    onClickArrow: (() -> Unit)? = null,
) {

    Row(
        Modifier
            .fillMaxWidth()
            .height(100.dp)
            .background(ENBackgroundBlack)
            .statusBarsPadding()
            .padding(start = 10.dp, end = 10.dp, top = 5.dp, bottom = 5.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Center
    ) {

        onClickArrow?.let {
            Icon(
                Icons.Rounded.ArrowBackIos,
                modifier = Modifier
                    .height(50.dp)
                    .clickable {
                        onClickArrow()
                    },
                contentDescription = null,
                tint = Color(0xFF646567)
            )
        }

        Spacer(modifier = Modifier.weight(1f))

       /* Image(
            modifier = Modifier
                .height(50.dp),
            painter = painterResource(id = R.drawable.euronovate_group_grey),
            contentDescription = null
        )*/
        Color(0xFF9B9B9B) // replace this with the desired background color

        Spacer(modifier = Modifier.weight(1f))

    }
}


