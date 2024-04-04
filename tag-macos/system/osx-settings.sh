#!/usr/bin/env sh
# vim: tw=0

# Useful tips from: https://github.com/mathiasbynens/dotfiles/blob/main/.macos

# See guide at
# https://pawelgrzybek.com/change-macos-user-preferences-via-command-line/

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable font smoothing for external displays
defaults -currentHost write -globalDomain AppleFontSmoothing -int 0

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# System Preferences > Trackpad > Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
# defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
# defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
# defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true


# Set a faster keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15


# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true

# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Finder: show hidden files by default
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show remaining battery percentage (can't show time in recent macOS versions)
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Show all filename extensions in Finder
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Use current directory as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show Path bar at bottom of Finder window
defaults write com.apple.finder ShowPathbar -bool true

# Show Status bar in Finder (N items, N.NN GB available)
defaults write com.apple.finder ShowStatusBar -bool true

# https://www.howtogeek.com/261880/how-to-show-the-expanded-print-and-save-dialogs-in-os-x-by-default/
# When saving a document, show full Finder to choose where to save it
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# https://www.howtogeek.com/261880/how-to-show-the-expanded-print-and-save-dialogs-in-os-x-by-default/
# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Save screenshots to ~/Pictures/screenshots
defaults write com.apple.screencapture location ~/Pictures/screenshots

# https://www.defaults-write.com/enable-spring-loaded-dock-items/
defaults write enable-spring-load-actions-on-all-items -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show item info below desktop icons ("5 items" for folders)
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Make ⌘ + F focus the search input in iTunes
defaults write com.apple.iTunes NSUserKeyEquivalents -dict-add "Target Search Field" "@F"

# Show the ~/Library folder
chflags nohidden ~/Library

# Disable smart quotes and smart dashes as they're annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false


###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
# defaults write com.apple.dock persistent-apps -array

# Add a spacer to the left side of the Dock (where the applications are)
# defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
# defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'


# Show indicator lights under open applications in the Dock
# defaults write com.apple.dock show-process-indicators -bool true

# Make Dock icons of hidden applications translucent
# defaults write com.apple.dock showhidden -bool true

# Set the icon size of Dock items to 36 pixels
# defaults write com.apple.dock tilesize -int 72

# Automatically hide
defaults write com.apple.dock autohide -int 1

# remove delay when moving mouse to the bottom
defaults write com.apple.dock autohide-delay -int 0

# use a small animataion time for the docker to appear
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Swap left and right mouse buttons
defaults -currentHost write .GlobalPreferences com.apple.mouse.swapLeftRightButton -bool true

# Change keyboard shortcuts
# Use F1 to change keyboard layout
defaults write "com.apple.symbolichotkeys" "AppleSymbolicHotKeys" -dict-add 61 "{ enabled = 1; value = { parameters = (65535, 122, 8388608); type = 'standard'; }; }"
defaults write "com.apple.symbolichotkeys" "AppleSymbolicHotKeys" -dict-add 60 "{ enabled = 0; value = { parameters = (32, 49, 262144); type = 'standard'; }; }"

# Use Cmd + Shift + 4 to copy screenshot to clipboard
defaults write "com.apple.symbolichotkeys" "AppleSymbolicHotKeys" -dict-add 31 "{ enabled = 1; value = { parameters = (52, 21, 1179648); type = 'standard'; }; }"

# Use Cmd + Shift + Ctrl + 4 to save screenshot to file
defaults write "com.apple.symbolichotkeys" "AppleSymbolicHotKeys" -dict-add 30 "{ enabled = 1; value = { parameters = (52, 21, 1441792); type = 'standard'; }; }"


###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`, `Nlsv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

#############

# Kill affected applications
for app in Safari Finder Dock Mail SystemUIServer; do
  killall "$app" >/dev/null 2>&1;
done
