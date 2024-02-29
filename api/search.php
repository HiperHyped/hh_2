<?php
include_once 'DBSearch.php';

header('Content-Type: application/json');

function getData() {
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        return json_decode(file_get_contents('php://input'), true);
    } else if ($_SERVER['REQUEST_METHOD'] == 'GET') {
        return $_GET;
    } else {
        return [];
    }
}

$data = getData();

$searchType = $data['searchType'] ?? '';
$inputLimit = $data['inputLimit'] ?? 10; // Exemplo de limite padrão

$searchProduct = [
    'userId' => $data['userId'] ?? '',
    'searchType' => $searchType,
    'ean' => $data['ean'] ?? '',
    'nome' => $data['nome'] ?? '',
    'sigla' => $data['sigla'] ?? '',
    'marca' => $data['marca'] ?? '',
    'w1' => $data['w1'] ?? '',
    // Adicione outros campos conforme necessário
];

$dbSearch = new DBSearch();
try {
    $result = $dbSearch->searchProductV2($searchProduct, $inputLimit);
    echo json_encode(['success' => true, 'data' => $result]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>
