// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract Store {

    // Dono do contrato;
    // Vai receber pagamentos para o dono do contrato
    address payable public owner;

    // Estoque e preco
    uint256 public price;
    uint64 public stock;

    // Mapa onde o address é o tipo de dados da chave e o uint256 é o tipo do valor do mapa
    mapping(address => uint256) points;

    // Mapping não dá o controle da quantidade de elementos. Mapping não permite iteração nos objetos dele
    // Essa variável aqui (array) permite iteracao para ajudar no mapping.
    address[] buyers;

    event NewSale(address indexed buyer, uint256 points);
    event ChangeReceipt(address indexed buyer, uint256 change);

    constructor(uint64 _stock, uint256 _price) public {
        owner = msg.sender;
        stock = _stock;
        price = _price;
    }

    function buy() payable public {
        require(stock > 0, "There are no products available.");
        require(msg.value >= price, "Value doesn't afford price.");

        uint256 change = msg.value % price;
        if(change > 0) {
            msg.sender.transfer(change);
            emit ChangeReceipt(msg.sender, change);
        }

        owner.transfer(msg.value - change);

        uint64 reward = uint64(msg.value / price); // Type cast para alinhar o tipo de dados

        if(points[msg.sender] == 0) buyers.push(msg.sender);
        points[msg.sender] += reward;

        emit NewSale(msg.sender, reward);

        stock -= reward;
    }


    // 'view' é uma chave que define que esse método não faz mudanças no contrato. É apenas um método de leitura
    function getPoints() public view returns(uint256) {
        uint256 total = 0;
        for(uint i=0; i<buyers.length; i++) {
            total += points [ buyers[i] ];
        }
        return total;
    }

    function getBalance(address buyer) public view returns(uint256) {
        return points[buyer];
    }

}