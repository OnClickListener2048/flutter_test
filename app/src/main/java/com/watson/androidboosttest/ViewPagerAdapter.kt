package com.watson.androidboosttest

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter

class ViewPagerAdapter(
    fragmentActivity: FragmentActivity,
    private var fragmentMutableList: MutableList<Fragment>,
) : FragmentStateAdapter(fragmentActivity) {
    override fun getItemCount(): Int {
        return fragmentMutableList.size
    }

    override fun createFragment(position: Int): Fragment {
        return fragmentMutableList[position]
    }

    override fun getItemId(position: Int): Long {
        return fragmentMutableList[position].hashCode().toLong()
    }

    override fun containsItem(itemId: Long): Boolean {
        return true
    }
}