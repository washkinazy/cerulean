# BlueBuild Template &nbsp; [![bluebuild build badge](https://github.com/washkinazy/cerulean/actions/workflows/build.yml/badge.svg)](https://github.com/washkinazy/cerulean/actions/workflows/build.yml)

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for setting up your own repository based on this template.

After setup, it is recommended you update this README to describe your custom image.

## Installation

> **Warning**  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/washkinazy/cerulean:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/washkinazy/cerulean:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). These ISOs cannot unfortunately be distributed on GitHub for free due to large sizes, so for public projects something else has to be used for hosting.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/washkinazy/cerulean
```
## UPDATES

- heavily inspired by wayblue / bluefin (insert link)
- mostly universal builds with a few vairants specific to my systems
- link to dots to extend 
- link to nwg shell site
- link to hypr dots inspirations

build imate
```bash
sudo podman run --rm --privileged \
    --volume .:/build-container-installer/build \
    --security-opt label=disable --pull=newer \
    ghcr.io/jasonn3/build-container-installer:latest \
    IMAGE_REPO="ghcr.io/washkinazy" \
    IMAGE_NAME="cerulean-main" \
    IMAGE_TAG="latest" \
    VARIANT="Silverblue" \
    ISO_NAME="${IMAGE_NAME}-${IMAGE_TAG}-${VARIANT}.iso"
```