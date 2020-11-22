#!/bin/bash

currentFolder="${PWD##*/}"

banner() {
  echo ""
  echo "+------------------------------------------+"
  echo "|                                          |"
  printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
  echo "|                                          |"
  echo "+------------------------------------------+"
  echo ""
}


verify_node() {
    if ! [ -x "$(command -v node)" ];
        then
            echo "Make sure you have Node and NPM installed."
            exit 1
    fi
}

create_project_folders() {
    local folders=('dist' 'src/assets/img' 'src/assets/js' 'src/assets/scss')
    
    mkdir -p $projectName
    
    for i in "${folders[@]}"
    do
        mkdir -p ./$projectName/$i
    done
}

create_project_files() {
    local templateHtmlIndex='<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./assets/scss/main.scss" />
</head>
<body>
    <h1>It works!</h1>
</body>
</html>'

    cd $projectName
    echo "$templateHtmlIndex" > ./src/index.html

    local templateSassStyle=':root {
--blackish: #222;
--whiteish: #e5e5e5;
}

* {
    font-family: "Open Sans", sans-serif;
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background-color: var(--whiteish);
    color: var(--blackish);
}'

    echo "$templateSassStyle" > ./src/assets/scss/main.scss

    cd ..
}

npm_init()
{
    local dependencies=('eslint' 'parcel-bundler' 'sass' 'editorconfig')

    cd $projectName
    npm init --y > "/dev/null" 2>&1
    # sed -i '''s/'$currentFolder'/'$projectName'/g''' package.json
    # mv package.json ./$projectName

    for i in "${dependencies[@]}"
    do
        npm i -D $i > "/dev/null" 2>&1
    done

    cd ..
}

create_editorconfig_file() {
    local template='root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true'

    cd $projectName
    echo "$template" > ./editorconfig
    cd ..
}

eslint_init() {
   cd $projectName
   ./node_modules/.bin/eslint --init
   cd ..
}

banner 'Create JavaScript App'

verify_node

read -p '> Project folder name          (1/6) => ' projectName

echo '> Creating the folders         (2/6)'
create_project_folders

echo '> Creating the files           (3/6)'
create_project_files

echo '> Initiate NPM                 (4/6)'
npm_init

echo '> Creating editorconfig file   (5/6)'
create_editorconfig_file

echo '> Initiate eslint              (6/6)'
echo ''
eslint_init

echo ''
echo '>>  All Done =) <<'
echo ''