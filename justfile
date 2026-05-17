build:
    scripts/build.sh

clean:
    rm -f docs/hello.js docs/hello.wasm

root := justfile_directory()

build-in-docker: clean
    docker run --rm -u "$(id -u):$(id -g)" -v "{{ root }}":/workspace -w /workspace emscripten/emsdk scripts/build.sh

release_version := "0.0.1"
release_title := "Release " + release_version + ""
release_notes := "test release"

release:
    gh release create {{ release_version }} \
    --title "{{ release_title }}" \
    --notes "{{ release_notes }}" \
    --latest
