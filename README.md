# Ansible Role CA UIM Agent

This Role will install the CA UIM Agent on Oracle Linux / RedHat Distributions. 

## Information
- https://molecule.readthedocs.io/en/latest/getting-started.html
- https://www.ansible.com/hubfs//AnsibleFest%20ATL%20Slide%20Decks/Practical%20Ansible%20Testing%20with%20Molecule.pdf
- https://www.jeffgeerling.com/blog/2018/testing-your-ansible-roles-molecule 

## Dependencies
- Docker 
- Python3
- Pip
- Ansible
- Ansible-lint
- Molecule
- Molecule-Vagrant

## Instructions 

`ansible-playbook tasks/main.yml -vvv`

## Molecule 

`./run.sh` <br />
`ansible-lint tasks/main.yml` <br />
`molecule test` <br />
