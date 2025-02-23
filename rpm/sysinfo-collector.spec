Name: sysinfo-collector
Version: 1.0
Release: 1%{?dist}
Summary: System Information Collector
License: MIT
URL: https://github.com/vseslavcharodei/sysinfo-collector
Source0: %{name}-%{version}.tar.gz

BuildArch: noarch
Requires: gum, bash

%description
sysinfo-collector is a Bash script that collects various system information such as RAM usage, CPU load, running processes, disk space, uptime, and more. It provides an interactive interface using `gum` for user-friendly selection and formatted output.

%prep
%setup -q

%build

%install
install -D -m 0755 sysinfo-collector.sh %{buildroot}/usr/local/bin/sysinfo-collector

%files
/usr/local/bin/sysinfo-collector

%changelog
* Sat Feb 23 2025 Oleksii Derkach <alexeii.derkach@hotmail.com> - 1.0-1
- Initial RPM package
