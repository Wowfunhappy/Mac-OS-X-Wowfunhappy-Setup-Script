#!/bin/bash

# Run this script after installing Mac OS X.

#-----------------------------------------------------------------------------------------


clear

if (( $(echo "${OSTYPE:6} < 8 && ${OSTYPE:6} > 18" | bc -l) ))
then
	echo "This script is only compatible with Mac OS X 10.4 Tiger through macOS 10.14 Mojave. No changes have been made to your computer."
	sleep 30
	exit
fi

if ([[ $(csrutil status) = *enabled* ]])
then
	echo "Please disable System Integrity Protection. Follow the below instructions:"
	echo ""
	echo "1) Restart with ⌘R keys held down to enter recovery mode"
	echo "2) Open Utilities → Terminal"
	echo "3) Type \"csrutil disable\" and press enter"
	echo "4) Restart your computer normally."
	echo ""
	echo "Alternately, if you're using Clover, set CsrActiveConfig to 0x67"
	echo ""
	echo "Run this script again when you're done."
	sleep 30
	exit
fi

clear
echo "Please type in your password. No letters will appear as you type."
echo "Press the enter key when you're done."
sudo true # authorize for later

killall TextEdit Mail Safari Notes cfprefsd
sleep 1



# Attempt to use the below Spotlight preferences on 10.10+. Only sometimes works

if (( $(echo "${OSTYPE:6} > 13" | bc -l) ))
then
	defaults write com.apple.spotlight orderedItems '({"enabled" = 1;"name" = "APPLICATIONS";},{"enabled" = 1;"name" = "PDF";},{"enabled" = 0;"name" = "MESSAGES";},{"enabled" = 1;"name" = "CONTACT";},{"enabled" = 0;"name" = "EVENT_TODO";},{"enabled" = 1;"name" = "IMAGES";},{"enabled" = 0;"name" = "BOOKMARKS";},{"enabled" = 1;"name" = "MUSIC";},{"enabled" = 1;"name" = "MOVIES";},{"enabled" = 0;"name" = "FONTS";},{"enabled" = 1;"name" = "MENU_OTHER";})'
	sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.spotlight orderedItems '({"enabled" = 1;"name" = "APPLICATIONS";},{"enabled" = 1;"name" = "PDF";},{"enabled" = 0;"name" = "MESSAGES";},{"enabled" = 1;"name" = "CONTACT";},{"enabled" = 0;"name" = "EVENT_TODO";},{"enabled" = 1;"name" = "IMAGES";},{"enabled" = 0;"name" = "BOOKMARKS";},{"enabled" = 1;"name" = "MUSIC";},{"enabled" = 1;"name" = "MOVIES";},{"enabled" = 0;"name" = "FONTS";},{"enabled" = 1;"name" = "MENU_OTHER";})'
fi



# Unhide important directories

xattr -d com.apple.FinderInfo ~/Library
chflags nohidden ~/Library

sudo mkdir /System/Library/User\ Template/Non_localized/Library/LaunchAgents/
echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>Label</key><string>local.show-library</string><key>ProgramArguments</key><array><string>/bin/bash</string><string>-c</string><string>chflags nohidden ~/Library;xattr -d com.apple.FinderInfo ~/Library</string></array><key>RunAtLoad</key><true/></dict></plist>' | sudo tee /System/Library/User\ Template/Non_localized/Library/LaunchAgents/show-library.plist # User template chflags are ignored, so make LaunchAgent to unhide ~/Library for future users.

sudo chflags nohidden /Library
sudo chflags nohidden /usr



# Disable Automatic Termination

defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSDisableAutomaticTermination -bool true



# Make Finder windows open to home directory by default

defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.finder NewWindowTarget -string "PfLo"



# Show path bar in Finder

defaults write com.apple.finder ShowPathbar -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.finder ShowPathbar -bool true



# Finder: show all filename extensions

defaults write NSGlobalDomain AppleShowAllExtensions -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences AppleShowAllExtensions -bool true



# When performing a search, search the current folder by default

defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.finder FXDefaultSearchScope -string "SCcf"



# Do not save files to iCloud by default

defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSDocumentSaveNewDocumentsToCloud -bool false



# Expand save panel by default

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSNavPanelExpandedStateForSaveMode -bool true



# Disable "Do you want to use this disk to back up with Time Machine?"

defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true



# Don't create .DS_Store files on network and USB drives. They will continue to appear on local drives.

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores -bool true
sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.desktopservices DSDontWriteUSBStores -bool true



# Show battery percentage

defaults write com.apple.menuextra.battery ShowPercent -string "YES"

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.menuextra.battery ShowPercent -string "YES"



# Disable "Smart Lists" and "Smart Links" in Notes app

defaults write com.apple.Notes ShouldUseSmartLinks -bool false
defaults write com.apple.Notes EnableAutomaticListInsertion -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.Notes ShouldUseSmartLinks -bool false
sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.Notes EnableAutomaticListInsertion -bool false



# Disable autocorrect in most apps.

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSAutomaticSpellingCorrectionEnabled -bool false
sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences WebAutomaticSpellingCorrectionEnabled -bool false



# Disable automatic capitalization and period substitution.

defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSAutomaticCapitalizationEnabled -bool false
sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSAutomaticPeriodSubstitutionEnabled -bool false



# Disable smart quotes in most apps.

defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write com.apple.TextEdit SmartQuotes -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSAutomaticQuoteSubstitutionEnabled -bool false
sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.TextEdit SmartQuotes -bool false



# Disable smart dashes in most apps.

defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write com.apple.TextEdit SmartDashes -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSAutomaticDashSubstitutionEnabled -bool false
sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.TextEdit SmartDashes -bool false



# Make TextEdit open HTML files as code.

defaults write com.apple.TextEdit IgnoreHTML -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.TextEdit IgnoreHTML -bool true



# Make email addresses easier to copy from Mail.app.

defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.mail AddressesIncludeNameOnPasteboard -bool false



# Stop Safari websites from prompting to enable push notifications.

defaults write com.apple.Safari CanPromptForPushNotifications -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.Safari CanPromptForPushNotifications -bool false



# Show full URL in Safari's address bar.

defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.Safari ShowFullURLInSmartSearchField -bool true



# Clean up Safari's bookmark bar

defaults write com.apple.Safari ProxiesInBookmarksBar "()"

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.Safari ProxiesInBookmarksBar "()"



# Enable the Develop menu in Safari.

defaults write com.apple.Safari IncludeDevelopMenu -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.Safari IncludeDevelopMenu -bool true



# Prevent Safari from opening downloaded files automatically.

defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads -bool false



# Permanently disable Gatekeeper

sudo spctl --master-disable
sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool NO



# Disable "You are opening this application for the first time."

defaults write com.apple.LaunchServices LSQuarantine -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.LaunchServices LSQuarantine -bool false



# Show only a notification when applications crash.

defaults write com.apple.CrashReporter UseUNC 1

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.CrashReporter UseUNC 1



# Set bash autocompletion to ignore case

printf "set completion-ignore-case On" > ~/.inputrc

sudo bash -c 'printf "set completion-ignore-case On" > /System/Library/User\ Template/Non_localized/.inputrc'



# Shorten bash prompt to show only the current directory.

echo 'export PS1="\W$ "' > ~/.bash_profile

sudo bash -c 'echo "export PS1=\"\W$ \"" > /System/Library/User\ Template/Non_localized/.bash_profile'



# Disable GameKit

defaults write com.apple.gamed Disabled -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.gamed Disabled -bool true



# Disable 32 bit app warning in High Sierra

defaults write NSGlobalDomain CSUIDisable32BitWarning -bool true

defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences CSUIDisable32BitWarning -bool true



# Disable some update notifications

sudo softwareupdate --ignore "macOSInstallerNotification_GM"



# Only check for updates once per year

sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 365



# Don't badge System Preferences

defaults write com.apple.systempreferences AttentionPrefBundleIDs 0

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.systempreferences AttentionPrefBundleIDs 0



# Allow HiDPI on non-Apple monitors

sudo defaults write /Library/Preferences/com.apple.windowserver.plist DisplayResolutionEnabled -bool true



# Give /Applications/Utilities/ the same permissions as /Applications/

sudo chmod 775 /Applications/Utilities/



# Move Terminal to /Applications/

sudo mv /Applications/Utilities/Terminal.app /Applications/



# Remove nonfunctional dashboard widgets. (Requisite servers down as of December 2019.)

sudo rm -rf /Library/Widgets/Flight\ Tracker.wdgt
sudo rm -rf /Library/Widgets/Ski\ Report.wdgt
sudo rm -rf /Library/Widgets/Stocks.wdgt
sudo rm -rf /Library/Widgets/Translation.wdgt
sudo rm -rf /Library/Widgets/Unit\ Converter.wdgt
sudo rm -rf /Library/Widgets/Weather.wdgt



# Remove useless applications

sudo rm -rf /Applications/Books.app
sudo rm -rf /Applications/iBooks.app
sudo rm -rf /Applications/Chess.app
sudo rm -rf /Applications/DVD\ Player.app
sudo rm -rf /Applications/Game\ Center.app
sudo rm -rf /Applications/Home.app
sudo rm -rf /Applications/iSync.app
sudo rm -rf /Applications/Launchpad.app
sudo rm -rf /Applications/News.app
sudo rm -rf /Applications/Photos.app
sudo rm -rf /Applications/Siri.app
sudo rm -rf /Applications/Stickies.app
sudo rm -rf /Applications/Stocks.app
sudo rm -rf /Applications/VoiceMemos.app
sudo rm -rf /Applications/iTunes.app
sudo rm -rf /System/Library/Screen\ Savers/iTunes\ Artwork.saver



# Prevent media keys from attempting to launch iTunes in 10.9.5 (13F1911)

if [ $(shasum /System/Library/CoreServices/rcd.app/Contents/MacOS/rcd | awk '$0=$1') = "fffb4d6ec495a1382364f73c6a0f45ca4f42c563" ]; then
	RCDPATCH=`mktemp -t rcd-patch`
	echo QlNESUZGNDBcAAAAAAAAAKUDAAAAAAAAQCUBAAAAAABCWmg5MUFZJlNZYDMG+AAAJv9D+FGCAABABAAAEEBAIABACAACQAAAAyAAIZNUyPQJibUKBpoZGTE4qJ7vbGHhqkkDl99EjLDUq6+7Qk1EhER+LuSKcKEgwGYN8EJaaDkxQVkmU1kWxGS8AAA8////3eLFYmBbiGzXbb5APARSwf////B2d//Cxn/9yudf78ADDNDLgl26iJqNEyjIeUNDTQAAAANAaNBoBoA0GnqNAaNAAAAAAeoyDag1DUpsoGQGgA0AaGmgAAAAAABkaAAADIAAAPUPUGgEiiTRMmUeoGTQGgDRppoANNDQaANAGmjTQA0aAAAAGmQAPQmgklEap6ntRPyk9I8ptT1GRoZPSZNAA0MIwgGRkZGEABoMgMTTTRk0YRkwCPwd9ZYipTAJcujCuaSYdXpf3T6/r3vHiYNdTNwGAMYOdyEopjwEJFiiji4FzAyg/PMLTl0MVywhma8oQ4USDaaLNgFkwItAfloSSIsQvXIgCiwSsGKGNr48ZmCyQcwt8IJnMOB4QDu16hJBQHRatY58ZJrma4loXO1dligFuBJJXzVVVWh6VMx37gCQBIkXmL9d7urGprq0noSVFgri2hx2aVovNrD+ZyCP8xXb1oxUXxGK6esZSYpjQGoYjQOe0hAF7escEECygTmpDpzBsjPd1WQEkkxsPvfQIqg1BoAptISQdti4M2AkLsdbC7UlRysWXuURxMk5SrOcPlNVogsvQNBsruBpc5wQi9t0lnhZ0SPw8hly4xvJmv4FCm3aL7+O0R4btNBMpSmpM3qQEMEFd13IlAO8HavsBA0CdhAAp54IIir7BYJ8Qjq2O9ExDPRGdK5mCQ4sKYi+qpb9UUH5yo1SlHYYB+cYjoGSUAg9b5I9+TA8KFB/SkQQIIqk4bL2nDITXBkiDQFJoDZMhM6SlA6QoUWfBwPq9GdfEElInSWTEM/EMiYINgEhzPYaWSUDA7NMwW1DDQMiMpu9njcV85CTzaaDSJQgiCpRZ6CQIjZpPqKMERjL2L5QQBMgKEcNsMOAZwMOMREGDoWJTGVzq6SEpcmVuJCdQTabN3fttYEybua2Owdr8p6CKy9xb1yCTX2YEUGhyWVyzhCQmuauBBBV/00v5gdZ430edL2XmPJRGZhqnqXunCA8kSpuUA6QAMAJeGbJFmohZhVkGDv0IJ5CDRoaGPYmAIyhzCPlaeiMAREAtoRbbbY22gz0mQiR2UCwlnWc9VjLVqoyDKX0/VGUFhPamU4shIBE2T8bFwcR8JAnxykjAYIDDmmrilK0HDFyoHfiTZsEhAGRu4HqqQkGYmHNigrMOBPatKUsVVDQQFjAAKpjBLPeI8P8XckU4UJAWxGS8EJaaDkxQVkmU1lvweEyAAAg/P/OGCgpYEQqEEIAJQqAoAkAAAgEwIACgAJAACAIIABBWoAAABk0YmjxQw0MmQMjEGJk0NMGgAlhBAAhwtXTYuZKRxSwm6jvwrlnYuI+3m0X/GZYKI2IAPxdyRThQkG/B4TI | base64 --decode > $RCDPATCH
	sudo mv /System/Library/CoreServices/rcd.app/Contents/MacOS/rcd /System/Library/CoreServices/rcd.app/Contents/MacOS/rcd-bk
	sudo bspatch /System/Library/CoreServices/rcd.app/Contents/MacOS/rcd-bk /System/Library/CoreServices/rcd.app/Contents/MacOS/rcd $RCDPATCH
	sudo chmod +x /System/Library/CoreServices/rcd.app/Contents/MacOS/rcd
fi

if [ $(shasum /System/Library/CoreServices/AVRCPAgent.app/Contents/MacOS/AVRCPAgent | awk '$0=$1') = "798f7271d1a499c879807fc9f9a2e774b5b62bba" ]; then
	AVRCPPATCH=`mktemp -t AVRCPAgent-patch`
	echo QlNESUZGNDBQAAAAAAAAAO0CAAAAAAAAUGkBAAAAAABCWmg5MUFZJlNZqSgABwAAGP5D+DCIAAEkQEAEAABAQAAEAAAAgEAgACGk0NNDQxCmTEyDIxcLlkCECHGMif3o67zDSY+LuSKcKEhUlAADgEJaaDkxQVkmU1mF9SE7AABb///Y3Pvu0//uXNNlH1T1TJxJV9LwwED+7+Mb+N+/6////8ACTgQG0GiJM1FGjTQ0DTTR6hkA0NAGgAaaBoPUPUyaDNT1HqaANPQT2VPKMnqNP1MoyeMKeppMhVIP3pNSgAAAAAAADQAAAAAAAAAAAAAAAADRBkwgyAaGIMmmjJgIwIyaZNDRiDEZMAmjQGjIGIaYTTI00aBkyZMACJSSgaNA0AEwGgAAaBMAABMAAAAAABBgAAAABpIAQIpDp6AFZLmNv/OdlRMSAZLy1XHN+u++SjS5X1VQq/yeqpo89Weg+3muPyvdfJWlVhbrC11X2z+ftwJ6pWgWMCjYR4cMbGtGRbGIUgGagqpSAA47EIAVLAV60SixCLIBIskiwiiQgjEQEgW+gqCGby1kWWUla0Z0zxCGfNAmgKEmhaVUpKpSkoSVqqFIUIylGjaVRGviCqSFnIJJREpFkGRYEWCkAgAUzNF4URD5kQkmCBXJggALCTbJ69Vbl3EKVvEQ3yBYGD2LxfuWdGUxEqMWXU0Et4WM21r3q6nd2mi/rP+k4GpDjBE9X4vEjP3EOP6vJYfi6xNMy01Scen+e9m6uPK+GR61XUbDnWMzY8i8/fixr+71m4pHaHmIQMIxwzHaABE0cIo3WRPcwUhRFtuLc9KtXJu+QHIaN1i2qbY5a4AbSHaa3R31PIYf1rSmaK+XQzk5ZsAo6J5pBiBFCsWd70IieYoweBV+eni0ElE+VJIZMljZeSK++dTN+iH4aAQOdsPKsLE7UyXBumjmxaixWWHNjU+AvZzKm0vcetYOKhGzRSMZsiWlcwZggbiBB4c5IhcbMazVKVIUpSlKUpRo9fpZYGZshrLfhmymZmZERERERERERGu+2aurq6utVqa/J+5GoavHtBFqD8IwRBK0Ccn9VIhchCOi+2pGr/mDQAAAAAAAAAAAAACAAAAAACUpQlKSYf4u5IpwoSEL6kJ2QlpoOTFBWSZTWVbXm+cAAAnBAMAAAIAACCAAIKU0GY1GwTxdyRThQkFbXm+c | base64 --decode > $AVRCPPATCH
	sudo mv /System/Library/CoreServices/AVRCPAgent.app/Contents/MacOS/AVRCPAgent /System/Library/CoreServices/AVRCPAgent.app/Contents/MacOS/AVRCPAgent-bk
	sudo bspatch /System/Library/CoreServices/AVRCPAgent.app/Contents/MacOS/AVRCPAgent-bk /System/Library/CoreServices/AVRCPAgent.app/Contents/MacOS/AVRCPAgent $AVRCPPATCH
	sudo chmod +x /System/Library/CoreServices/AVRCPAgent.app/Contents/MacOS/AVRCPAgent
fi



# Fix connecting to Windows 10 Shared Folders from Mac OS X 10.8 and 10.9

if [[ $(sw_vers -productVersion) =~ ^10\.(8|9) ]]; then
	sudo sh -c "echo '[default]' >> /etc/nsmb.conf; echo 'signing_required=yes' >> /etc/nsmb.conf"
fi



# Modify default Dock

sudo bash -c 'echo "<?xml version=1.0 encoding=UTF-8?><!DOCTYPE plist PUBLIC -//Apple//DTD PLIST 1.0//EN http://www.apple.com/DTDs/PropertyList-1.0.dtd><plist version=1.0><dict><key>persistent-apps</key><array/><key>persistent-others</key><array><dict><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>displayas</key><integer>1</integer><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/</string><key>_CFURLStringType</key><integer>15</integer></dict><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict><dict><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>displayas</key><integer>1</integer><key>home directory relative</key><string>~/Documents</string><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict><dict><key>tile-data</key><dict><key>arrangement</key><integer>2</integer><key>displayas</key><integer>2</integer><key>home directory relative</key><string>~/Downloads</string><key>showas</key><integer>1</integer></dict><key>tile-type</key><string>directory-tile</string></dict></array><key>version</key><integer>1</integer></dict></plist>" | tee $(ls /System/Library/CoreServices/Dock.app/Contents/Resources/*.lproj/default.plist)'

defaults delete com.apple.dock



# Neutralize LaunchPad

echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>launchpad</key><dict><key>ignore</key><dict><key>rules</key><array><dict><key>bundleid</key><string>.</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>a</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>b</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>c</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>d</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>e</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>f</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>g</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>h</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>i</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>j</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>k</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>l</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>m</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>n</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>o</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>p</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>q</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>r</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>s</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>t</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>u</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>v</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>w</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>x</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>y</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>z</string><key>type</key><string>contains</string></dict></array></dict></dict></dict></plist>' | sudo tee /System/Library/CoreServices/Dock.app/Contents/Resources/LaunchPadLayout.plist

defaults write com.apple.dock ResetLaunchPad -bool true



# Disable Launchpad gesture

defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.dock showLaunchpadGestureEnabled -int 0



# Show Dashboard as an overlay

defaults write com.apple.dock dashboard-in-overlay -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.dock dashboard-in-overlay -bool true



# Fix permissions in User Template folder

sudo chown -R root:wheel /System/Library/User\ Template/
sudo chmod 700 /System/Library/User\ Template/



killall Dock Finder rcd
clear
printf "\n\n\nAll done! Restarting your computer is recommended.\n"
