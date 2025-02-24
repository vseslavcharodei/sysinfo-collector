# System Information Collector

## Overview

`sysinfo-collector` is a Bash script that collects various system information such as RAM usage, CPU load, running processes, disk space, uptime, and more. It provides an interactive interface using `gum` for user-friendly selection and formatted output.

## Data That Can Be Collected

The script allows users to collect the following system information:
- RAM Usage
- CPU Usage
- Running Processes
- CPU Model
- Free Disk Space
- Block Devices List
- System Uptime
- Kernel Version
- Network Devices
- Default Routing Table

## Required Programs

The script relies on the following programs to collect data:
- `bash` (execution shell to run script logic)
- `gum` (for interactive UI)
- `free` (for RAM usage)
- `mpstat` (for CPU usage)
- `ps` (for running processes)
- `lscpu` (for CPU model)
- `df` (for disk space)
- `lsblk` (for block devices)
- `uptime` (for system uptime)
- `uname` (for kernel version)
- `ip` (for network devices and routing table)

Ensure these programs are installed on your system before running the script.

## Installation

### Running the Script Without Building

If you want to run the script directly without building a package, simply copy it from `src/` and execute it in a shell:

```bash
cp src/sysinfo-collector /usr/local/bin/sysinfo-collector
chmod +x /usr/local/bin/sysinfo-collector
sysinfo-collector
```

### Building RPM and DEB Packages

To build an RPM package:

```bash
rpmbuild -bb rpm/sysinfo-collector.spec
```

To build a DEB package:

```bash
dpkg-buildpackage -us -uc
```

### Installing packages

Package relies on https://github.com/charmbracelet/gum.
Follow repository page to install it for your distribution.

To install an RPM package:

```bash
sudo yum install ./sysinfo-collector-1.0-1.noarch.rpm
```

To install a DEB package:

```bash
sudo apt install ./sysinfo-collector_1.0-1_all.deb
```

## Usage

Run the script by executing:

```bash
sysinfo-collector
```

Then, select the system information you wish to collect. The output will be displayed on the screen, and you will be prompted to save it to a file if needed.

## Output Files

By default, saved output files will have the format:

```
$HOME/sysinfo-collector-hostname-YYYY-MM-DD_HH-MM-SS.out
```

## Uninstallation

For RPM-based systems:

```bash
sudo yum remove sysinfo-collector
```

For DEB-based systems:

```bash
sudo apt remove sysinfo-collector
```

## License

This project is licensed under the MIT License.
