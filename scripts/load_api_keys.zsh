if [[ -f ~/.secrets/api_keys.json ]]; then
  for pair in $(jq -r 'to_entries[] | "\(.key)=\(.value)"' ~/.secrets/api_keys.json); do
    key="${pair%%=*}"
    value="${pair#*=}"
    export "$key=$value"
  done
fi
