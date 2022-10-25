# # No arguments: `docker-compose ps`
# # With arguments: acts like `docker-compose`

dc() {
  if [[ $# > 0 ]]; then
    docker-compose $@
  else
    docker-compose ps
  fi
}
