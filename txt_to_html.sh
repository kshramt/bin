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
      exit "${1}"
   }

   if [[ $# -ne 0 ]]; then
      usage_and_exit 1
   fi

   "${AWL:-gawk}" '
function escape(c){
   ret = c;
   if(c == "&"){
      ret = "&amp";
   }else if(c == "<"){
      ret = "&lt";
   }else if(c == ">"){
      ret = "&gt";
   }else if(c == "\""){
      ret = "&quot";
   }else if(c == "'"'"'"){
      ret = "&#39";
   }else if(c == "\t"){
      ret = "&#9";
   }
   return ret;
}


function pr(c){
   printf("%s", escape(c));
}


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
               pr(path_buf[j]);
            }
            printf("%s", "</a>");
            split("", path_buf);
         }else{
            pr(c);
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
               pr(path_buf[j]);
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
            pr("@");
            pr("l");
            pr(c);
         }
      }else if(at_flag == "i"){
         at_flag = "\0";
         if(c == "["){
            is_image = 1;
         }else{
            pr("@");
            pr("i");
            pr(c);
         }
      }else if(is_at){
         is_at = 0;
         if((c == "l") || (c == "i")){
            at_flag = c;
         }else{
            pr("@");
            pr(c);
         }
      }else if(c == "@"){
         is_at = 1;
      }else{
         pr(c);
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
