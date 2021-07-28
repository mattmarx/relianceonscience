import sys
from unidecode import unidecode
arg1=sys.argv[1]
arg2=sys.argv[2]

input= open(arg1)
outputfile = open(arg2,"w")
output=[]
for x in input:
    asciistring =unidecode(unidecode(x))
    newstr = asciistring.replace("(", " ")
    newstr1 = newstr.replace(")", " ")
    newstr2 = newstr1.replace("[", " ")
    newstr3 = newstr2.replace("]", " ")
    newstr4 = newstr3.replace("{", " ")
    newstr5 = newstr4.replace("}", " ")
    newstr6 = newstr5.replace("\\", "\ ")
    newstr7 = newstr6.replace("**", "* ")
    newstr8 = newstr7.replace("*", " *")
    newstr9 = newstr8.replace("???", " ?")
    output.append(newstr9)
outputfile.writelines(output)
