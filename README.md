# 🔐 ZFS Key Loader Script

A simple Bash script to **load ZFS encryption keys** and **mount ZFS datasets** using a single passphrase. Useful for systems with encrypted ZFS volumes that need to be unlocked at boot or on demand.

---

## 📄 Script Overview

**Filename:** `zfs.sh`  
**Purpose:** Load ZFS encryption keys for one or more datasets and mount them  
**Requirements:** `sudo` access and `zfs` command-line tools  
**Usage:**  
```bash
sudo ./zfs.sh [dataset1 dataset2 ...]
```

If no datasets are provided as arguments, the script defaults to those defined in the `ZFS_DATASETS` variable.

---

## ⚙️ Configuration

Edit the script to define your default ZFS datasets:
```bash
ZFS_DATASETS="zfs_hdd_pool_01"
```
You can override this by passing dataset names as command-line arguments.

---

## 🛠 Features

- Prompts securely for the ZFS passphrase (no echo)
- Loads the encryption key for each specified dataset
- Mounts the dataset after successful key load
- Exits immediately on failure for security and clarity
- Supports multiple datasets in one invocation
- Colorful and user-friendly emoji output

---

## 🧪 Example

```bash
sudo ./zfs.sh tank/encrypted1 tank/encrypted2
```

**Output:**
```
🔒 Enter passphrase for ZFS encryption keys:
🔑 Loading ZFS encryption key for dataset: tank/encrypted1
✅ ZFS key for tank/encrypted1 loaded successfully.
🌐 Mounting ZFS dataset: tank/encrypted1
✅ Dataset tank/encrypted1 mounted successfully.
...
🎉 Script completed successfully.
```

---

## 🔍 Script Breakdown

| Section             | Purpose                                          |
|---------------------|--------------------------------------------------|
| Configuration       | Define default datasets                         |
| Usage Function      | Prints usage help                                |
| Command Checks      | Ensures `zfs` is available                       |
| Passphrase Prompt   | Asks for key input securely                      |
| Key Loader          | Calls `zfs load-key` with the passphrase         |
| Dataset Mounter     | Mounts each dataset via `zfs mount`              |
| Main Execution      | Validates input, loops through each dataset      |

---

## ⚠️ Requirements

- Root privileges (`sudo`)
- ZFS installed and available in the system path

Install ZFS if missing (Ubuntu/Debian):
```bash
sudo apt install zfsutils-linux
```

---

## 🔐 Security Note

The script stores the passphrase **only in memory** during execution and clears it immediately after use. However, always audit scripts handling sensitive information before deployment.

---

## 📦 License

MIT License. See [LICENSE](LICENSE) file for details.
