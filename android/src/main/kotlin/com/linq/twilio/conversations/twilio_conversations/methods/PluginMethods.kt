package com.linq.twilio.conversations.twilio_conversations.methods

import com.linq.twilio.conversations.twilio_conversations.Api
import com.twilio.conversations.CallbackListener
import com.twilio.conversations.ConversationsClient
import com.twilio.conversations.ErrorInfo
import com.linq.twilio.conversations.twilio_conversations.Mapper
import com.linq.twilio.conversations.twilio_conversations.TwilioConversationsPlugin
import com.linq.twilio.conversations.twilio_conversations.exceptions.TwilioException
import com.linq.twilio.conversations.twilio_conversations.listeners.ClientListener

class PluginMethods : Api.PluginApi {
    private val TAG = "PluginMethods"

    override fun debug(enableNative: Boolean, enableSdk: Boolean) {
        if (enableSdk) {
            ConversationsClient.setLogLevel(ConversationsClient.LogLevel.DEBUG)
        } else {
            ConversationsClient.setLogLevel(ConversationsClient.LogLevel.ERROR)
        }

        TwilioConversationsPlugin.nativeDebug = enableNative
        return
    }

    override fun create(jwtToken: String, properties: Api.PropertiesData, result: Api.Result<Api.ConversationClientData>) {
        debug("create => jwtToken: $jwtToken")
        val props = ConversationsClient.Properties.newBuilder()
            .setRegion(properties.region)
            .createProperties()

        ConversationsClient.create(TwilioConversationsPlugin.applicationContext, jwtToken, props, object :
            CallbackListener<ConversationsClient> {
            override fun onSuccess(conversationsClient: ConversationsClient) {
                debug("create => onSuccess - myIdentity: '${conversationsClient.myUser?.identity ?: "unknown"}'")
                TwilioConversationsPlugin.client = conversationsClient
                TwilioConversationsPlugin.clientListener = ClientListener()
                conversationsClient.addListener(TwilioConversationsPlugin.clientListener!!)
                val clientMap = Mapper.conversationsClientToPigeon(conversationsClient)
                result.success(clientMap)
            }

            override fun onError(errorInfo: ErrorInfo) {
                debug("create => onError: ${errorInfo.message}")
                result.error(TwilioException(errorInfo.code, errorInfo.message))
            }
        })
    }

    fun debug(message: String) {
        TwilioConversationsPlugin.debug("$TAG::$message")
    }
}
