if ! command -v apt-get >/dev/null 2>&1; then
  echo $'\e[1;31mNo apt-get?!\e[m'
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo $'\e[1;33mgit not installed, installing...\e[m'
  sudo apt-get update
  sudo apt-get -y install git
fi

if ! command -v python >/dev/null 2>&1; then
  echo $'\e[1;33mpython not installed, installing...\e[m'
  sudo apt-get update
  sudo apt-get -y install python-is-python3
fi

git clone https://github.com/hanhanW/dotfiles ~/dotfiles
cd ~/dotfiles
git remote set-url --push origin git@github.com:hanhanW/dotfiles.git
./install
