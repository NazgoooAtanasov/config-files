syntax keyword pigKeywords if else while return fn let
syntax match pigNumgers "\v\d+"
syntax region pigStrings start=/"/ end=/"/
syntax match pigFunctions "\vfn\s+\zs\w+"

highlight link pigKeywords Keyword
highlight link pigNumbers Number
highlight link pigStrings String
highlight link pigFunctions Function
