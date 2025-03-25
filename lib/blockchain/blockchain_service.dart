import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class BlockchainService {
  final String rpcUrl = "http://127.0.0.1:8545"; // Local Blockchain
  final String privateKey =
      "4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d";
  final String contractAddress =
      "0x5b1869D9A4C187F2EAa108f3062412ecf0526b24"; // Replace after deployment

  late Web3Client _client;
  late Credentials _credentials;
  late EthereumAddress _contractAddr;

  BlockchainService() {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
    _contractAddr = EthereumAddress.fromHex(contractAddress);
  }

  Future<void> addMedicalRecord(String fileHash) async {
    final contract = DeployedContract(
      ContractAbi.fromJson('''
[
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "user",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "ipfsHash",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "timestamp",
          "type": "uint256"
        }
      ],
      "name": "RecordAdded",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_ipfsHash",
          "type": "string"
        }
      ],
      "name": "addRecord",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getRecords",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "ipfsHash",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "timestamp",
              "type": "uint256"
            }
          ],
          "internalType": "struct MedicalRecords.Record[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]''', "MedicalRecords"),
      _contractAddr,
    );
    final function = contract.function("addRecord");

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [fileHash],
      ),
    );
  }

  Future<List<dynamic>> getMedicalRecords() async {
    final contract = DeployedContract(
      ContractAbi.fromJson('''
[
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "user",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "string",
          "name": "ipfsHash",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "timestamp",
          "type": "uint256"
        }
      ],
      "name": "RecordAdded",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "_ipfsHash",
          "type": "string"
        }
      ],
      "name": "addRecord",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getRecords",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "ipfsHash",
              "type": "string"
            },
            {
              "internalType": "uint256",
              "name": "timestamp",
              "type": "uint256"
            }
          ],
          "internalType": "struct MedicalRecords.Record[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]''', "MedicalRecords"),
      _contractAddr,
    );
    final function = contract.function("getRecords");

    return await _client
        .call(contract: contract, function: function, params: []);
  }
}
