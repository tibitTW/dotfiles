if test -f ~/.secrets/api_keys.json
    for pair in (jq -r 'to_entries[] | "\(.key)=\(.value)"' ~/.secrets/api_keys.json)
        set -gx (string split '=' $pair)[1] (string split '=' $pair)[2]
    end
end
