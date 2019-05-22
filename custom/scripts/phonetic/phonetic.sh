#!/bin/sh

pass show "${@}" | fold -w1 | while read CHARACTER
do
    case ${CHARACTER} in
	'!')
	    echo -n 'Bang' &&
		true
	    ;;
	'@')
	    echo -n 'At' &&
		true
	    ;;
	'#')
	    echo -n 'Pound' &&
		true
	    ;;
	'\$')
	    echo -n 'Dollar' &&
		true
	    ;;
	'%')
	    echo -n 'Percent' &&
		true
	    ;;
	'^')
	    echo -n 'Caret' &&
		true
	    ;;
	'&')
	    echo -n 'Ampersand' &&
		true
	    ;;
	'*')
	    echo -n 'Asterisk' &&
		true
	    ;;
	'(')
	    echo -n 'OpenRoundBracket' &&
		true
	    ;;
	')')
	    echo -n 'CloseRoundBracket' &&
		true
	    ;;
	'-')
	    echo -n 'Minus' &&
		true
	    ;;
	'=')
	    echo -n 'Equals' &&
		true
	    ;;
	'[')
	    echo -n 'OpenSquareBracket' &&
		true
	    ;;
	']')
	    echo -n 'CloseSquareBracker' &&
		true
	    ;;
	'\\')
	    echo -n 'BackwardSlash' &&
		true
	    ;;
	';')
	    echo -n 'SemiColon' &&
		true
	    ;;
	"'")
	    echo -n 'SingleQuote' &&
		true
	    ;;
	',')
	    echo -n 'Comma' &&
		true
	    ;;
	'.')
	    echo -n 'Period' &&
		true
	    ;;
	'/')
	    echo -n 'ForwardSlash' &&
		true
	    ;;
	'_')
	    echo -n 'UnderScore' &&
		true
	    ;;
	'+')
	    echo -n 'Plus' &&
		true
	    ;;
	'{')
	    echo -n 'OpenCurlyBracket' &&
		true
	    ;;
	'}')
	    echo -n 'CloseCurlyBracket' &&
		true
	    ;;
	'|')
	    echo -n 'Pipe' &&
		true
	    ;;
	':')
	    echo -n 'Colon' &&
		true
	    ;;
	"\"")
	    echo -n "DoubleQuote" &&
		true
	    ;;
	'<')
	    echo -n 'LessThan' &&
		true
	    ;;
	'>')
	    echo -n 'GreaterThan' &&
		true
	    ;;
	'?')
	    echo -n 'QuestionMark' &&
		true
	    ;;
	'`')
	    echo -n 'Grave' &&
		true
	    ;;
	'~')
	    echo -n 'Tilde' &&
		true
	    ;;
	'1')
	    echo 'One' &&
		true
	    ;;
	'2')
	    echo 'Two' &&
		true
	    ;;
	'3')
	    echo 'Three' &&
		true
	    ;;
	'4')
	    echo 'Four' &&
		true
	    ;;
	'5')
	    echo 'Five' &&
		true
	    ;;
	'6')
	    echo 'Six' &&
		true
	    ;;
	'7')
	    echo 'Seven' &&
		true
	    ;;
	'8')
	    echo 'Eight' &&
		true
	    ;;
	'9')
	    echo 'Nine' &&
		true
	    ;;
	'A')
	    echo -n 'ALPHA' &&
		true
	    ;;
	'B')
	    echo -n 'BRAVO' &&
		true
	    ;;
	'C')
	    echo -n 'CHARLIE' &&
		true
	    ;;
	'D')
	    echo -n 'DELTA' &&
		true
	    ;;
	'E')
	    echo -n 'ECHO' &&
		true
	    ;;
	'F')
	    echo -n 'FOXTROT' &&
		true
	    ;;
	'G')
	    echo -n 'GOLF' &&
		true
	    ;;
	'H')
	    echo -n 'HOTEL' &&
		true
	    ;;
	'I')
	    echo -n 'INDIA' &&
		true
	    ;;
	'J')
	    echo -n 'JULIET' &&
		true
	    ;;
	'K')
	    echo -n 'KILO' &&
		true
	    ;;
	'L')
	    echo -n 'LIMA' &&
		true
	    ;;
	'M')
	    echo -n 'MIKE' &&
		true
	    ;;
	'N')
	    echo -n 'NOVEMBER' &&
		true
	    ;;
	'O')
	    echo -n 'OSCAR' &&
		true
	    ;;
	'P')
	    echo -n 'PAPA' &&
		true
	    ;;
	'Q')
	    echo -n 'QUEBEC' &&
		true
	    ;;
	'R')
	    echo -n 'ROMEO' &&
		true
	    ;;
	'S')
	    echo -n 'SIERRA' &&
		true
	    ;;
	'T')
	    echo -n 'TANGO' &&
		true
	    ;;
	'U')
	    echo -n 'UNIFORM' &&
		true
	    ;;
	'V')
	    echo -n 'VICTOR' &&
		true
	    ;;
	'W')
	    echo -n 'WHISKEY' &&
		true
	    ;;
	'X')
	    echo -n 'XRAY' &&
		true
	    ;;
	'Y')
	    echo -n 'YANKEE' &&
		true
	    ;;
	'Z')
	    echo -n 'ZULU' &&
		true
	    ;;	
	'a')
	    echo -n 'ant' &&
		true
	    ;;
	'b')
	    echo -n 'bear' &&
		true
	    ;;
	'c')
	    echo -n 'chicken' &&
		true
	    ;;
	'd')
	    echo -n 'dog' &&
		true
	    ;;
	'e')
	    echo -n 'elephant' &&
		true
	    ;;
	'f')
	    echo -n 'ferret' &&
		true
	    ;;
	'g')
	    echo -n 'gorilla' &&
		true
	    ;;
	'h')
	    echo -n 'hyena' &&
		true
	    ;;
	'i')
	    echo -n 'iguana' &&
		true
	    ;;
	'j')
	    echo -n 'jaguar' &&
		true
	    ;;
	'k')
	    echo -n 'kangaroo' &&
		true
	    ;;
	'l')
	    echo -n 'llama' &&
		true
	    ;;
	'm')
	    echo -n 'mongoose' &&
		true
	    ;;
	'n')
	    echo -n 'newt' &&
		true
	    ;;
	'o')
	    echo -n 'octopus' &&
		true
	    ;;
	'p')
	    echo -n 'parrot' &&
		true
	    ;;
	'q')
	    echo -n 'quail' &&
		true
	    ;;
	'r')
	    echo -n 'rat' &&
		true
	    ;;
	's')
	    echo -n 'salmon' &&
		true
	    ;;
	't')
	    echo -n 'tapir' &&
		true
	    ;;
	'u')
	    echo -n 'upapa' &&
		true
	    ;;
	'v')
	    echo -n 'viper' &&
		true
	    ;;
	'w')
	    echo -n 'whale' &&
		true
	    ;;
	'x')
	    echo -n 'xolo' &&
		true
	    ;;
	'y')
	    echo -n 'yak' &&
		true
	    ;;
	'z')
	    echo -n 'zebra' &&
		true
	    ;;
	*)
	    echo -n uNKNOWN &&
		true
	    ;;
    esac &&
	echo -n ' ' &&
	true
done &&
    true
