# Uptick Bootstrap Repository

## :hugs: Welcome to Uptick!

<p align="center">
<img src="./uptick_logo.png">
</p>

## :airplane: Preflight Checklist

Before we begin make sure the following has happened:

- [ ] You have a github account and the account is added as a user within the Uptick organisation and the web developer group.

## :boot: Bootstrapping your developer environment

Run the following command in your terminal

```bash
curl https://raw.githubusercontent.com/uptick/bootstrap-public/main/install.sh  -o /tmp/install.sh  && zsh /tmp/install.sh
```

This script will automate the following:

1. Install ansible
2. Install xcode
3. Set up a ssh key
4. Upload it to github
5. Check out our private bootstrap repository https://github.com/uptick/bootstrap and run the playbook within that repository
