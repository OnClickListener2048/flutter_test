package com.watson.androidboosttest

import android.os.Bundle
import androidx.activity.ComponentActivity
import com.idlefish.flutterboost.FlutterBoost
import com.idlefish.flutterboost.FlutterBoostRouteOptions

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val build = FlutterBoostRouteOptions.Builder()
            .pageName("mainPage")
            .arguments(mutableMapOf())
            .requestCode(100)
            .build()

        FlutterBoost.instance().open(build)
    }
}

