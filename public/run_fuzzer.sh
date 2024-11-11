./fuzz_target public/inputs/sam.bmp | while read -r line; do
   if [[ $line == *"INFO"* ]]; then echo -e "\033[0;36m${line}\033[0m";
   elif [[ $line == *"NEW"* ]]; then echo -e "\033[0;32m${line}\033[0m";
   elif [[ $line == *"REDUCE"* ]]; then echo -e "\033[0;33m${line}\033[0m";
   elif [[ $line == *"ERROR"* || $line == *"FAIL"* ]]; then echo -e "\033[0;31m${line}\033[0m";
   else echo "$line"; fi;
done
