pragma solidity ^0.5.0;

contract iAuth {

    struct info {
        string nickname;
        string key;
        bool ableToGetInfo;
        string email;
        string phone;
    }

    mapping (address => bool) private exist;
    mapping (address => info) private infoMap;
    mapping (address => string) private certificationMap;

    function setExist(bool _b) public {
        exist[msg.sender] = _b;
    }
    function setInfo(string memory _nickname, string memory _key) public {
        require(exist[msg.sender] == true);
        infoMap[msg.sender].nickname = _nickname;
        infoMap[msg.sender].key = _key;
    }
    function setExtraInfo(string memory _email, string memory _phone) public {
        require(exist[msg.sender] == true);
        infoMap[msg.sender].email = _email;
        infoMap[msg.sender].phone = _phone;
    }
    function setGetable(bool _able) public {
        require(exist[msg.sender] == true);
        infoMap[msg.sender].ableToGetInfo = _able;
    }
    function setCertification(string memory text) public {
        require(exist[msg.sender] == true);
        certificationMap[msg.sender] = text;
    }
    function getInfo(address user) public view returns (string memory, string memory) {
        require(exist[user] == true);
        return (infoMap[user].nickname, infoMap[user].key);
    } 
    function userExisted(address user) public view returns (bool) {
        return exist[user];
    }
    function getCertificate(address user) public view returns (string memory) {
        require(exist[user] == true);
        return (certificationMap[user]);
    }
    function getExtraInfo(address user) public view returns (string memory, string memory) {
        require(infoMap[user].ableToGetInfo == true);
        return (infoMap[user].email, infoMap[user].phone);
    }    
}