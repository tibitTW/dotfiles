# dotfiles

## Setup Steps

1. install stow
2. clone this repository to $HOME
3. goto dotfiles/
4. enter this command:

    ```sh
    stow .
    ```

    - if there's conflict during this steps:

        ```
        WARNING! stowing bar would cause conflicts:
          * existing target is neither a link nor a directory: foo
        All operations aborted.
        ```

        do the following command:

        ```sh
        stow --adopt *
        git restore .
        ```

5. decrypt api json

    預期的 `.secrets/api_keys.json` 內容：

    ```json
    // .secrets/api_keys.json
    {
        "OPENAI_API_KEY": "......",
        "OPENROUTER_API_KEY": "......",
        "DEEPSEEK_API_KEY": "......"
        // add other api keys here
    }
    ```

    Just create a `api_keys.json` file and follow the format. I uses gpg to store encrypted api keys. To restore:

    ```sh
    # in .secrets/ directory
    gpg -o api_keys.json -d api_keys.json.gpg
    ```
