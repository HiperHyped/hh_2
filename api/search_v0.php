<?php
include_once 'DBSearch.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    $dbSearch = new DBSearch();
    $searchType = $data['searchType'];
    $inputLimit = $data['inputLimit'];
    $searchProduct = [
        'userId' => $data['userId'],
        'searchType' => $searchType,
        'ean' => $data['ean'] ?? '',
        'nome' => $data['nome'] ?? '',
        'sigla' => $data['sigla'] ?? '',
        'marca' => $data['marca'] ?? '',
        'w1' => $data['w1'] ?? '',
        // Adicione outros campos conforme necessário
    ];

    try {
        $result = $dbSearch->searchProductV2($searchProduct, $inputLimit);
        echo json_encode(['success' => true, 'data' => $result]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => $e->getMessage()]);
    }
} else {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
