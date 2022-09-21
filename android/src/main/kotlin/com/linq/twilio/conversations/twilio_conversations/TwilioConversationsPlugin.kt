package com.linq.twilio.conversations.twilio_conversations

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.twilio.conversations.ConversationsClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import com.linq.twilio.conversations.twilio_conversations.listeners.ClientListener
import com.linq.twilio.conversations.twilio_conversations.listeners.ConversationListener
import com.linq.twilio.conversations.twilio_conversations.methods.*

/** TwilioConversationsPlugin */
class TwilioConversationsPlugin : FlutterPlugin {
    companion object {
        @Suppress("unused")
        @JvmStatic
        lateinit var instance: TwilioConversationsPlugin

        // Flutter > Host APIs
        @JvmStatic
        val pluginApi: Api.PluginApi = PluginMethods()

        @JvmStatic
        val conversationClientApi: Api.ConversationClientApi = ConversationClientMethods()

        @JvmStatic
        val conversationApi: Api.ConversationApi = ConversationMethods()

        @JvmStatic
        val participantApi: Api.ParticipantApi = ParticipantMethods()

        @JvmStatic
        val messageApi: Api.MessageApi = MessageMethods()

        @JvmStatic
        val userApi: Api.UserApi = UserMethods()

        // Host > Flutter APIs
        @JvmStatic
        lateinit var flutterClientApi: Api.FlutterConversationClientApi

        @JvmStatic
        lateinit var flutterLoggingApi: Api.FlutterLoggingApi

        @JvmStatic
        var client: ConversationsClient? = null

        lateinit var messenger: BinaryMessenger

        lateinit var applicationContext: Context

        var clientListener: ClientListener? = null

        var conversationListeners: HashMap<String, ConversationListener> = hashMapOf()

        var handler = Handler(Looper.getMainLooper())
        var nativeDebug: Boolean = false
        val LOG_TAG = "Twilio_Conversations"

        var isInited: Boolean = false;

        @JvmStatic
        fun debug(msg: String) {
            if (nativeDebug) {
                Log.d(LOG_TAG, msg)
                handler.post {
                    flutterLoggingApi.logFromHost(msg) { }
                }
            }
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        if(isInited) {
//            防止多次初始化， fcm会启动一个FlutterEngine
            return
        }

        instance = this
        messenger = flutterPluginBinding.binaryMessenger
        applicationContext = flutterPluginBinding.applicationContext

        Api.PluginApi.setup(flutterPluginBinding.binaryMessenger, pluginApi)
        Api.ConversationClientApi.setup(flutterPluginBinding.binaryMessenger, conversationClientApi)
        Api.ConversationApi.setup(flutterPluginBinding.binaryMessenger, conversationApi)
        Api.ParticipantApi.setup(flutterPluginBinding.binaryMessenger, participantApi)
        Api.MessageApi.setup(flutterPluginBinding.binaryMessenger, messageApi)
        Api.UserApi.setup(flutterPluginBinding.binaryMessenger, userApi)

        flutterClientApi = Api.FlutterConversationClientApi(flutterPluginBinding.binaryMessenger)
        flutterLoggingApi = Api.FlutterLoggingApi(flutterPluginBinding.binaryMessenger)

        debug( "onAttachedToEngine")
        isInited = true
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        debug("TwilioConversationsPlugin.onDetachedFromEngine")
        isInited = false
    }
}
