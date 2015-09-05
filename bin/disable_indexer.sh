set -e

FAKE=/bin/true

for f in baloo_file baloo_file_cleaner baloo_file_extractor akonadi_baloo_indexer; do
    if [[ $(readlink -f /usr/bin/${f}) != $FAKE ]]; then
        sudo mv /usr/bin/${f} "${f}.orig"
        sudo ln -s ${FAKE} /usr/bin/$f
        sudo killall $f 
    else
        ls -la /usr/bin/${f}
    fi
done

echo Indexing-Enabled=false >> $HOME/.kde/share/config/baloofilerc
ps ax | grep baloo
