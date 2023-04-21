# load env variables
source .env

# deploy using script
forge script ./script/Deploy.s.sol:DeployProxy --sig "run()" $CHAIN --rpc-url $RPC_URL --private-key $PRIVATE_KEY --slow -vvvvv \
 --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
# --resume # uncomment if continuing from a previous deployment