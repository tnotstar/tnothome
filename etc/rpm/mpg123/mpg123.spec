#
# Copyright (c) 2014 Antonio Alvarado Hernández.
#



Name:           mpg123
Version:        1.20.1
Release:        1%{?dist}
Summary:        Fast console MPEG Audio Player and decoder library
Group:          Applications/Multimedia
License:        LGPLv2+
URL:            http://mpg123.org

Packager:       Antonio Alvarado H. <tnotstar@gmail.com>
Vendor:         Tnotstar's Repository, http://github.com/tnotstar/tnotrepo

#BuildRequires:  libtool-ltdl-devel

BuildRequires:  pkgconfig(alsa)
Requires:       alsa-lib

Source0:        http://sourceforge.net/projects/mpg123/files/mpg123/%{version}/mpg123-%{version}.tar.bz2 

%description
mpg123 is a real time MPEG 1.0/2.0/2.5 audio player/decoder for layers 1,2 and 3
(most commonly MPEG 1.0 layer 3 aka MP3). Among others working with GNU/Linux,
MacOSX, the BSDs, Solaris, AIX, HPUX, SGI Irix, OS/2 and Cygwin or plain MS Windows
(not all more exotic platforms tested regularily, but patches welcome).

It is free software licensed under LGPL 2.1 .


%package devel
Summary:        Header files and development documentation for %{name}.
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

%description devel
This package contains the header files and development documentation for %{name}.
If you like to develop programs using %{name}, you will need to install
%{name}-devel.


%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
%make_install


%files
%doc COPYING AUTHORS README NEWS ChangeLog doc/
%doc %{_mandir}/man1/mpg123.1*
%doc %{_mandir}/man1/out123.1*
%{_bindir}/out123
%{_bindir}/mpg123
%{_bindir}/mpg123-id3dump
%{_bindir}/mpg123-strip
%{_libdir}/libmpg123.so.*

%files devel
%{_includedir}/mpg123.h
%{_libdir}/pkgconfig/libmpg123.pc
%{_libdir}/libmpg123.so
%exclude %{_libdir}/libmpg123.la


%changelog
* Thu Jul 17 2014 Antonio Alvarado H. <tnotstar@gmail.com> 1.20.1-1
- initial vanilla rpm release.

# EOF
