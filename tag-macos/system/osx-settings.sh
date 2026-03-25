#!/usr/bin/env sh
# vim: tw=0

# Useful tips from: https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# https://pawelgrzybek.com/change-macos-user-preferences-via-command-line/

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Settings" to quit' 2>/dev/null

# Ask for the administrator password upfront (skip if non-interactive)
if [ -t 0 ]; then
  sudo -v
  # Keep-alive: update existing `sudo` time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
fi

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable font smoothing for external displays
defaults -currentHost write -globalDomain AppleFontSmoothing -int 0

# Disable the sound effects on boot
sudo -n nvram SystemAudioVolume=" " 2>/dev/null || true

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Trackpad: tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Enable full keyboard access for all controls (e.g. Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Set a faster keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Show remaining battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# When saving a document, show full Finder to choose where to save it
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Enable spring-loaded Dock items
defaults write enable-spring-load-actions-on-all-items -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Swap left and right mouse buttons
defaults -currentHost write .GlobalPreferences com.apple.mouse.swapLeftRightButton -bool true

# Reduce wallpaper tinting in windows
defaults write -g AppleReduceDesktopTinting -bool true

###############################################################################
# Screenshots                                                                  #
###############################################################################

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Save screenshots to ~/Pictures/screenshots
defaults write com.apple.screencapture location ~/Pictures/screenshots

# Screenshot format
defaults write com.apple.screencapture type -string "png"

###############################################################################
# Keyboard shortcuts                                                           #
###############################################################################

# Use F1 to change keyboard layout
defaults write "com.apple.symbolichotkeys" "AppleSymbolicHotKeys" -dict-add 61 "{ enabled = 1; value = { parameters = (65535, 122, 8388608); type = 'standard'; }; }"
defaults write "com.apple.symbolichotkeys" "AppleSymbolicHotKeys" -dict-add 60 "{ enabled = 0; value = { parameters = (32, 49, 262144); type = 'standard'; }; }"

# Use Cmd + Shift + 4 to copy screenshot to clipboard
defaults write "com.apple.symbolichotkeys" "AppleSymbolicHotKeys" -dict-add 31 "{ enabled = 1; value = { parameters = (52, 21, 1179648); type = 'standard'; }; }"

# Use Cmd + Shift + Ctrl + 4 to save screenshot to file
defaults write "com.apple.symbolichotkeys" "AppleSymbolicHotKeys" -dict-add 30 "{ enabled = 1; value = { parameters = (52, 21, 1441792); type = 'standard'; }; }"

###############################################################################
# Dock                                                                         #
###############################################################################

# Automatically hide
defaults write com.apple.dock autohide -int 1

# Hide recent apps from Dock
defaults write com.apple.dock show-recents -bool false

# Minimize windows into their application icon
defaults write com.apple.dock minimize-to-application -bool true

# Remove delay when moving mouse to the bottom
defaults write com.apple.dock autohide-delay -int 0

# Use a small animation time for the Dock to appear
defaults write com.apple.dock autohide-time-modifier -float 0.4

###############################################################################
# Finder                                                                       #
###############################################################################

# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set home directory as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use current directory as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show Path bar at bottom of Finder window
defaults write com.apple.finder ShowPathbar -bool true

# Show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Use column view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Don't show drives on Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show item info below desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true

# Enable snap-to-grid for desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true

# Show the ~/Library folder
chflags nohidden ~/Library
xattr -d com.apple.FinderInfo ~/Library 2>/dev/null || true

###############################################################################
# Safari                                                                       #
###############################################################################

defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2 2>/dev/null || true
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false 2>/dev/null || true

###############################################################################
# Kill affected applications                                                   #
###############################################################################

for app in Safari Finder Dock Mail SystemUIServer; do
  killall "$app" >/dev/null 2>&1;
done
