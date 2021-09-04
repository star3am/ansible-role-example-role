#!/bin/bash
echo "Set Environment Variables"
export PIP_DISABLE_PIP_VERSION_CHECK=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
echo "Create Python Virtual Environment"
python3 -m venv ansible-venv
source ansible-venv/bin/activate
echo "Check Python and Pip Versions"
python -V
pip -V
echo "Install Python Pip Packages"
pip install ansible --quiet
pip install ansible-lint --quiet
pip install wheel --quiet
pip install pywinrm --quiet
pip install requests --quiet
pip install docker --quiet
pip install molecule --quiet
pip install junit_xml --quiet
# latest version has network bug https://github.com/ansible-community/molecule-vagrant/pull/105/files
pip install molecule-vagrant==0.6.1 --quiet
pip install python-vagrant --quiet
pip install pypsrp --quiet
pip install hvac --quiet
echo "Running Ansible Lint"
ansible-lint -v || true
echo "Running Ansible Molecule"
#molecule destroy
#molecule create
#molecule converge -- -v --list-tags
molecule converge -- -v
#molecule destroy
#molecule test
