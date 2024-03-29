# Drupal Installation Script

This script automates the process of installing Drupal on a Linux server. It performs tasks such as updating the system, installing necessary packages, setting up the database, and configuring Apache and PHP.

[ ![GitHub Release](https://img.shields.io/github/v/release/InstaZDLL/drupal-install?style=for-the-badge)](https://img.shields.io/github/v/release/InstaZDLL/drupal-install?sort=date&display_name=release&style=for-the-badge
)  ![GitHub License](https://img.shields.io/github/license/InstaZDLL/drupal-install?style=for-the-badge) ![GitHub last commit (by committer)](https://img.shields.io/github/last-commit/InstaZDLL/drupal-install?style=for-the-badge) ![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/InstaZDLL/drupal-install/total?style=for-the-badge&color=%230080ff)



⚠️The script will install drupal in HTTP ⚠️

⚠️ The script only works on Debian 11 and 12 for now⚠️ 

[![Terminal](https://badgen.net/badge/Status/tested/green?icon=terminal)](#)

## How it Works

The script performs the following steps:

1. **System Update**: The script starts by updating the system's package list and upgrading all installed packages.

2. **Apache Installation**: The script installs Apache2 and starts the service.

3. **PHP Installation**: The script adds the necessary repositories and installs PHP-8.3 along with necessary extensions.

4. **MariaDB Installation**: The script installs MariaDB, starts the service, and sets up a new database and user for Drupal.

5. **Drupal Installation**: The script downloads and extracts Drupal in the appropriate directory, sets the correct permissions, and configures Apache to serve the Drupal site.

6. **Final Configuration**: The script makes necessary changes in `php.ini` file, restarts Apache, and displays the database credentials.

## Usage

To use this script, simply run it on your Linux server. The script will handle the rest : ![Recommended](https://img.shields.io/static/v1?label=&message=Recommended&color=%2331BB12)

```bash
wget -O - https://github.com/InstaZDLL/drupal-installer/releases/download/v1.1.1/drupal-install-composer-apache2.sh | sudo bash
```

If you want to use the manual installation without the composer, use this : ![Not Recommended](https://img.shields.io/static/v1?label=&message=Not+Recommended&color=yellow)

```bash
wget -O - https://github.com/InstaZDLL/drupal-install/releases/download/v1.0.1/drupal-install.sh | sudo bash
```

At the end of the script, a file named `db_credentials.txt` will be created in the home directory of the current user. This file contains the database username and a randomly generated password.

## Note

Please handle the `db_credentials.txt` file securely as it contains sensitive information.

## Issues

If you encounter this error message `The trusted_host_patterns parameter is not configured in settings.php` in drupal dashboard follow these steps :

![Issues A](https://raw.githubusercontent.com/InstaZDLL/drupal-installer/main/images/ScreenshotA.png)
![Issues B](https://raw.githubusercontent.com/InstaZDLL/drupal-installer/main/images/ScreenshotB.png)

### Do this :

First, edit the `setting.php`

```bash
sudo vi /var/www/html/drupal/sites/default/settings.php
```

find the line where you see this :

`# $settings['trusted_host_patterns'] = [];`

Uncomment and replace it with :

`$settings['trusted_host_patterns'] = ['^YOUR PUBLIC HOST IP$', '^127\\.0\\.0\\.1\\$', '^localhost$',];`

### Exemple :
`$settings['trusted_host_patterns'] = ['^119\\.151\\.218\\.9$', '^127\\.0\\.0\\.1\\$', '^localhost$',];`

Save the file (if you're using vim use `:wq!`) and the error should be fixed with a `sudo systemctl restart apache2`.

## TODO

- [ ] Supports multiple Linux distributions
- [ ] Upgrade option to update the old Drupal version to the latest one.

## Contributions

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE) file for details.
