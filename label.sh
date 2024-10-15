if ! grep -q '.' ".env"; then
    sed -i '' "s/PLACEHOLDER_COLOR/White/g" ./utils/deployments/deployment-dev.yaml
else
    export $(grep -v '^#' .env | xargs)
    sed -i '' "s/PLACEHOLDER_COLOR/$COLOR/g" ./utils/deployments/deployment-dev.yaml
fi
