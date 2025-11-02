# LibreSlicer — Linux Source Build & Packaging

The v1.0 supporter drop only publishes source instructions for Linux. These
steps were validated on Ubuntu 22.04 and Fedora 39. Adjust the package manager
syntax for other distributions.

## 1. Install Dependencies

### Ubuntu 22.04

```bash
sudo apt update
sudo apt install -y git build-essential ninja-build cmake \
  libboost-all-dev libeigen3-dev libtbb-dev libopenvdb-dev \
  libglew-dev libwxgtk3.0-gtk3-dev libdbus-1-dev libssl-dev \
  libcurl4-openssl-dev libxmu-dev libxi-dev
```

### Fedora 39

```bash
sudo dnf install -y git gcc-c++ ninja-build cmake \
  boost-devel eigen3-devel tbb-devel openvdb-devel \
  glew-devel wxBase3 wxGTK3-devel dbus-devel openssl-devel \
  libcurl-devel libXmu-devel libXi-devel
```

## 2. Configure & Build

```bash
git clone https://github.com/MythicReliquary/LibreSlicer.git
cd LibreSlicer
cmake -S . -B build/linux-release -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_SLA=ON \
  -DUSE_OPENVDB=ON
cmake --build build/linux-release --parallel
```

The resulting binaries live in `build/linux-release`. Launch the GUI with
`./build/linux-release/src/LibreSlicer`.

## 3. Run Smoke Tests

1. Start LibreSlicer and confirm the splash screen reports **Supporter Build v1.0**.
2. Import the `tests/models/rook/rook.3mf` project and slice it.
3. Export G-code and verify no errors appear in the status panel.

## 4. Package the Source Archive

Use the helper script to produce the AGPL-compliant source archive and checksum:

```bash
./scripts/package_linux_source.sh dist v1.0-supporter
```

This generates `dist/libreslicer-v1.0-supporter-src.zip` and its `.sha256`
manifest. The script validates that `LICENSE`, `THIRD_PARTY_NOTICES.txt`,
`CREDITS.md`, and `COMPLIANCE/SOURCE_OFFER.md` are embedded.

## 5. Verify the Archive

```bash
unzip -l dist/libreslicer-v1.0-supporter-src.zip | grep -E "(LICENSE|THIRD_PARTY_NOTICES|CREDITS|SOURCE_OFFER)"
sha256sum --check dist/libreslicer-v1.0-supporter-src.zip.sha256
```

The checksum reported here must match the value recorded in
`COMPLIANCE/SOURCE_OFFER.md`.
