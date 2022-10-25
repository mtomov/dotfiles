# Make directory and change into it.

function curl_stat() {
  curl -s -w %{time_total}\\n -o /dev/null "$1"
}
