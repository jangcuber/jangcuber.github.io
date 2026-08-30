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

- [PinAnim](https://github.com/jangcuber/pinanim) — passcode-dot animations for
  rootless jailbreaks on iOS 14–26.
- [PanoramaPages](https://github.com/jangcuber/panoramapages) — one continuous
  panorama across Home Screen pages.
- [mineland](https://github.com/jangcuber/mineland) — an unofficial fork of
  34306/mineland with an off-by-default Dynamic Island activation toggle for
  rootless devices.
- [LSSeconds](https://github.com/jangcuber/LSSeconds) — lock-screen and
  status-bar seconds for iOS 17–18, with native clock positioning and
  wallpaper depth-effect support.
- [KnockControl](https://github.com/jangcuber/KnockControl) — Double tap to wake/sleep and swipe-to-unlock enhancements.
- [T9Dialer](https://github.com/jangcuber/T9Dialer) — Korean initial-consonant
  contact search, localized keypad images, and speed dial for the Phone app on
  iOS 16–18.

## License

Repository tooling and web assets are available under the [MIT License](LICENSE).
