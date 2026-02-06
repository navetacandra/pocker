# Pocker - Non-Root Container Manager

**Pocker** is a lightweight, Bash-based container manager designed to run Linux distributions in a rootless environment. By leveraging `PRoot`, it allows users to pull Docker-compatible images and run them without requiring `sudo` or kernel-level container support (like namespaces).

---

## Features

* **Rootless:** No `sudo` or root privileges required.
* **Docker Compatible:** Pulls and extracts standard OCI/Docker images.
* **Persistent Containers:** Create named container instances from images.
* **Clean Isolation:** Uses `PRoot` to guest-bind `/dev`, `/proc`, and `/sys`.
* **Simplified CLI:** Easy commands for pulling, creating, and logging into containers.

---

## Prerequisites

Before running Pocker, ensure the following dependencies are installed on your host system:

* `git`, `curl`, `jq` (For registry API interaction)
* `proot` (The core engine for rootless execution)
* `tar`, `xz` (For extracting image layers)

---

## Installation

Choose the instruction set corresponding to your platform:

### A. Debian / Ubuntu

Open your terminal and run the following commands:

```bash
# 1. Update and Install Dependencies
sudo apt update && sudo apt install git curl jq proot tar xz-utils -y

# 2. Clone the Repository
git clone git@github.com:navetacandra/pocker.git
cd pocker

# 3. Set Executable Permissions
chmod +x pocker image_pull
```

### B. Termux (Android)

Ensure your packages are up to date and install the requirements:

```bash
# 1. Update and Install Dependencies
pkg update && pkg install git curl jq proot tar xz-utils -y

# 2. Clone the Repository
git clone git@github.com:navetacandra/pocker.git
cd pocker

# 3. Set Executable Permissions
chmod +x pocker image_pull
```

---

## Usage Guide

### 1. Pull an Image

Download an image from a registry (defaults to Docker Hub).

```bash
./pocker pull debian:latest
```

### 2. Create a Container

Initialize a specific instance (rootfs) from a pulled image.

```bash
./pocker create debian:latest my-container
```

### 3. Login to Container

Enter the container shell. Pocker will automatically detect `bash`, `ash`, or `sh`.

```bash
./pocker login my-container
```

### 4. Management Commands

| Command | Description |
| --- | --- |
| `ls image` | List all downloaded images in cache. |
| `ls container` | List all created container instances. |
| `delete <image>` | Remove an image from the cache. |
| `delete-container <name>` | Wipe a container instance's rootfs. |

---

## Directory Structure

* `.cache/`: Stores the compressed image layers and manifests.
* `.rootfs/`: Contains the extracted filesystems for your named containers.

---

## Important Notes

* **Networking:** Since this is rootless via PRoot, the container shares the host's network stack.
* **Performance:** PRoot uses `ptrace`, which introduces some overhead compared to native Docker.
* **DNS:** Pocker automatically injects `1.1.1.1` into `/etc/resolv.conf` to ensure internet connectivity within the guest.
