dir_script=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd ${dir_script%/*}

dir_target="../md"
cp "$dir_target/*.md" .

shopt -s extglob
echo $(ls !(README).md)
popd
