// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    struct RedeemedItem {
        uint256 itemId;
        uint256 amount;
        string name;
    }

    mapping(address => RedeemedItem[]) private _redeemedItems;
    mapping(uint256 => string) private _itemNames;

    constructor() ERC20("Degen", "DGN") {
        // Initialize item names
        _itemNames[1] = "Space TShirt";
        _itemNames[2] = "DPass";
        _itemNames[3] = "DCup";
        _itemNames[4] = "DHoodie";  
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    function decimals() override public pure returns (uint8){
        return 0;
    }

    function transferTokens(address _receiver, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "You do not have enough Tokens");
        approve(msg.sender, amount);
        transferFrom(msg.sender, _receiver, amount);
    }

    function checkBalance() external view returns (uint) {
        return balanceOf(msg.sender);
    }

    function burnTokens(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "You do not have enough Tokens");
        _burn(msg.sender, amount);
    }

    function RedemptionItems() public pure returns (string memory) {
        return "1. Space TShirt = 69 \n 2. DPass = 99 /n 3. DCup = 75 /n 4.DHoodie = 199";
    }

    function getItemName(uint256 itemId) external view returns (string memory) {
        return _itemNames[itemId];
    }

    function getRedeemedItemsCount(address user) external view returns (uint) {
        return _redeemedItems[user].length;
    }

    function getRedeemedItem(address user, uint256 index) external view returns (uint256 itemId, uint256 amount, string memory name) {
        require(index < _redeemedItems[user].length, "Invalid index");
        RedeemedItem memory item = _redeemedItems[user][index];
        return (item.itemId, item.amount, item.name);
    }

    function redeemTokens(uint256 itemId) external payable {
        require(itemId <= 4, "Invalid selection of options. Please try again !");
        uint256 requiredAmount;
        if (itemId == 1) {
            requiredAmount = 69;
        } else if (itemId == 2) {
            requiredAmount = 99;
        } else if (itemId == 3){
            requiredAmount = 75;
        }else {
            requiredAmount = 199;
        }

        require(balanceOf(msg.sender) >= requiredAmount, "Insufficient Balance");
        approve(msg.sender, requiredAmount);
        transferFrom(msg.sender, owner(), requiredAmount);

        // Add the redeemed item to the user's list
        _redeemedItems[msg.sender].push(RedeemedItem(itemId, requiredAmount, _itemNames[itemId]));
    }
}
