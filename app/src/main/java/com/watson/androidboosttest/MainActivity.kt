package com.watson.androidboosttest

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.widget.ViewPager2
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.idlefish.flutterboost.FlutterBoost
import com.idlefish.flutterboost.FlutterBoostRouteOptions
import com.idlefish.flutterboost.containers.FlutterBoostFragment

class MainActivity : FragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.main)
        val viewPager2 = findViewById<ViewPager2>(R.id.view_pager)
        val bottomNavigationView = findViewById<BottomNavigationView>(R.id.nav_view)

        val A =  FlutterBoostFragment.CachedEngineFragmentBuilder().url("live")
                .build<FlutterBoostFragment>()
        val B = FlutterBoostFragment.CachedEngineFragmentBuilder().url("mainPage")
                .build<FlutterBoostFragment>()

        listOf(A,B)
        viewPager2.adapter = ViewPagerAdapter(
            this,
            mutableListOf(
                A,
                B
            )
        )
        viewPager2.offscreenPageLimit =4
        bottomNavigationView.setOnItemSelectedListener { it->
            when (it.itemId) {
                R.id.navigation_dashboard -> {
                    viewPager2.currentItem = 0
                    true
                }
                R.id.navigation_contact -> {
                    viewPager2.currentItem = 1
                    true
                }
                else -> false
            }

        }

    }
}

