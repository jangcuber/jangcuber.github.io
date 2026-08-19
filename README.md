# jangcuber Repo

Public Sileo/APT repository for jailbreak tweaks by jangcuber.

Add this source in Sileo:

```text
https://jangcuber.github.io/
```

## Layout

```text
Release
Packages{,.gz,.bz2,.xz}
CydiaIcon{,@2x,@3x}.png
sileo-featured.json
debs/
depictions/<package>/
```

Place release packages below `debs/`, make sure their control metadata points
at the public depiction, then run:

```sh
./scripts/rebuild-repository.sh
```

The generator rebuilds the flat APT indexes. It intentionally omits
`Packages.zst` for compatibility with older Sileo builds.

## Packages

- [PanoramaPages](https://github.com/jangcuber/panoramapages) — one continuous
  panorama across Home Screen pages.
- [mineland](https://github.com/jangcuber/mineland) — an unofficial fork of
  34306/mineland with an off-by-default Dynamic Island activation toggle for
  rootless devices.

## License

Repository tooling and web assets are available under the [MIT License](LICENSE).
