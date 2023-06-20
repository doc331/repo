import "pe"

rule myOwnRule

{ 

    meta:
        description = "3102 code features"
        author = "Seth Hardy"
        last_modified = "2014-06-25"

    strings:
        $a1 = "320518054246Z0P1" fullword

    condition:
        any of them
}
