# ubuntu-vnc-supervisor
Ubuntu Docker image with VNC and Supervisord.
It is intended to be a base docker image for web application development.

## Build and run

```bash
docker build -t ubuntu-vnc-supervisor .
docker run --name my_ubuntu -d -p 5900:5900 -p 6901:6901 ubuntu-vnc-supervisor
```

## Access

### From VNC client

Enter `yourhost:5900`. The default password is 'vncpassword'.

### From web browser

`http://localhost:6901/?password=vncpassword`

You can change the default password via `VNC_PW` environment variable.

## Adding supervisor conf

`COPY` your supervisord .conf file to `/etc/supervisor/conf.d/`

## Adding site.pem for enforcing HTTPS

Add your `self.pem` to the `cert` folder. It will be used for enforcing HTTPS automaticaly.

## Other environment variables

You can change these default values via `docker run` `-e` option.

```bash
NO_VNC_PORT=6901
NO_VNC_CERT_FILE=self.pem
DESKTOP_BACKGROUND_COLOR=yellow #green, orange 
```
