Docker Base
============
Docker Fakeroot provides a lightweight Ubuntu-based Docker image with a non-root user set up to futher use.

## 🔖 Features
- Based on Ubuntu 24.04
- Non-interactive setup with predefined locales and timezone
- Includes essential packages: fakeroot, locales, ssl-cert, sudo, udev, tzdata
- Creates a non-root user with sudo privileges
- Cleans up unnecessary files to keep the image small
