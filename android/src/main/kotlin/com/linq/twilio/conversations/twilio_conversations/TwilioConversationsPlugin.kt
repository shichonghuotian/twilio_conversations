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
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** TwilioConversationsPlugin */
class TwilioConversationsPlugin : FlutterPlugin, ActivityAware {
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

    lateinit var messenger: BinaryMessenger


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        debug("TwilioConversationsPlugin.onAttachedToEngine")

        instance = this
        messenger = flutterPluginBinding.binaryMessenger
        applicationContext = flutterPluginBinding.applicationContext

//        isInited = true
        debug( "TwilioConversations PluginonAttachedToEngine: ${messenger}")


    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        debug("TwilioConversationsPlugin.onDetachedFromEngine")
        isInited = false
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        debug( "TwilioConversations onAttachedToActivity: ${messenger}")

        Api.PluginApi.setup(messenger, pluginApi)
        Api.ConversationClientApi.setup(messenger, conversationClientApi)
        Api.ConversationApi.setup(messenger, conversationApi)
        Api.ParticipantApi.setup(messenger, participantApi)
        Api.MessageApi.setup(messenger, messageApi)
        Api.UserApi.setup(messenger, userApi)

        flutterClientApi = Api.FlutterConversationClientApi(messenger)
        flutterLoggingApi = Api.FlutterLoggingApi(messenger)


    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {


    }

}
