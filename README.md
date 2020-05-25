# Learn Signal FX

TODO Link to the blog when it's published

This repository is a companion to this blog post. If you follow along there you should be able to make use of it.

Enable SignalFx monitoring for a Postgresql database.

- Find your SignalFx API key and Realm by going to [your profile](https://app.us1.signalfx.com/#/myprofile).

In my case the realm is us1.

## Set Up

You'll need to get your SignalFx token.

![SignalFx Tokens](https://jeffbailey.us/wp-content/uploads/2020/05/image-5.png)

Copy the token to a file with this command.

```bash
printf <YourToken> > config/signalfx-access-token.txt
```

## Build the container

```bash
docker build --rm -t learn-signalfx --build-arg signalfx_api_token=$(cat config/signalfx-access-token.txt) --build-arg signalfx_realm=<YourRealm> .
```

## Run the container

```bash
docker run --rm -it learn-signalfx /bin/bash
```