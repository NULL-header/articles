dir_script=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
dir_base="$(dir_script)/.."
dir_target="$(dir_base)/md"
cp "$(dir_target)/*.md" ..

shopt -s extglob
echo $(ls !(README).md)
