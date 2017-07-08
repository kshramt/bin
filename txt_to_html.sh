#!/bin/bash

{
   # set -xv
   set -o nounset
   set -o errexit
   set -o pipefail
   set -o noclobber

   export IFS=$' \t\n'
   export LANG=en_US.UTF-8
   umask u=rwx,g=,o=


   usage_and_exit(){
      {
         echo '# @i[/path/to/image]'
         echo '# @l[/path/to/link]'
         echo "${0##*/}" '< <in.txt> > <out.html>'
      } >&2
      exit "${1:-1}"
   }

   if [[ $# -ne 0 ]]; then
      usage_and_exit
   fi

   "${AWL:-gawk}" '
BEGIN{
   printf("%s\n", "<html><pre style=\"white-space: pre-wrap;\">");
   is_at = 0;
   at_flag = "\0";
   is_link = 0;
   is_image = 0;
   split("", path_buf);
}
{
   split($0, line, "");
   n_line = length(line);
   for(i = 1; i <= n_line; i++){
      c = line[i];
      if(is_link){
         if(c == "]"){
            is_link = 0;
            printf("%s", "\">");
            n = length(path_buf);
            for(j = 1; j <= n; j++){
               printf("%s", path_buf[j]);
            }
            printf("%s", "</a>");
            split("", path_buf);
         }else{
            printf("%s", c);
            path_buf[length(path_buf) + 1] = c;
         }
      }else if(is_image){
         if(c == "]"){
            is_image = 0;
            n = length(path_buf);
            if(n >= 4 && path_buf[n - 3] == "." && path_buf[n - 2] == "p" && path_buf[n - 1] == "d" && path_buf[n] == "f"){
               printf("%s", "<object width=50% max-width=70ex max-height=70ex min-height=20ex data=\"");
            }else{
               printf("%s", "<img width=50% max-width=70ex max-height=70ex src=\"");
            }
            for(j = 1; j <= n; j++){
               printf("%s", path_buf[j]);
            }
            printf("%s", "\" />");
            split("", path_buf);
         }else{
            path_buf[length(path_buf) + 1] = c;
         }
      }else if(at_flag == "l"){
         at_flag = "\0";
         if(c == "["){
            is_link = 1;
            printf("%s", "<a href=\"");
         }else{
            printf("%s", "@");
            printf("%s", "l");
            printf("%s", c);
         }
      }else if(at_flag == "i"){
         at_flag = "\0";
         if(c == "["){
            is_image = 1;
         }else{
            printf("%s", "@");
            printf("%s", "i");
            printf("%s", c);
         }
      }else if(is_at){
         is_at = 0;
         if((c == "l") || (c == "i")){
            at_flag = c;
         }else{
            printf("%s", "@");
            printf("%s", c);
         }
      }else if(c == "&"){
         printf("%s", "&amp");
      }else if(c == "<"){
         printf("%s", "&lt");
      }else if(c == ">"){
         printf("%s", "&gt");
      }else if(c == "\""){
         printf("%s", "&quot");
      }else if(c == "'"'"'"){
         printf("%s", "&#39");
      }else if(c == "\t"){
         printf("%s", "&#9");
      }else if(c == "@"){
         is_at = 1;
      }else{
         printf("%s", c);
      }
   }
   printf("%s", "\n")
}
END{
   printf("%s\n", "</pre></html>");
}
'
   exit
}
