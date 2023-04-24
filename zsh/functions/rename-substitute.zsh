# Change file name recursively in current directory
#
#   rename-substitute part_of_file replaced_part

function rename-substitute() {
  autoload -U zmv
  find='(**/)(*)'$1'(*)'
  replace='$1$2'$2'$3'

  zmv -n $find $replace

  if read -q "choice?Press Y/y to continue with name: "; then
      echo "\n\nRenaming.."
      zmv $find $replace
  fi
}
