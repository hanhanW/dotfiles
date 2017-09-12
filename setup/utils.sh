function ask_skip {
  local name=$1
  read -p $'\e[1;32m'"${name}"$' (Y/n)\e[m' choice
  if [[ $choice =~ [Nn] ]]; then
    return 0
  else
    return 1
  fi
}

