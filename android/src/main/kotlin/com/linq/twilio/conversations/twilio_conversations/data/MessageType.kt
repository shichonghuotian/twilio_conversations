package com.linq.twilio.conversations.twilio_conversations.data

// @todo: remove once multiple media is supported
enum class MessageType(val value: Int) {
    TEXT(0),
    MEDIA(1);

    companion object {
        private val valuesMap = values().associateBy { it.value }
        fun fromInt(value: Int) = valuesMap[value] ?: error("Invalid value $value for MessageType")
    }
}
