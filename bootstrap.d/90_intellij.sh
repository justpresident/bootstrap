IJ_CONF_PATH=$(ls -a1 $HOME | grep -e ^.Idea | tail -n1)

echo "Installing IntelliJ Idea configs into $IJ_CONF_PATH"

cp -rv ij_idea/* $HOME/$IJ_CONF_PATH/
