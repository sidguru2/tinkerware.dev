version=$1
if [ -z "$version"]
  then
    version=1.10
fi

echo "Deploying tinkerware"

declare -a folders=("." "styles" "notate-ml" "dude" "dude-where's-my-ball")

for folder in "${folders[@]}"; do
  rm dist/${folder}/*.html
  rm dist/${folder}/*.css
  for filename in src/${folder}/*.css; do
    nmvers=`basename $filename .css`
    IFS="__" read nm vers <<< "$nmvers"
    cp src/${folder}/${nmvers}.css dist/${folder}/${nm}.css
    echo "Minified src/${folder}/${nmvers}.css..."
  done
  for filename in src/${folder}/*.html; do
    nm=`basename $filename .html`
    html-minifier \
          --collapse-whitespace \
          --remove-comments \
          --remove-optional-tags \
          --remove-redundant-attributes \
          --remove-script-type-attributes \
          --use-short-doctype \
          --minify-css true \
          --minify-js true \
          src/${folder}/${nm}.html > dist/${folder}/${nm}-tmp.html
    sed "s/__VERS/\.${version}/g" dist/${folder}/${nm}-tmp.html > dist/${folder}/${nm}.html
    rm dist/${folder}/${nm}-tmp.html
    echo "Minified src/${folder}/${nm}.html..."
  done
done



rsync -av src/images/ dist/images/
echo "Copied images"

aws s3 rm s3://tinkerware --recursive

aws s3 sync dist s3://tinkerware