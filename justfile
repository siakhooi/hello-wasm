build:
    scripts/build.sh

test:
    scripts/test.sh

# for lcov/genhtml
install-lcov:
	apt install lcov
coverage:
    scripts/coverage.sh

clean:
    rm -f docs/hello.js docs/hello.wasm tests/test_runner
    rm -rf coverage

root := justfile_directory()

coverage-in-docker:
    docker run --rm -u "$(id -u):$(id -g)" -v "{{ root }}":/workspace -w /workspace emscripten/emsdk scripts/coverage.sh
test-in-docker:
    docker run --rm -u "$(id -u):$(id -g)" -v "{{ root }}":/workspace -w /workspace emscripten/emsdk scripts/test.sh

build-in-docker: clean
    docker run --rm -u "$(id -u):$(id -g)" -v "{{ root }}":/workspace -w /workspace emscripten/emsdk scripts/build.sh

release_version := "0.0.2"
release_title := "Release " + release_version + ""
release_notes := "add function call"

release:
    gh release create {{ release_version }} \
    --title "{{ release_title }}" \
    --notes "{{ release_notes }}" \
    --latest

serve:
    python3 -m http.server --directory docs

download-unity:
    mkdir -p third_party/unity
    curl -fsSL -o third_party/unity/unity.c \
    https://raw.githubusercontent.com/ThrowTheSwitch/Unity/master/src/unity.c
    curl -fsSL -o third_party/unity/unity.h \
    https://raw.githubusercontent.com/ThrowTheSwitch/Unity/master/src/unity.h
    curl -fsSL -o third_party/unity/unity_internals.h \
    https://raw.githubusercontent.com/ThrowTheSwitch/Unity/master/src/unity_internals.h
