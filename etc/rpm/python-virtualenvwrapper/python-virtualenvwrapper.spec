#
# Copyright (c) 2014 Antonio Alvarado Hernández.
#



%global pkgname virtualenvwrapper

Name:              python-virtualenvwrapper
Version:           4.3.1
Release:           1%{?dist}
Summary:           A set of extensions to Ian Bicking’s virtualenv tool
License:           MIT
Group:             Development/Languages
URL:               http://virtualenvwrapper.readthedocs.org
Source0:           http://pypi.python.org/packages/source/v/%{pkgname}/%{pkgname}-%{version}.tar.gz

BuildArch:         noarch
BuildRequires:     python-devel
BuildRequires:     python-setuptools
BuildRequires:     python-virtualenv
BuildRequires:     python-pbr

Requires:          python-virtualenv

%description
virtualenvwrapper is a set of extensions to Ian Bicking's virtualenv tool.
The extensions include wrappers for creating and deleting virtual
environments and otherwise managing your development workflow, making it
easier to work on more than one project at a time without introducing
conflicts in their dependencies.


%prep
%setup -qn %{pkgname}-%{version}


%build
%{__python} setup.py build


%install
[ "$RPM_BUILD_ROOT" != "/" ] && %__rm -rf "$RPM_BUILD_ROOT"
%{__python} setup.py install -O1 \
    --skip-build --root %{buildroot} \
    --record=%{name}-%{version}.filelist

# remove this uggly message "warning: File listed twice"
sed -i "/\.egg-info$/d" %{name}-%{version}.filelist

# link the environment configuration script
%{__mkdir_p} %{buildroot}/%{_sysconfdir}/profile.d/
%{__ln_s} %{_bindir}/virtualenvwrapper_lazy.sh \
    %{buildroot}/%{_sysconfdir}/profile.d/virtualenvwrapper.sh


%files -f %{name}-%{version}.filelist
%doc README.txt README.es.rst README.ja.rst LICENSE AUTHORS
%doc ChangeLog docs
%{_sysconfdir}/profile.d/virtualenvwrapper.sh


%changelog
* Mon Jul 29 2014 Antonio Alvarado H. <tnotstar@gmail.com> 4.3.1-1.el7.centos
- initial version

# EOF
