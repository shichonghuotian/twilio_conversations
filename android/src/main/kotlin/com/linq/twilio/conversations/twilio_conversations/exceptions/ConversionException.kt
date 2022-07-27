package com.linq.twilio.conversations.twilio_conversations.exceptions

class ConversionException(message: String) : RuntimeException(message) {
    override fun toString(): String {
        return message ?: "ConversionException"
    }
}
