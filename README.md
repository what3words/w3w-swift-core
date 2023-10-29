# <img valign='top' src="https://what3words.com/assets/images/w3w_square_red.png" width="64" height="64" alt="what3words">&nbsp;w3w-swift-types

Overview
--------

This library contains the core types used by many of the what3words Swift libraries.

## Notable Types

##### W3WSuggestion

This contains information about an address, usually returned by am `autosuggest` call.

##### W3WSquare

This contains information about a what3words square, including it's bounding box and centre coordinate.

##### W3WProtocolV4

This is a protocol defining an interface to a what3words geocoder engine or API.  The Core SDK and the API wrapper both adhere to this protocol and all components and libraries use it to query information.  This allows full interoperability between the SDK and API in the code base.

##### W3WVoiceProtocol

This protocol is used by all voice and audio components, libraries, and audio sources to allow interchanging between different voice recognition systems.  

##### W3WRegex

This is a utility class that contain regexes useful to what3words applications.