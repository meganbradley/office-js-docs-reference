if [ -d "node_modules" ]; then
    rm -rf "node_modules"
fi

if [ -d "scripts/node_modules" ]; then
    rm -rf "scripts/node_modules"
fi

if [ -d "tools/node_modules" ]; then
    rm -rf "tools/node_modules"
fi

if [ ! -d "json" ]; then
    mkdir json
fi

if [ ! -d "yaml" ]; then
    mkdir yaml
fi

npm install

pushd scripts
npm install
npm run build
node preprocessor.js
popd


pushd tools
#mkdir tool-inputs
#npm install
#npm run build
popd

if [ ! -d "json/office" ]; then
    echo Running API Extractor for Office preview.
    pushd api-extractor-inputs-office
    ../node_modules/.bin/api-extractor run
    popd
fi

pushd scripts
    node midprocessor.js
popd

if [ ! -d "yaml/office" ]; then
    ./node_modules/.bin/api-documenter yaml --input-folder ./json/office --output-folder ./yaml/office --office
fi

pushd scripts
# node postprocessor.js
popd

pushd tools
# node coverage-tester.js
popd

wait
