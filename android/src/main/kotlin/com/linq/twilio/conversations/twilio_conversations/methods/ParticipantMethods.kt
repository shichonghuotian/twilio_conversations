package com.linq.twilio.conversations.twilio_conversations.methods

import com.linq.twilio.conversations.twilio_conversations.Api
import com.twilio.conversations.CallbackListener
import com.twilio.conversations.Conversation
import com.twilio.conversations.ErrorInfo
import com.twilio.conversations.StatusListener
import com.linq.twilio.conversations.twilio_conversations.Mapper
import com.linq.twilio.conversations.twilio_conversations.TwilioConversationsPlugin
import com.linq.twilio.conversations.twilio_conversations.exceptions.ClientNotInitializedException
import com.linq.twilio.conversations.twilio_conversations.exceptions.ConversionException
import com.linq.twilio.conversations.twilio_conversations.exceptions.NotFoundException
import com.linq.twilio.conversations.twilio_conversations.exceptions.TwilioException

class ParticipantMethods : Api.ParticipantApi {
    private val TAG = "ParticipantMethods"

    override fun getUser(
        conversationSid: String,
        participantSid: String,
        result: Api.Result<Api.UserData>
    ) {
        debug("getUser => conversationSid: $conversationSid")
        val client = TwilioConversationsPlugin.client
            ?: return result.error(ClientNotInitializedException("Client is not initialized"))

        client.getConversation(conversationSid, object : CallbackListener<Conversation> {
            override fun onSuccess(conversation: Conversation) {
                val participant = conversation.getParticipantBySid(participantSid)
                    ?: return result.error(NotFoundException("No participant found with SID: $participantSid"))

                participant.getAndSubscribeUser {
                    debug("getUser => onSuccess")
                    result.success(Mapper.userToPigeon(it))
                }
            }

            override fun onError(errorInfo: ErrorInfo) {
                debug("getUser => onError: $errorInfo")
                result.error(TwilioException(errorInfo.code, errorInfo.message))
            }
        })
    }

    override fun setAttributes(
        conversationSid: String,
        participantSid: String,
        attributes: Api.AttributesData,
        result: Api.Result<Void>
    ) {
        debug("setAttributes => conversationSid: $conversationSid")
        val client = TwilioConversationsPlugin.client
            ?: return result.error(ClientNotInitializedException("Client is not initialized"))
        val participantAttributes = Mapper.pigeonToAttributes(attributes)
            ?: return result.error(ConversionException("Could not convert $attributes to valid Attributes"))

        client.getConversation(conversationSid, object : CallbackListener<Conversation> {
            override fun onSuccess(conversation: Conversation) {
                val participant = conversation.getParticipantBySid(participantSid)
                    ?: return result.error(NotFoundException("No participant found with SID: $participantSid"))
                participant.setAttributes(participantAttributes, object : StatusListener {
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

    override fun remove(
        conversationSid: String,
        participantSid: String,
        result: Api.Result<Void>
    ) {
        debug("remove => conversationSid: $conversationSid, participantSid: $participantSid")
        val client = TwilioConversationsPlugin.client
            ?: return result.error(ClientNotInitializedException("Client is not initialized"))

        client.getConversation(conversationSid, object : CallbackListener<Conversation> {
            override fun onSuccess(conversation: Conversation) {
                val participant = conversation.getParticipantBySid(participantSid)
                    ?: return result.error(NotFoundException("No participant found with SID: $participantSid"))
                participant.remove(object : StatusListener {
                    override fun onSuccess() {
                        debug("remove => onSuccess")
                        result.success(null)
                    }

                    override fun onError(errorInfo: ErrorInfo) {
                        debug("remove => onError: $errorInfo")
                        result.error(TwilioException(errorInfo.code, errorInfo.message))
                    }
                })
            }

            override fun onError(errorInfo: ErrorInfo) {
                debug("remove => onError: $errorInfo")
                result.error(TwilioException(errorInfo.code, errorInfo.message))
            }
        })
    }

    fun debug(message: String) {
        TwilioConversationsPlugin.debug("$TAG::$message")
    }
}
