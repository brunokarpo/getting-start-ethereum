pragma solidity ^0.5.10; //Versão do Solidity que será utilizada

contract Tracking { // define que vamos criar um contrato chamado "Tracking"

	enum Step { Supplier, SupplierToFactory, Factory, FactoryToStore, StoreVerification }

	// Constantes que definem os status de cada etapa
	// 'constant' define que é uma constante
	// 'uint8' tipo de dado inteiro sem sinal com 8 bits (Unsigned Integer)
	uint8 constant Waiting = 0;
	uint8 constant Running = 1;
	uint8 constant Finished = 2;


	// Estados da nossas máquinas de status
	// 'public' significa que esses dados poderão ser lidos
	// Supplier -> Factory -> Store
	uint8 public supplierState = Waiting;
	uint8 public supplierToFactoryState = Waiting;
	uint8 public factoryState = Waiting;
	uint8 public factoryToStoreState = Waiting;
	uint8 public storeVerificationState = Waiting;

	// Passo atual
	// Vai mudar ao longo do tempo
	// Inicia com o passo inicial
	Step public currentStep = Step.Supplier;

	// Roles
	// representa endereços
	address public supplier;
	address public factory;
	address public store;


	// Construtor do contrato
	constructor(address _supplier, address _factory, address _store) public {
		supplier = _supplier;
		factory = _factory;
		store = _store;
	}


	// Método que será chamado, operará a máquina de status e realiza transações na blockchain.
	// 'function' determina que o código será uma função
	// 'next()' nome da função
	// 'public' modificador de acesso que determina o nível de visibilidade da função
	function next() public {
		if (currentStep == Step.Supplier) { 					//Verifica o passo atual

			if(msg.sender != supplier) {						// Verifica se quem está chamando o método next é o endereço do supplier
				revert("User not allowed");						// Se não for, dá revert na transação, pois o usuário não pode alterar o status da operação
			}

			supplierState++; 									// incrementa o status do passo atual
			if (supplierState == Finished) { 					// se o status do passo atual for finalizado
				currentStep = Step.SupplierToFactory; 			// Troca para a proxima etapa
			}
			return;												// Finaliza esse processo e pronto
		}
		if (currentStep == Step.SupplierToFactory) {
			if(msg.sender != supplier) {						
				revert("User not allowed");						
			}

			supplierToFactoryState++;
			if (supplierToFactoryState == Finished) {
				currentStep = Step.Factory;
			}
			return;
		}
		if (currentStep == Step.Factory) {
			if(msg.sender != factory) {						
				revert("User not allowed");						
			}

			factoryState++;
			if (factoryState == Finished) {
				currentStep = Step.FactoryToStore;
			}
			return;
		}
		if (currentStep == Step.FactoryToStore) {
			if(msg.sender != factory) {						
				revert("User not allowed");						
			}

			factoryToStoreState++;
			if (factoryToStoreState == Finished) {
				currentStep = Step.StoreVerification;
			}
			return;
		}
		if (currentStep == Step.StoreVerification) {
			if(msg.sender != store) {						
				revert("User not allowed");						
			}

			if (storeVerificationState == Finished) {
				revert("Process is already finished");			// Finaliza o processo dando um erro para o usuário informando que não é possível trocar os status do step
			}
			storeVerificationState++;
			return;
		}
	}

}