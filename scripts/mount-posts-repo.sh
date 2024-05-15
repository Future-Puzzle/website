#!/bin/bash

# Mount authors
rm -r src/content/authors
mv posts-repo/authors src/content/authors
rm src/content/authors/*.md
ls -la src/content/authors

# Mount avatars
rm -r src/assets/avatars
mv posts-repo/avatars src/assets/avatars
rm src/assets/avatars/*.md
ls -la src/assets/avatars

# Mount images
rm -r src/assets/images
mv posts-repo/images src/assets/images
rm src/assets/images/*.md
ls -la src/assets/images

# Mount posts
rm -r src/content/posts/*
for FOLDER_DIR in posts-repo/posts/*; do
  if [[ -d "$FOLDER_DIR" ]]; then
    # Get folder name
    FOLDER_NAME=${FOLDER_DIR##*/}

    # Get folder name SHA256
    HASH_NAME=$(echo -n $FOLDER_NAME | sha256sum | awk '{print $1}')

    # Move markdown to contents collection
    mv $FOLDER_DIR"/post.md" "src/content/posts/"$HASH_NAME".md"

    # Move rest folder to contents collection with ignore
    mv $FOLDER_DIR "src/content/posts/_"$HASH_NAME

    # Replace relative path
    sed -i "s/\.\//\.\/_"$HASH_NAME"\//g" "src/contents/posts/"$HASH_NAME".md"
  fi
done
ls -la src/content/posts