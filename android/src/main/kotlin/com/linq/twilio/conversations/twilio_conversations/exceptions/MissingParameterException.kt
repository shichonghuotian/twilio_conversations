package com.linq.twilio.conversations.twilio_conversations.exceptions

class MissingParameterException(message: String) : RuntimeException(message) {
    override fun toString(): String {
        return message ?: "MissingParameterException"
    }
}
