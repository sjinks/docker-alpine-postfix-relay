# docker-alpine-postfix-relay

wildwildangel/postfix-relay is a simple Postfix SMTP relay Docker image based on Alpine Linux. It has *no local authentication configured* and is supposed to run in a trusted environment.

# Environment Variables

The entry point requires the following environment variables:
  * `SERVER_HOSTNAME`: the hostname for this container;
  * `SMTP_SERVER`: the address of the SMTP server to use.

The following environment variables are optional:
  * `SMTP_PORT` (defaults to 587): the port of the target SMTP server (used together with `SERVER_HOSTNAME`);
  * `SMTP_USERNAME`: the username to authenticate with. If it is not empty, then it is mandatory to pass one of `SMTP_PASSWORD` or `SMTP_PASSWORD_FILE`;
  * `SMTP_PASSWORD_FILE`: the file containing the password of the authenticating user. The entry point script will read this file and assign its contents to the `SMTP_PASSWORD` variable;
  * `SMTP_PASSWORD`: the password of the authenticating user;
  * `SMTP_NETWORKS` (defaults to `10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16`): the list of networks that are allowed to relay emails via this server; 
  * `DEBUG`: set to `yes` to enable debugging (effectively executes `set -x`).
