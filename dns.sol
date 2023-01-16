pragma solidity ^0.5.9;

contract DNS {
	struct Home{
		string name;
		bytes4 ipv4;
		bytes16 ipv6;
		address owner;
		mapping(string => Room) rooms;
	}

	struct Room {
		string name;
		uint port;
	}

	mapping (string => Home) public resolution;

	function resolveHome(string memory name) public view returns(bytes4, bytes16) {
		require(resolution[name].ipv4 != 0 || resolution[name].ipv6 != 0);
		return (resolution[name].ipv4, resolution[name].ipv6);
	}

	function resolveRoom(string memory home, string memory room) public view returns(bytes4, bytes16, uint){
		require(resolution[home].ipv4 != 0 || resolution[room].ipv6 != 0);
		require(resolution[home].rooms[room].port != 0);
		return (resolution[home].rooms[room].port, resolution[home].ipv4, resolution[room].ipv6);
	}

	function getHome(string memory name, bytes4 ipv4, bytes16 ipv6) public noDots(name){
		require(resolution[name].owner == address(0));
		resolution[name].name = name;
		resolution[name].ipv4 = ipv4;
		resolution[name].ipv6 = ipv6;
		resolution[name].owner = msg.sender;
	}

	function addRoom(string memory home, string memory name, uint port) public{
		require(msg.sender == resolution[home].owner);
		require(keccak256(bytes(resolution[home].rooms[name].name)) == keccak256(bytes("")) && resolution[home].rooms[name].port == 0);
		resolution[home].rooms[name] = Room(
			{name:name, port:port}
		);
	}

	function removeRoom(string memory home, string memory name) public {
		require(msg.sender == resolution[home].owner);
		delete resolution[home].rooms[name];
	}

	function deleteHome(string memory home) public{
		require(msg.sender == resolution[home].owner);
		delete resolution[home];
	}

	function changeHomeName(string memory old, string memory newN) public noDots(newN){
		require(msg.sender == resolution[old].owner);
		resolution[newN] = resolution[old];
		delete resolution[old];
		resolution[newN].name = newN;
	}

	function changeHomeIPs(string memory home, bytes4 ipv4, bytes16 ipv6) public {
		require(msg.sender == resolution[home].owner);
		resolution[home].ipv4 = ipv4;
		resolution[home].ipv6 = ipv6;
	}

	function changeRoomName(string memory home, string memory room, string memory newName) public{
		require(msg.sender == resolution[home].owner);
		resolution[home].rooms[newName] = resolution[home].rooms[room];
		resolution[home].rooms[newName].name = newName;
		delete resolution[home].rooms[room];
	}

	function changeRoomPort(string memory home, string memory room, uint newPort) public {
		require(msg.sender == resolution[home].owner);
		resolution[home].rooms[room].port = newPort;
	}

	modifier noDots(string memory name){
		bytes memory toBytes = bytes(name);
		for(uint i=0; i<toBytes.length; i++){
			if(toBytes[i] == "."){
				revert();
			}
		}
		_;
	}
}
