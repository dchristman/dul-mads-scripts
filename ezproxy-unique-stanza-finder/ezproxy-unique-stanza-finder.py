import sys
import re

def remove_whitespace(input_string):
    # Use regular expression to replace all whitespace and extra characters with an empty string; also remove the protocol prefix
    result = re.sub(r'\s+|https?://', '', input_string)
    return result

#Get filenames from sys.argv, first the file with uniques then the file to dedupe from.
main_stanzas_filename = sys.argv[1]
search_stanzas_filename = sys.argv[2]

#open the first file, iterate through. For every HJ, remove the HJ, all whitespace (beginning and end), and add to array.
main_stanzas_list = []
main_stanza_file = open(main_stanzas_filename,"r", encoding='utf8')

for stanza in main_stanza_file:
    if stanza[:2] == "HJ":
        main_stanzas_list.append(remove_whitespace(stanza[2:]))

main_stanza_file.close
print (len(main_stanzas_list))
main_stanzas_list = list(dict.fromkeys(main_stanzas_list))
print (len(main_stanzas_list))

#open the send file. Iterate through. For every HJ, remove the HJ, all whitespace (beginning and end). If it is in first file array, remove from first file array.
search_stanzas_file = open(search_stanzas_filename,"r", encoding="utf8")
for stanza in search_stanzas_file:
    if stanza[:2] == "HJ":
        check_value = remove_whitespace(stanza[2:])
        if check_value in main_stanzas_list:
            main_stanzas_list.remove(check_value)
search_stanzas_file.close()
print (len(main_stanzas_list))

#save list of remaining entries in first file array.
unique_stanzas = open("unique-stanzas.txt","w")
unique_stanzas.write('\n'.join(main_stanzas_list))
unique_stanzas.close()