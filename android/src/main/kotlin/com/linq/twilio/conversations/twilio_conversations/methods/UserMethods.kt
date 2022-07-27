package com.linq.twilio.conversations.twilio_conversations.methods

import com.linq.twilio.conversations.twilio_conversations.Api
import com.twilio.conversations.CallbackListener
import com.twilio.conversations.ErrorInfo
import com.twilio.conversations.StatusListener
import com.twilio.conversations.User
import com.linq.twilio.conversations.twilio_conversations.Mapper
import com.linq.twilio.conversations.twilio_conversations.TwilioConversationsPlugin
import com.linq.twilio.conversations.twilio_conversations.exceptions.ClientNotInitializedException
import com.linq.twilio.conversations.twilio_conversations.exceptions.ConversionException
import com.linq.twilio.conversations.twilio_conversations.exceptions.TwilioException

class UserMethods : Api.UserApi {
    private val TAG = "UserMethods"

    override fun setFriendlyName(
        identity: String,
        friendlyName: String,
        result: Api.Result<Void>
    ) {
        debug("setFriendlyName => identity: $identity")
        val client = TwilioConversationsPlugin.client
            ?: return result.error(ClientNotInitializedException("Client is not initialized"))

        client.getAndSubscribeUser(identity, object : CallbackListener<User> {
            override fun onSuccess(user: User) {
                user.setFriendlyName(friendlyName, object : StatusListener {
                    override fun onSuccess() {
                        debug("setFriendlyName => onSuccess")
                        result.success(null)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        debug("setFriendlyName => onError: $errorInfo")
                        result.error(TwilioException(errorInfo.code, errorInfo.message))
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                debug("setFriendlyName => onError: $errorInfo")
                result.error(TwilioException(errorInfo.code, errorInfo.message))
            }
        })
    }

    override fun setAttributes(
        identity: String,
        attributes: Api.AttributesData,
        result: Api.Result<Void>
    ) {
        debug("setAttributes => identity: $identity")
        val client = TwilioConversationsPlugin.client
            ?: return result.error(ClientNotInitializedException("Client is not initialized"))
        val userAttributes = Mapper.pigeonToAttributes(attributes)
            ?: return result.error(ConversionException("Could not convert $attributes to valid Attributes"))

        client.getAndSubscribeUser(identity, object : CallbackListener<User> {
            override fun onSuccess(user: User) {
                user.setAttributes(userAttributes, object : StatusListener {
                    override fun onSuccess() {
                        debug("setAttributes => onSuccess")
                        result.success(null)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        debug("setAttributes => onError: $errorInfo")
                        result.error(TwilioException(errorInfo.code, errorInfo.message))
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                debug("setAttributes => onError: $errorInfo")
                result.error(TwilioException(errorInfo.code, errorInfo.message))
            }
        })
    }

    fun debug(message: String) {
        TwilioConversationsPlugin.debug("$TAG::$message")
    }
}
