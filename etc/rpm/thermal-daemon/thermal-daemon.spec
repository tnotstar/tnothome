#
# Copyright (c) 2014 Antonio Alvarado Hernández.
#



%global pkgname thermal_daemon


Name:              thermal-daemon
Version:           1.3.rc1
Release:           1%{?dist}
Summary:           The "Linux Thermal Daemon" program from 01.org
License:           GPLv2+
Group:             System Environment/Daemons
URL:               https://github.com/01org/%{pkgname}
Source0:           https://github.com/01org/%{pkgname}/archive/v%{version}.tar.gz

BuildRequires:     autoconf, automake, gcc-c++
BuildRequires:     glib-devel, dbus-glib-devel, libxml2-devel
BuildRequires:     systemd

Requires(post):    systemd-units
Requires(preun):   systemd-units
Requires(postun):  systemd-units

%description
Thermal Daemon monitors and controls platform temperature.

Provides a Linux user mode daemon to system developers, reducing time to
market with controlled thermal management using P-states, T-states, and
the Intel power clamp driver. The Thermal Daemon uses the existing Linux
kernel infrastructure and can be easily enhanced.


%prep
%setup -qn %{pkgname}-%{version}


%build
autoreconf --verbose --install --force
%configure
make %{?_smp_mflags}


%install
[ "$RPM_BUILD_ROOT" != "/" ] && %__rm -rf "$RPM_BUILD_ROOT"
%make_install


%post
%systemd_post thermald.service


%preun
%systemd_preun thermald.service


%postun
%systemd_postun_with_restart thermald.service


%files
%doc README.txt COPYING
%{_sbindir}/thermald
%{_unitdir}/thermald.service
%{_datadir}/dbus-1/system-services/org.freedesktop.thermald.service
%{_mandir}/man5/thermal-conf.xml.5.gz
%{_mandir}/man8/thermald.8.gz
%config(noreplace) %{_sysconfdir}/dbus-1/system.d/org.freedesktop.thermald.conf
%config(noreplace) %{_sysconfdir}/thermald/thermal-conf.xml
%config(noreplace) %{_sysconfdir}/thermald/thermal-cpu-cdev-order.xml
%exclude %{_sysconfdir}/init/thermald.conf


%changelog
* Thu Jul 24 2014 Antonio Alvarado H. <tnotstar@gmail.com> 1.3.rc1
- rewritten version adapted from upstreamer
* Tue Oct 01 2013 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> 1.03-1
- Upgraded to thermal daemon 1.03
* Mon Jun 24 2013 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> 1.02-5
- Replaced underscore with dash in the package name
* Thu Jun 20 2013 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> 1.02-4
- Resolved prefix and RPM_BUILD_ROOT as per review comments
* Wed Jun 19 2013 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> 1.02-3
- Removed libxml2 requirement and uses shortcommit in the Source0
* Tue Jun 18 2013 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> 1.02-2
- Update spec file after first review
* Fri Jun 14 2013 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> 1.02-1
- Initial package

# EOF
