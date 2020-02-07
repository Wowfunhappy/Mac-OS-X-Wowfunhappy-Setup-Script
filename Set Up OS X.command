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
	echo "1) Boot into recovery mode"
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



# Attempt to use the below Spotlight preferences on 10.10+. Only sometimes works.

if (( $(echo "${OSTYPE:6} > 13" | bc -l) ))
then
	defaults write com.apple.spotlight orderedItems '({"enabled" = 1;"name" = "APPLICATIONS";},{"enabled" = 1;"name" = "PDF";},{"enabled" = 0;"name" = "MESSAGES";},{"enabled" = 1;"name" = "CONTACT";},{"enabled" = 0;"name" = "EVENT_TODO";},{"enabled" = 1;"name" = "IMAGES";},{"enabled" = 0;"name" = "BOOKMARKS";},{"enabled" = 1;"name" = "MUSIC";},{"enabled" = 1;"name" = "MOVIES";},{"enabled" = 0;"name" = "FONTS";},{"enabled" = 1;"name" = "MENU_OTHER";})'
	sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.spotlight orderedItems '({"enabled" = 1;"name" = "APPLICATIONS";},{"enabled" = 1;"name" = "PDF";},{"enabled" = 0;"name" = "MESSAGES";},{"enabled" = 1;"name" = "CONTACT";},{"enabled" = 0;"name" = "EVENT_TODO";},{"enabled" = 1;"name" = "IMAGES";},{"enabled" = 0;"name" = "BOOKMARKS";},{"enabled" = 1;"name" = "MUSIC";},{"enabled" = 1;"name" = "MOVIES";},{"enabled" = 0;"name" = "FONTS";},{"enabled" = 1;"name" = "MENU_OTHER";})'
fi



# Unhide important directories.

xattr -d com.apple.FinderInfo ~/Library
chflags nohidden ~/Library

sudo mkdir /System/Library/User\ Template/Non_localized/Library/LaunchAgents/
echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>Label</key><string>local.show-library</string><key>ProgramArguments</key><array><string>/bin/bash</string><string>-c</string><string>chflags nohidden ~/Library;xattr -d com.apple.FinderInfo ~/Library</string></array><key>RunAtLoad</key><true/></dict></plist>' | sudo tee /System/Library/User\ Template/Non_localized/Library/LaunchAgents/show-library.plist # User template chflags are ignored, so make LaunchAgent to unhide ~/Library for future users.

sudo chflags nohidden /Library
sudo chflags nohidden /usr



# Disable Automatic Termination

defaults write NSGlobalDomain NSDisableAutomaticTermination -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSDisableAutomaticTermination -bool false



# Make Finder windows open to home directory by default.

defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.finder NewWindowTarget -string "PfLo"



# Show path bar in Finder.

defaults write com.apple.finder ShowPathbar -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.finder ShowPathbar -bool true



# Finder: show all filename extensions

defaults write NSGlobalDomain AppleShowAllExtensions -bool true

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences AppleShowAllExtensions -bool true



# Disable Finder's extension change warning.

defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.finder FXEnableExtensionChangeWarning -bool false



# When performing a search, search the current folder by default.

defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.finder FXDefaultSearchScope -string "SCcf"



# Do not save files to iCloud by default.

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




# In windows and dialogs, make tab move keyboard focus between all controls.

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences AppleKeyboardUIMode -int 3



# Create a keyboard shortcut to toggle full screen.

defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Enter Full Screen" -string "@d"
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Exit Full Screen" -string "@d"

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSUserKeyEquivalents -dict-add "Enter Full Screen" -string "@d"
sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/.GlobalPreferences NSUserKeyEquivalents -dict-add "Exit Full Screen" -string "@d"



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



# Default to plain text in TextEdit.

defaults write com.apple.TextEdit RichText -int 0

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.TextEdit RichText -int 0



# Make email addresses easier to copy from Mail.app.

defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.mail AddressesIncludeNameOnPasteboard -bool false



# Stop websites from prompting to enable push notifications

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



# Only check for updates once per year.

sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 365



# Don't badge System Preferences

defaults write com.apple.systempreferences AttentionPrefBundleIDs 0

sudo defaults write /System/Library/User\ Template/Non_localized/Library/Preferences/com.apple.systempreferences AttentionPrefBundleIDs 0



# Give /Applications/Utilities/ the same permissions as /Applications/

sudo chmod 775 /Applications/Utilities/



# Move Terminal to /Applications/

sudo mv /Applications/Utilities/Terminal.app /Applications/



# Remove nonfunctional dashboard widgets. (Requisite servers down as of December 2019.)

sudo rm -rf /Library/Widgets/Flight Tracker.wdgt
sudo rm -rf /Library/Widgets/Ski Report.wdgt
sudo rm -rf /Library/Widgets/Translation.wdgt
sudo rm -rf /Library/Widgets/Weather.wdgt



# Remove stupid applications.

sudo rm -rf /Applications/Books.app
sudo rm -rf /Applications/Chess.app
sudo rm -rf /Applications/DVD\ Player.app
sudo rm -rf /Applications/Game\ Center.app
sudo rm -rf /Applications/Home.app
sudo rm -rf /Applications/iBooks.app
sudo rm -rf /Applications/iSync.app
sudo rm -rf /Applications/iTunes.app
sudo rm -rf /Applications/Launchpad.app
sudo rm -rf /Applications/News.app
sudo rm -rf /Applications/Photos.app
sudo rm -rf /Applications/Siri.app
sudo rm -rf /Applications/Stickies.app
sudo rm -rf /Applications/Stocks.app
sudo rm -rf /Applications/VoiceMemos.app



# Modify default Dock

sudo bash -c 'echo "<?xml version=1.0 encoding=UTF-8?><!DOCTYPE plist PUBLIC -//Apple//DTD PLIST 1.0//EN http://www.apple.com/DTDs/PropertyList-1.0.dtd><plist version=1.0><dict><key>persistent-apps</key><array/><key>persistent-others</key><array><dict><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>displayas</key><integer>1</integer><key>file-data</key><dict><key>_CFURLString</key><string>file:///Applications/</string><key>_CFURLStringType</key><integer>15</integer></dict><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict><dict><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>displayas</key><integer>1</integer><key>home directory relative</key><string>~/Documents</string><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict><dict><key>tile-data</key><dict><key>arrangement</key><integer>2</integer><key>displayas</key><integer>2</integer><key>home directory relative</key><string>~/Downloads</string><key>showas</key><integer>1</integer></dict><key>tile-type</key><string>directory-tile</string></dict></array><key>version</key><integer>1</integer></dict></plist>" | tee $(ls /System/Library/CoreServices/Dock.app/Contents/Resources/*.lproj/default.plist)'

defaults delete com.apple.dock



# Neutralize LaunchPad

echo '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><dict><key>launchpad</key><dict><key>ignore</key><dict><key>rules</key><array><dict><key>bundleid</key><string>.</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>a</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>e</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>i</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>o</string><key>type</key><string>contains</string></dict><dict><key>name</key><string>u</string><key>type</key><string>contains</string></dict></array></dict></dict></dict></plist>' | sudo tee /System/Library/CoreServices/Dock.app/Contents/Resources/LaunchPadLayout.plist

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



killall Dock Finder
clear
printf "\n\n\nAll done! Restarting your computer is recommended.\n"
