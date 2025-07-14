# dotfiles

## Setup Steps

1. install stow
2. clone this repository to $HOME
3. goto dotfiles/
4. enter this command:

    ```sh
    stow .
    ```

    * if there's conflict during this steps:

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

5. install gpg
6. decrypt with gpg

    ```sh
    gpg -o api_keys.json -d api_keys.json.gpg
    ```
