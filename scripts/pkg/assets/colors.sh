#! /bin/bash

function set_color() {
	case "$1" in
		"gray")
			echo -e "\033[0;37m";;
        "red")
      echo -e "\033[0;31m";;
        "green")
      echo -e "\033[0;32m";;
        "yellow")
      echo -e "\033[0;33m";;
	      "purple")
			echo -e "\033[0;35m";;
	  *)
      echo -e "\033[0m";;
  esac
}
