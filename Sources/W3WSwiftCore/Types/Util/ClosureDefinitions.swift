//
//  File.swift
//  
//
//  Created by Dave Duprey on 07/11/2022.
//


public typealias W3WSquareResponse                      = (W3WSquare?, W3WError?) -> ()
public typealias W3WSquaresResponse                     = ([W3WSquare]?, W3WError?) -> ()

public typealias W3WSuggestionsResponse                 = ([W3WSuggestion]?, W3WError?) -> ()
public typealias W3WSuggestionSelectedResponse          = (W3WSuggestion) -> ()

public typealias W3WSuggestionWithCoordinates           = W3WSquare
public typealias W3WSuggestionsWithCoordinatesResponse  = ([W3WSuggestionWithCoordinates]?, W3WError?) -> ()

public typealias W3WVoiceSuggestionsResponse            = ([W3WVoiceSuggestion]?, W3WError?) -> ()

public typealias W3WGridResponse                        = ([W3WLine]?, W3WError?) -> ()

public typealias W3WLanguagesResponse                   = ([W3WLanguage]?, W3WError?) -> ()

public typealias W3WErrorResponse                       = (W3WError) -> ()

