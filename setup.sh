#!/env/bin bash

# pwd
# echo "$currdir"
script_dir=$(dirname "$(readlink -f "$0")")
echo "$script_dir"
# themesdir=$(dirname "$script_dir")

dotfilesdir="$HOME/dotfilesx"
# mkdir -vp "$dotfilesdir" 
# cp -vr "$script_dir/." "$dotfilesdir"
mkdir -pv "$HOME/.config/script_test"
echo "dotfiledir: $dotfilesdir"
cp -vr "$dotfilesdir/scripts/." "$HOME/.config/script_test"


