package com.watson.androidboosttest

import android.content.Context
import android.os.Bundle
import com.blankj.utilcode.util.ReflectUtils
import com.idlefish.flutterboost.FlutterBoost
import com.idlefish.flutterboost.FlutterBoostUtils
import com.idlefish.flutterboost.containers.FlutterActivityLaunchConfigs
import com.idlefish.flutterboost.containers.FlutterBoostFragment
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.android.TransparencyMode


class FlutterTiensBoostFragment : FlutterBoostFragment() {

    override fun onAttach(context: Context) {
        super.onAttach(context)
        try {
            ReflectUtils.reflect(flutterEngine?.platformViewsController).method("diposeAllViews")
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onUpdateSystemUiOverlays() {
        super.onUpdateSystemUiOverlays()
        flutterEngine?.accessibilityChannel?.flutterJNI?.setSemanticsEnabled(false)
    }


    open class CachedEngineFragmentBuilder @JvmOverloads constructor(private val fragmentClass: Class<out FlutterTiensBoostFragment> = FlutterTiensBoostFragment::class.java) {
        private var destroyEngineWithFragment = false
        private var renderMode: RenderMode? = RenderMode.surface
        private var transparencyMode: TransparencyMode? = TransparencyMode.opaque
        private var shouldAttachEngineToActivity = true
        private var url = "/"
        private var params: HashMap<String, Any>? = null
        private var uniqueId: String? = null
        fun url(url: String): CachedEngineFragmentBuilder {
            this.url = url
            return this
        }

        fun urlParams(params: Map<String, Any>?): CachedEngineFragmentBuilder {
            this.params =
                if ((params is HashMap<*, *>)) params as HashMap<String, Any>? else params?.let {
                    HashMap(
                        it
                    )
                }
            return this
        }

        fun uniqueId(uniqueId: String?): CachedEngineFragmentBuilder {
            this.uniqueId = uniqueId
            return this
        }

        fun destroyEngineWithFragment(
            destroyEngineWithFragment: Boolean
        ): CachedEngineFragmentBuilder {
            this.destroyEngineWithFragment = destroyEngineWithFragment
            return this
        }

        fun renderMode(renderMode: RenderMode?): CachedEngineFragmentBuilder {
            this.renderMode = renderMode
            return this
        }

        fun transparencyMode(
            transparencyMode: TransparencyMode?
        ): CachedEngineFragmentBuilder {
            this.transparencyMode = transparencyMode
            return this
        }

        fun shouldAttachEngineToActivity(
            shouldAttachEngineToActivity: Boolean
        ): CachedEngineFragmentBuilder {
            this.shouldAttachEngineToActivity = shouldAttachEngineToActivity
            return this
        }

        /**
         * Creates a [Bundle] of arguments that are assigned to the new `FlutterFragment`.
         *
         *
         * Subclasses should override this method to add new properties to the [Bundle].
         * Subclasses must call through to the super method to collect all existing property values.
         */
        protected fun createArgs(): Bundle {
            val args = Bundle()
            args.putString(ARG_CACHED_ENGINE_ID, FlutterBoost.ENGINE_ID)
            args.putBoolean(ARG_DESTROY_ENGINE_WITH_FRAGMENT, destroyEngineWithFragment)
            args.putString(
                ARG_FLUTTERVIEW_RENDER_MODE,
                if (renderMode != null) renderMode!!.name else RenderMode.surface.name
            )
            args.putString(
                ARG_FLUTTERVIEW_TRANSPARENCY_MODE,
                if (transparencyMode != null) transparencyMode!!.name else TransparencyMode.transparent.name
            )
            args.putBoolean(ARG_SHOULD_ATTACH_ENGINE_TO_ACTIVITY, shouldAttachEngineToActivity)
            args.putString(FlutterActivityLaunchConfigs.EXTRA_URL, url)
            args.putSerializable(FlutterActivityLaunchConfigs.EXTRA_URL_PARAM, params)
            args.putString(
                FlutterActivityLaunchConfigs.EXTRA_UNIQUE_ID,
                if (uniqueId != null) uniqueId else FlutterBoostUtils.createUniqueId(url)
            )
            return args
        }

        /**
         * Constructs a new `FlutterFragment` (or a subclass) that is configured based on
         * properties set on this `CachedEngineFragmentBuilder`.
         */
        fun <T : FlutterTiensBoostFragment?> build(): T {
            try {
                val frag: T = fragmentClass.getDeclaredConstructor().newInstance() as T
                    ?: throw RuntimeException(
                        ("The FlutterFragment subclass sent in the constructor ("
                                + fragmentClass.canonicalName
                                + ") does not match the expected return type.")
                    )
                val args = createArgs()
                frag?.arguments = args
                return frag
            } catch (e: Exception) {
                throw RuntimeException(
                    "Could not instantiate FlutterFragment subclass (" + fragmentClass.name + ")", e
                )
            }
        }
    }

}