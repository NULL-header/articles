dir_script=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd ${dir_script%/*} > /dev/null

cp ./md/*.md .

shopt -s extglob
rm -r !(!(README).md|.git|.|..)
popd > /dev/null
