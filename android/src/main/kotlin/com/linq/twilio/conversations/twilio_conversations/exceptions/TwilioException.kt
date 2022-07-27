package com.linq.twilio.conversations.twilio_conversations.exceptions

class TwilioException(private val code: Int, message: String) : RuntimeException(message) {
    override fun toString(): String {
        return "$code|$message"
    }
}
