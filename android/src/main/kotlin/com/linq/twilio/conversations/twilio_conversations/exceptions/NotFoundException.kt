package com.linq.twilio.conversations.twilio_conversations.exceptions

class NotFoundException(message: String) : RuntimeException(message) {
    override fun toString(): String {
        return message ?: "NotFoundException"
    }
}
