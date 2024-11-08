-include .env

all: clean remove install update build

clean  :; forge clean

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops --no-commit && forge install smartcontractkit/chainlink-brownie-contracts --no-commit

update:; forge update

build :; forge build

test-anvil :; forge test

test-sepolia :; @forge test --fork-url $(SEPOLIA_RPC_URL)

snapshot :; forge snapshot

format :; forge fmt

coverage :; forge coverage

deploy-anvil:
	@forge script script/FundMe.s.sol:FundMeScript --rpc-url $(ANVIL_RPC_URL) --private-key $(ANVIL_PRIVATE_KEY) --broadcast

deploy-sepolia:
	@forge script script/FundMe.s.sol:FundMeScript --rpc-url $(SEPOLIA_RPC_URL) --account $(SEPOLIA_ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv