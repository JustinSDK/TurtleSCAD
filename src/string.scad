//////////////
// String API
//

// Returns a new string that is a substring of this string. The substring begins at the specified `begin` and extends to the character at index `end` - 1. Thus the length of the substring is `end` - `begin`.
// Parameters: 
//     begin - the beginning index, inclusive.
//     end - the ending index, exclusive.
// Returns:
//     The resulting string.
function sub_string(string, begin, end, result = "") =
    end == undef ? sub_string(string, begin, len(string)) : (
        begin == end ? result : sub_string(string, begin + 1, end, str(result, string[begin]))
    );


// Splits this string around matches of the given delimiting character.
// Parameters: 
//     string - the source string.
//     delimiter - the delimiting character.    
function split(string, delimiter) = 
        len(search(delimiter, string)) == 0 ? [string] : split_string_by(search(delimiter, string, 0)[0], string);
        
function split_string_by(indexes, string, strings = [], i = -1) = 
    i == -1 ? split_string_by(indexes, string, [sub_string(string, 0, indexes[0])], i + 1) : (
        i == len(indexes) - 1 ? concat(strings, sub_string(string, indexes[i] + 1)) : 
                split_string_by(indexes, string, concat(strings, sub_string(string, indexes[i] + 1, indexes[i + 1])), i + 1)
    );        

// Parse string to number
// Parameters: 
//     string - the source string.
// Results:
//     The resulting number.
function parse_number(string) = string[0] == "-" ? -parse_positive_number(sub_string(string, 1, len(string))) : parse_positive_number(string);
    
function str_num_to_int(num_str, index = 0, mapper = [["0", 0], ["1", 1], ["2", 2], ["3", 3], ["4", 4], ["5", 5], ["6", 6], ["7", 7], ["8", 8], ["9", 9]]) =  
    index == len(mapper) ? -1 : (
        mapper[index][0] == num_str ? mapper[index][1] : str_num_to_int(num_str, index + 1)
    );
    
function parse_positive_int(string, value = 0, index = 0) =
    index == len(string) ? value : parse_positive_int(string, value * pow(10, index) + str_num_to_int(string[index]), index + 1);

function parse_positive_decimal(string, value = 0, index = 0) =
    index == len(string) ? value : parse_positive_decimal(string, value + str_num_to_int(string[index]) * pow(10, -(index + 1)), index + 1);
    
function parse_positive_number(string) =
    len(search(".", string)) == 0 ? parse_positive_int(string) :
        parse_positive_int(split(string, ".")[0]) + parse_positive_decimal(split(string, ".")[1]);