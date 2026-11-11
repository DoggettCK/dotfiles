# cppnew <name> [std]: scaffold a CMake C++ project (like `cargo new`).
# std defaults to 20, e.g. `cppnew foo 23`.
cppnew() {
  local name=$1 std=${2:-20}
  if [[ -z $name ]]; then
    print -u2 "usage: cppnew <name> [std]"
    return 1
  fi
  if [[ -e $name ]]; then
    print -u2 "cppnew: '$name' already exists"
    return 1
  fi

  mkdir -p "$name/src" || return 1
  cd "$name" || return 1

  cat > CMakeLists.txt <<EOF
cmake_minimum_required(VERSION 3.20)
project($name LANGUAGES CXX)

set(CMAKE_CXX_STANDARD $std)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # compile_commands.json for clangd

add_executable($name src/main.cpp)
target_compile_options($name PRIVATE -Wall -Wextra -Wpedantic)
EOF

  cat > src/main.cpp <<'EOF'
#include <iostream>

int main() {
  std::cout << "Hello, world!\n";
  return 0;
}
EOF

  cat > .clang-format <<'EOF'
BasedOnStyle: LLVM
IndentWidth: 4
EOF

  # Point clangd at the CMake build dir's compile_commands.json
  cat > .clangd <<'EOF'
CompileFlags:
  CompilationDatabase: build
EOF

  printf 'build/\n.cache/\n' > .gitignore

  git init -q
  print "Created C++ project '$name' (C++$std)."
  print "Build: cmake -B build && cmake --build build && ./build/$name"
}
