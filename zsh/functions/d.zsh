# # No arguments: `docker ps`
# # With arguments: acts like `docker`
# unalias d

d() {
  if [[ $# > 0 ]]; then
    docker $@
  else
    docker ps
  fi
}

# Complete d like docker
# compdef d=docker
