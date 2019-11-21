#!/bin/bash -xe

podman build -t spotbugs-sphinx .
rm -rf .build

# extract messages from base document (en) to .pot files
podman run -it -v $(pwd)/..:/documents spotbugs-sphinx make gettext

# build .po files by new .pot files
podman run -it -v $(pwd)/..:/documents spotbugs-sphinx sphinx-intl update -p .build/locale -l ja

# build .po files by new .pot files
podman run -it -v $(pwd)/..:/documents spotbugs-sphinx sphinx-intl update -p .build/locale -l zh_CN

# build html files
podman run -it -v $(pwd)/..:/documents spotbugs-sphinx make html
podman run -it -v $(pwd)/..:/documents spotbugs-sphinx sphinx-build -D language=zh_CN -b html . .build/html_zh_CN
