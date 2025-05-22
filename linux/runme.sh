#!/bin/bash

# if [ "$1" = "--prepare-env" ]; then
#  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#  mkdir -p ~/Scripts

#  echo "Copying the script to $HOME/Scripts"
#  cp -rf $DIR/runme.sh  ~/Scripts/jetbrains-reset.sh
#  chmod +x ~/Scripts/jetbrains-reset.sh

#  echo
#  echo "Copying com.jetbrains.reset.plist to $HOME/Library/LaunchAgents"
#  cp -rf $DIR/com.jetbrains.reset.plist ~/Library/LaunchAgents

#  echo
#  echo "Loading job into launchctl"
#  launchctl load ~/Library/LaunchAgents/com.jetbrains.reset.plist

#  echo
#  echo "That's it, enjoy ;)"
#  exit 0
# fi

# if [ "$1" = "--launch-agent" ]; then
#   PROCESS=(idea webstorm datagrip phpstorm clion pycharm goland rubymine rider)
#   COMMAND_PRE=("${PROCESS[@]/#/MacOS/}")

#   # Kill all Intellij applications
#   kill -9 `ps aux | egrep $(IFS=$'|'; echo "${COMMAND_PRE[*]}") | awk '{print $2}'`
# fi

# Reset Intellij evaluation
for product in IntelliJIdea WebStorm DataGrip PhpStorm CLion PyCharm GoLand RubyMine Rider; do
  echo "[+] Resetting trial period for $product"

  echo "[+] Removing Evaluation Key..."
  rm -rf ~/.config/$product*/eval 2> /dev/null

  # Above path not working on latest version, Fixed below
  rm -rf ~/.config/JetBrains/$product*/eval 2> /dev/null

  echo "[+] Removing all evlsprt properties in options.xml..."
  sed -i 's/evlsprt//' ~/.config/$product*/options/other.xml 2> /dev/null

  # Above path not working on latest version, Fixed below
  sed -i 's/evlsprt//' ~/.config/JetBrains/$product*/options/other.xml 2> /dev/null

  echo
done

echo "Removing userPrefs files..."
rm -rf ~/.java/.userPrefs 2> /dev/null

echo
echo "That's it, enjoy ;)"

# Flush preference cache
if [ "$1" = "--launch-agent" ]; then
  killall cfprefsd
  echo "Evaluation was reset at $(date)" >> ~/Scripts/logs
fi
