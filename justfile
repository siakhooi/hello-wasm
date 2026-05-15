build:
    scripts/build.sh

clean:
    rm -f docs/hello.js docs/hello.wasm

root := justfile_directory()

build-in-docker: clean
    docker run --rm -u "$(id -u):$(id -g)" -v "{{ root }}":/workspace -w /workspace emscripten/emsdk scripts/build.sh
