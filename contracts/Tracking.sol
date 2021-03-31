pragma solidity ^0.5.10; //Versão do Solidity que será utilizada

contract Tracking { // define que vamos criar um contrato chamado "Tracking"

	enum Step { Supplier, SupplierToFactory, Factory, FactoryToStore }

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

	// Passo atual
	// Vai mudar ao longo do tempo
	// Inicia com o passo inicial
	Step public currentStep = Step.Supplier;

	// Método que será chamado, operará a máquina de status e realiza transações na blockchain.
	// 'function' determina que o código será uma função
	// 'next()' nome da função
	// 'public' modificador de acesso que determina o nível de visibilidade da função
	function next() public {
		if (currentStep == Step.Supplier) { 					//Verifica o passo atual
			supplierState++; 									// incrementa o status do passo atual
			if (supplierState == Finished) { 					// se o status do passo atual for finalizado
				currentStep = Step.SupplierToFactory; 			// Troca para a proxima etapa
			}
			return;												// Finaliza esse processo e pronto
		}
		if (currentStep == Step.SupplierToFactory) {
			supplierToFactoryState++;
			if (supplierToFactoryState == Finished) {
				currentStep = Step.Factory;
			}
			return;
		}
		if (currentStep == Step.Factory) {
			factoryState++;
			if (factoryState == Finished) {
				currentStep = Step.FactoryToStore;
			}
			return;
		}
		if (currentStep == Step.FactoryToStore) {
			if (factoryToStoreState == Finished) {
				revert("Process is already finished");			// Finaliza o processo dando um erro para o usuário informando que não é possível trocar os status do step
			}
			factoryToStoreState++;
			return;
		}


	}


}