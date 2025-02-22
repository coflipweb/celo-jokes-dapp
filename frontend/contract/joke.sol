// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

/** @title Contact for the publication of a jokes */
contract JokesContact {

    // contract's owner address
    address owner;

    // set owner as contract's deployer
    constructor() {
        owner = msg.sender;
    }

    uint internal joke_counter = 0;
    uint internal category_counter = 0;

    struct Joke {
        string title;
        string content;
        uint category_id;
        address user;
        uint create_timestamp;
    }

    address[] internal users;

    mapping(uint => Joke) jokes;

    string[] categories;

    /** @dev checks if a contract caller is an owner of the contract */
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not an owner");
        _;
    }

    /** @dev adds user to all users list
     * @param user address of a joke owner
    */
    function addUser(address user) public {
        bool new_user = true;

        for(uint i = 0; i < users.length; i++) {
            if(users[i] == user) {
                new_user = false;
            }
        }
        
        // if user is a new user on the site, save his address
        if(new_user == true){
            users.push(user);
        }
    }

    /** @dev checks if user is an owner
     * @return bool
    */
    function isOwner() public view returns(bool) {
        return msg.sender == owner;
    }

    /**
     * @return all users addresses
    */
    function allUsers() public view returns(address[] memory){
        return users;
    }

    /** @dev adds a new joke to a list
     * @param joke_element object of a Joke struct
    */
    function addJoke(Joke calldata joke_element) public {
        require(msg.sender == joke_element.user, "You are now allowed");
        require(joke_counter + 1 <= type(uint256).max, "Counter overflow");
        require(joke_element.category_id < categories.length, "Invalid category_id");



        addUser(joke_element.user);

        jokes[joke_counter] = joke_element;

        joke_counter++;
    }

    /** @dev update an existing site
     * @param index index of a joke inside a contract
     * @param joke_element object of a Joke struct
    */
    function updateJoke(uint index, Joke calldata joke_element) public {
        require(msg.sender == joke_element.user, "You are now allowed");
        require(joke_element.category_id < categories.length, "Invalid category_id");


        jokes[index] = joke_element;
    }

    /** @dev adds a new category for jokes, only owners can do this
     * @param title title of a category
    */
    function addCategory(string memory title) public onlyOwner{
        require(category_counter + 1 <= type(uint256).max, "Counter overflow");

        categories.push(title);
    }

    /** @dev adds a new category for jokes, only owners can do this
     * @param index index of a category
    */
    function getCategory(uint index) public view returns(string memory){
        return categories[index];
    }

    /**
     * @return all categories
    */
    function allCategories() public view returns(string[] memory) {
        return categories;
    }

    /** @dev returns all jokes
     * @return Joke[] array of Joke structs
    */
    function allJokes() public view returns(Joke[] memory) {
        Joke[] memory f = new Joke[](joke_counter);

        for (uint256 i = 0; i < joke_counter; i++) {
            f[i] = jokes[i];
        }

        return f;
    }

    /** @dev removes a specific joke by it's index
     * @param index index of a joke
    */
    function removeJoke(uint index) public {
        require(msg.sender == jokes[index].user, "You are now allowed");

         // Swap the deleted joke with the last joke in the mapping
            uint last_index = joke_counter - 1;
            jokes[index] = jokes[last_index];
            delete jokes[last_index];
    
            joke_counter--;
    }

}