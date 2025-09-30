package com.sales_app.ui.theme

//package com.euronovate.mobile.ocrvision.sample.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material.darkColors
import androidx.compose.material.lightColors
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import com.euronovate.mobile.ocrvision.extension.findActivity

private val DarkColorPalette = darkColors(
    primary = Color.Blue,
    primaryVariant = Color.Blue.copy(alpha = 0.8f),
    secondary = Color.Green,
    background = Color.Black,
)

private val LightColorPalette = lightColors(
    primary = Color.Cyan,
    primaryVariant = Color.Cyan.copy(alpha = 0.8f),
    secondary = Color.Magenta,
    background = Color.White,
)

val LocalColors = staticCompositionLocalOf { DarkColorPalette }
val LocalTypography = staticCompositionLocalOf { SampleTypography(colors = DarkColorPalette) }

@Composable
fun ENVisionMobileSampleTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {

    // TODO: verificare la correttezza di questa parte ( (view.context as Activity).window mi sembra pericoloso )
    // https://arkadiuszchmura.com/posts/how-to-draw-content-behind-system-bars-in-jetpack-compose/
    // https://arkadiuszchmura.com/posts/how-to-change-system-bar-colors-in-compose/
    val view = LocalView.current

    SideEffect {

        // FIXME: questo fa schiantare la preview. Usare https://github.com/google/accompanist/blob/main/systemuicontroller ?
        val activity = view.context.findActivity()

        activity?.let {
            val window = it.window

            window.statusBarColor = Color.Transparent.toArgb() // colors.primary.toArgb()
            window.navigationBarColor = Color.Transparent.toArgb() // colors.primary.toArgb()

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                window.isNavigationBarContrastEnforced = false
            }
        }
    }
    //

    val colors = if (darkTheme) DarkColorPalette else LightColorPalette
    CompositionLocalProvider(
        LocalColors provides colors,
        LocalTypography provides SampleTypography(colors = colors),
        content = content
    )
}