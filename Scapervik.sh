#!/bin/bash

Black="\e[1;90m"                 Red="\e[1;91m"
Green="\e[1;92m"
Yellow="\e[1;93m"
Blue="\e[1;94m"
Purple="\e[1;95m"
Cyan="\e[1;96m"
White="\e[1;97m"

banner () {
  echo -e "${Green}Rapid85"
  printf "\n\e[1;77m     A web scraping tool designed to extract email addresses and phone numbers from websites.      \e[0m\n\n"
  echo -e "\e[0;96m                Developed by: ${Red}Rapid85 (t.me/VikingTerminal)\n\n\n"

  # Add a disappearing message
  sleep 3
  clear
}

internet () {
  sleep 0.5
  echo -e "$White[$Red!$White] ${Red}Checking your internet connection"
  wget -q --spider http://google.com
  if [ $? -eq 0 ]; then
    echo -e "$White[$Yellow*$White] ${Yellow}Connected"
  else
    sleep 0.5
    echo -e "$White[$Red!$White] ${Red}No internet connection. Please try again."
    exit
  fi
}

email_scraping () {
  echo -e "$White[${Yellow}*$White] ${Yellow}Scraping emails...${White}"
  grep -i -o '[A-Z0-9._%+-]\+@[A-Z0-9.-]\+\.[A-Z]\{2,4\}' temp.txt | sort -u > email.txt
  if [[ -s email.txt ]]; then
    echo -e "$White[${Yellow}*$White] ${Yellow}Emails scraped successfully${White}"
    cat email.txt
  else
    echo -e "$White[${Red}!$White] ${Red}No emails found"
    rm email.txt
  fi
}

phone_scraping () {
  echo -e "$White[${Yellow}*$White] ${Yellow}Scraping phone numbers...${White}"
  grep -o '\([0-9]\{3\}\-[0-9]\{3\}\-[0-9]\{4\}\)\|\(([0-9]\{3\})[0-9]\{3\}\-[0-9]\{4\}\)\|\([0-9]\{10\}\)\|\([0-9]\{3\}\s[0-9]\{3\}\s[0-9]\{4\}\)' temp.txt | sort -u > phone.txt
  if [[ -s phone.txt ]]; then
    echo -e "$White[${Yellow}*$White] ${Yellow}Phone numbers scraped successfully${White}"
    cat phone.txt
  else
    echo -e "$White[${Red}!$White] ${Red}No phone numbers found"
    rm phone.txt
  fi
}

scraper () {
  curl -s "$url" > temp.txt
  if [ "$email" = "Y" ] || [ "$email" = "y" ]; then
    email_scraping
  fi
  if [ "$phone" = "Y" ] || [ "$phone" = "y" ]; then
    phone_scraping
  fi
  rm temp.txt
  if [[ -f "email.txt" ]] || [[ -f "phone.txt" ]]; then
    sleep 0.4
    read -p $'\e[1;97m[\e[1;92m*\e[1;97m]\e[1;92m Do you want to save the file (y/n) : \e[1;97m' save_output
    if [ "$save_output" = "Y" ] || [ "$save_output" = "y" ]; then
      output
    fi
  fi
  sleep 0.4
  echo -e "$White[${Red}!$White] ${Red}Exiting....\n"
  rm email.txt phone.txt 2> /dev/null
  exit
}

output () {
  sleep 0.4
  read -p $'\e[1;97m[\e[1;92m*\e[1;97m]\e[1;92m Enter output file name (default: output.txt): \e[1;97m' custom_output

  output_file="${custom_output:-output.txt}"

  if [ -e "$output_file" ]; then
    echo -e "$White[${Red}!$White] ${Red}File already exists"
    output
  fi

  mv email.txt "$output_file" 2> /dev/null
  mv phone.txt "$output_file" 2> /dev/null

  sleep 0.3
  echo -e "$White[${Green}*$White] ${Cyan}Output saved to $output_file"
  sleep 0.4
  echo -e "$White[${Red}!$White] ${Red}Exiting....\n"
  exit
}

scanner () {
  sleep 0.5
  read -p $'\e[1;97m[\e[1;92m*\e[1;97m]\e[1;92m Enter URL to begin : \e[1;97m' url
  url_validity='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

  if [[ $url =~ $url_validity ]]; then
    read -p $'\e[1;97m[\e[1;92m*\e[1;97m]\e[1;92m Scrape emails from website (y/n) : \e[1;97m' email
    read -p $'\e[1;97m[\e[1;92m*\e[1;97m]\e[1;92m Scrape phone numbers from website (y/n) : \e[1;97m' phone

    if [ "$email" = "Y" ] || [ "$email" = "y" ] || [ "$phone" = "Y" ] || [ "$phone" = "y" ]; then
      echo -e "$White[${Red}!$White] ${Red}Scraping started"
      scraper
    fi

    sleep 0.4
    echo -e "$White[${Red}!$White] ${Red}Exiting....\n"

    
    echo -e "Thank you for using this tool. Visit t.me/VikingTerminal to try other utilities."
    exit
  else
    echo -e "$White[${Red}!$White] ${Red}Check your URL (invalid)"
    scanner
  fi
}

banner
internet
scanner
