Feature: check endpoint test

  Background:
    * url 'https://qap2-d4djlnl0.review-apps.contractbook.com'

  Scenario Outline: check api with existing pattern

    Given path '/load'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {chunk:<chunk>}
    When method POST
    Then status 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 200
    And match $ == {exists: true}


    Examples:
      | chunk   | pattern |
      | [1,2,3] | [2,3] |
      | [-121,00,1567] | [-121,00] |
      | [222,2,2222,22,889] | [2,2222,22] |

  Scenario Outline: check api with non existing pattern

    Given path '/load'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {chunk:<chunk>}
    When method POST
    Then status 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 200
    And match $ == {exists: false}


    Examples:
      | chunk   | pattern |
      | [1,2,3] | [1,3] |
      | [-121,00,1567] | [-121,15] |
      | [222,2,2222,22,889] | [2,22] |
      | [888,2,33] | [34] |

  Scenario Outline: check api with empty pattern

    Given path '/load'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {chunk:<chunk>}
    When method POST
    Then status 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 200
    And match $ == {exists: false}

    Examples:
      | chunk   | pattern |
      | [1,2,3] | [] |

  Scenario Outline: check api with buffer cleared after successful request

    Given path '/load'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {chunk:<chunk>}
    When method POST
    Then status 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 200
    And match $ == {exists: true}

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 400

    Examples:
      | chunk   | pattern |
      | [99,88,77] | [77] |

  Scenario Outline: check api with buffer not cleared after failure request

    Given path '/load'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {chunk:<chunk>}
    When method POST
    Then status 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern1>}
    When method POST
    Then status 422

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern2>}
    When method POST
    Then status 200
    And match $ == {exists: true}

    Examples:
      | chunk      | pattern1 |  pattern2 |
      | [99,88,77] | [aa]     |   [77]    |

  Scenario Outline: check api with pattern size above 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 413

    Examples:
      | pattern        |
      | [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201] |

  Scenario Outline: check api with pattern size equal to 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 200

    Examples:
      | pattern        |
      | [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200] |

  Scenario Outline: check api with pattern as String data

    Given path '/load'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {chunk:<chunk>}
    When method POST
    Then status 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 400

    Examples:
      | chunk        | pattern |
      | [11, 22] | [nn, aa] |

  Scenario Outline: check api with pattern as float data

    Given path '/load'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {chunk:<chunk>}
    When method POST
    Then status 200

    Given path '/check'
    And header api-key = '67KEXKJP2IXVVLTA21Y2'
    And request {pattern:<pattern>}
    When method POST
    Then status 400

    Examples:
      | chunk       | pattern |
      | [22, 3333]  | [1.9, 22] |