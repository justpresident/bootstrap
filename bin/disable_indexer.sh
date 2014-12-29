sudo mv /usr/bin/baloo_file /usr/bin/baloo_file.orig
sudo ln -s /bin/true /usr/bin/baloo_file
sudo mv /usr/bin/baloo_file_cleaner /usr/bin/baloo_file_cleaner.orig
sudo ln -s /bin/true /usr/bin/baloo_file_cleaner
sudo mv /usr/bin/baloo_file_extractor /usr/bin/baloo_file_extractor.orig
sudo ln -s /bin/true /usr/bin/baloo_file_extractor
echo Indexing-Enabled=false >> $HOME/.kde/share/config/baloofilerc
ps ax | grep baloo
