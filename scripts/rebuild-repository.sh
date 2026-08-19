#!/usr/bin/env bash

set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd -- "${script_dir}/.." && pwd -P)"
debs_dir="${repo_root}/debs"
staging_dir=""
index_files=(Packages Packages.gz Packages.bz2 Packages.xz)
static_repo_files=(
    CydiaIcon.png
    CydiaIcon@2x.png
    CydiaIcon@3x.png
    index.html
    sileo-featured.json
)

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

cleanup() {
    [[ -z "$staging_dir" || ! -d "$staging_dir" ]] || rm -rf -- "$staging_dir"
}

for command_name in dpkg-deb dpkg-scanpackages gzip bzip2 xz openssl awk; do
    command -v "$command_name" >/dev/null 2>&1 ||
        die "required command '$command_name' was not found"
done

[[ -d "$debs_dir" ]] || die "missing package directory '$debs_dir'"
for static_repo_file in "${static_repo_files[@]}"; do
    [[ -f "${repo_root}/${static_repo_file}" ]] ||
        die "missing repository file '${repo_root}/${static_repo_file}'"
done

package_count_on_disk="$(find "$debs_dir" -type f -name '*.deb' | wc -l | tr -d '[:space:]')"
[[ "$package_count_on_disk" -gt 0 ]] || die 'no .deb packages were found'

staging_dir="$(mktemp -d "${repo_root}/.repo-staging.XXXXXX")"
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

(
    cd -- "$repo_root"
    dpkg-scanpackages -m debs > "${staging_dir}/Packages.raw"
)

awk '
    $1 == "Package:" {
        panorama = ($2 == "com.jangcuber.panoramapages")
        mineland = ($2 == "com.34306.mineland")
        pinanim = ($2 == "net.sourceloc.pinanim")
        lsseconds = ($2 == "com.cm90.lsseconds")
        mineland_homepage = 0
        mineland_depiction = 0
        mineland_icon = 0
        mineland_sileo_depiction = 0
        pinanim_homepage = 0
        pinanim_depiction = 0
        pinanim_icon = 0
        pinanim_sileo_depiction = 0
        lsseconds_homepage = 0
        lsseconds_depiction = 0
        lsseconds_sileo_depiction = 0
    }
    panorama && $1 == "Homepage:" {
        print "Homepage: https://github.com/jangcuber/panoramapages"
        next
    }
    panorama && $1 == "Depiction:" {
        print "Depiction: https://jangcuber.github.io/depictions/panoramapages/"
        next
    }
    panorama && $1 == "Header:" {
        print "Header: https://jangcuber.github.io/depictions/panoramapages/assets/header.png"
        next
    }
    panorama && $1 == "Icon:" {
        print "Icon: https://jangcuber.github.io/depictions/panoramapages/assets/icon.png"
        next
    }
    panorama && tolower($1) == "sileodepiction:" {
        print "SileoDepiction: https://jangcuber.github.io/depictions/panoramapages/native.json"
        next
    }
    mineland && $1 == "Homepage:" {
        print "Homepage: https://github.com/jangcuber/mineland"
        mineland_homepage = 1
        next
    }
    mineland && $1 == "Depiction:" {
        print "Depiction: https://jangcuber.github.io/depictions/mineland/"
        mineland_depiction = 1
        next
    }
    mineland && $1 == "Icon:" {
        print "Icon: https://jangcuber.github.io/depictions/mineland/assets/icon.png"
        mineland_icon = 1
        next
    }
    mineland && tolower($1) == "sileodepiction:" {
        print "SileoDepiction: https://jangcuber.github.io/depictions/mineland/native.json"
        mineland_sileo_depiction = 1
        next
    }
    mineland && NF == 0 {
        if (!mineland_homepage)
            print "Homepage: https://github.com/jangcuber/mineland"
        if (!mineland_depiction)
            print "Depiction: https://jangcuber.github.io/depictions/mineland/"
        if (!mineland_icon)
            print "Icon: https://jangcuber.github.io/depictions/mineland/assets/icon.png"
        if (!mineland_sileo_depiction)
            print "SileoDepiction: https://jangcuber.github.io/depictions/mineland/native.json"
        print
        mineland = 0
        next
    }
    pinanim && $1 == "Homepage:" {
        print "Homepage: https://github.com/jangcuber/pinanim"
        pinanim_homepage = 1
        next
    }
    pinanim && $1 == "Depiction:" {
        print "Depiction: https://jangcuber.github.io/depictions/pinanim/"
        pinanim_depiction = 1
        next
    }
    pinanim && $1 == "Icon:" {
        print "Icon: https://jangcuber.github.io/depictions/pinanim/assets/icon.png"
        pinanim_icon = 1
        next
    }
    pinanim && tolower($1) == "sileodepiction:" {
        print "SileoDepiction: https://jangcuber.github.io/depictions/pinanim/native.json"
        pinanim_sileo_depiction = 1
        next
    }
    pinanim && NF == 0 {
        if (!pinanim_homepage)
            print "Homepage: https://github.com/jangcuber/pinanim"
        if (!pinanim_depiction)
            print "Depiction: https://jangcuber.github.io/depictions/pinanim/"
        if (!pinanim_icon)
            print "Icon: https://jangcuber.github.io/depictions/pinanim/assets/icon.png"
        if (!pinanim_sileo_depiction)
            print "SileoDepiction: https://jangcuber.github.io/depictions/pinanim/native.json"
        print
        pinanim = 0
        next
    }
    lsseconds && $1 == "Description:" {
        print "Description: Show seconds on the lock-screen clock and status-bar time on supported iOS versions."
        next
    }
    lsseconds && $1 == "Depends:" {
        print "Depends: mobilesubstrate, preferenceloader"
        next
    }
    lsseconds && $1 == "Homepage:" {
        print "Homepage: https://github.com/jangcuber/LSSeconds"
        lsseconds_homepage = 1
        next
    }
    lsseconds && $1 == "Depiction:" {
        print "Depiction: https://jangcuber.github.io/depictions/lsseconds/"
        lsseconds_depiction = 1
        next
    }
    lsseconds && tolower($1) == "sileodepiction:" {
        print "SileoDepiction: https://jangcuber.github.io/depictions/lsseconds/native.json"
        lsseconds_sileo_depiction = 1
        next
    }
    lsseconds && NF == 0 {
        if (!lsseconds_homepage)
            print "Homepage: https://github.com/jangcuber/LSSeconds"
        if (!lsseconds_depiction)
            print "Depiction: https://jangcuber.github.io/depictions/lsseconds/"
        if (!lsseconds_sileo_depiction)
            print "SileoDepiction: https://jangcuber.github.io/depictions/lsseconds/native.json"
        print
        lsseconds = 0
        next
    }
    { print }
' "${staging_dir}/Packages.raw" > "${staging_dir}/Packages"
rm -f -- "${staging_dir}/Packages.raw"

indexed_package_count="$(awk '$1 == "Package:" { count++ } END { print count + 0 }' "${staging_dir}/Packages")"
[[ "$indexed_package_count" -eq "$package_count_on_disk" ]] ||
    die "indexed $indexed_package_count packages; expected $package_count_on_disk"

for metadata_field in Package: Version: Architecture: Filename: Size: SHA256: Description:; do
    metadata_count="$(awk -v field="$metadata_field" '$1 == field { count++ } END { print count + 0 }' "${staging_dir}/Packages")"
    [[ "$metadata_count" -eq "$indexed_package_count" ]] ||
        die "expected '$metadata_field' in all package entries"
done

gzip -9 -n -c "${staging_dir}/Packages" > "${staging_dir}/Packages.gz"
bzip2 -9 -c "${staging_dir}/Packages" > "${staging_dir}/Packages.bz2"
xz -9 -c "${staging_dir}/Packages" > "${staging_dir}/Packages.xz"

architectures="$(awk '$1 == "Architecture:" && !seen[$2]++ { if (value) value = value " "; value = value $2 } END { print value }' "${staging_dir}/Packages")"
[[ -n "$architectures" ]] || die 'could not determine repository architectures'

{
    printf '%s\n' \
        'Origin: jangcuber' \
        'Label: jangcuber' \
        'Suite: stable' \
        'Version: 1.0' \
        'Codename: ios' \
        "Architectures: ${architectures}" \
        'Components: main' \
        'Description: jangcuber jailbreak tweak repository' \
        "Date: $(LC_ALL=C date -u '+%a, %d %b %Y %H:%M:%S +0000')"

    for checksum_spec in 'MD5Sum md5' 'SHA1 sha1' 'SHA256 sha256' 'SHA512 sha512'; do
        read -r section algorithm <<< "$checksum_spec"
        printf '%s:\n' "$section"
        for index_file in "${index_files[@]}"; do
            checksum="$(openssl dgst "-${algorithm}" "${staging_dir}/${index_file}" | awk '{ print $NF }')"
            size="$(wc -c < "${staging_dir}/${index_file}" | tr -d '[:space:]')"
            printf ' %s %16s %s\n' "$checksum" "$size" "$index_file"
        done
    done
} > "${staging_dir}/Release"

for index_file in Release "${index_files[@]}"; do
    cp -f -- "${staging_dir}/${index_file}" "${repo_root}/${index_file}"
done
rm -f -- "${repo_root}/Packages.zst"

trap - EXIT INT TERM
rm -rf -- "$staging_dir"
staging_dir=""

printf 'Repository rebuilt with %s package entries.\n' "$indexed_package_count"
printf 'Source: https://jangcuber.github.io/\n'
