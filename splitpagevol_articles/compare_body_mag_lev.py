import os
scripts = os.listdir("./year_regex_scripts_body_mag_lev")
# print(file1)
scripts_list=[]
for x in scripts:
   short_txt = x[:13]
   scripts_list.append(short_txt)
#print(file1_list)

output = os.listdir("./year_regex_output_body_mag_lev")
output_list=[]
for x in output:
    short_txt2 = x[:13]
    output_list.append(short_txt2)
#print(output_list)
for i in scripts_list:
    if i in output_list:
        pass
    else:
        print(i + " is not in year_regex_output_body_mag_lev")


scored= os.listdir("./year_regex_scored_body_mag_lev")
scored_list = []
for x in scored:
    short_txt3 = x[:13]
    scored_list.append(short_txt3)
# print(scored_list[1:])
for i in scripts_list:
    if i in scored_list:
        pass
    else:
	     print(i + " is not in year_regex_scored_body_mag_lev")
