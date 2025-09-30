package com.sales_app

//package com.euronovate.mobile.ocrvision.sample

import com.sales_app.DestinationsRoute.BackendServiceResultScreenRoute
import com.sales_app.DestinationsRoute.SampleHomeScreenRoute
import com.sales_app.DestinationsRoute.SampleLivenessScreenRoute
import com.sales_app.DestinationsRoute.SampleOcrMrzScreenRoute

object DestinationsRoute {
    const val SampleHomeScreenRoute = "/home"
    const val SampleOcrMrzScreenRoute = "/mrz"
    const val SampleLivenessScreenRoute = "/liveness"
    const val BackendServiceResultScreenRoute = "/backendserviceresult"

    object Arguments {
        const val DocumentCountry = "doccountry"
        const val DocumentType = "doctype"
        const val DocumentVersion = "docversion"
    }


}

sealed class SampleScreens(
    val route: String,
    val parentRoute: String
) {

    object SampleHomeScreen : SampleScreens(
        route = SampleHomeScreenRoute,
        parentRoute = SampleHomeScreenRoute
    )

    object SampleOcrMrzScreen : SampleScreens(
        route = SampleOcrMrzScreenRoute,
        parentRoute = SampleOcrMrzScreenRoute
    )

    object SampleLivenessScreen : SampleScreens(
        route = SampleLivenessScreenRoute,
        parentRoute = SampleLivenessScreenRoute
    )

    object BackendServiceResultScreen : SampleScreens(
        route = BackendServiceResultScreenRoute,
        parentRoute = BackendServiceResultScreenRoute
    )
}
